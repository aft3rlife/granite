.PHONY: modules gems ruby_gems ruby_gems_deployment ruby_gems_deploy node_modules build run clean dist shrinkwrap

APP_NAME = solid

BUZZFEED_LOCAL = /buzzfeed/local

BUNDLE_PATH = $(BUZZFEED_LOCAL)/bundle/$(APP_NAME)
export BUNDLE_PATH
# e.g. can be set to BUNDLE_ARGS='--deployment' when deploying
BUNDLE_ARGS =

# DEV: dev target additionally installs modules and runs db migraitons
dev: modules build

# update all code depenendencies
modules: ruby_gems node_modules

# install ruby gems from Gemfile/Gemfile.lock
ruby_gems:
	bundle install --path=$(BUNDLE_PATH) --clean $(BUNDLE_ARGS)

# compile binaries for download
# * executed on build
# * not re-run by jekyll serve
dist: build
	grunt compile_lib
	grunt minify_lib
	grunt latest_solid
	grunt zip_lib

# compress docs so that they can
# be attached to a github release
release_docs: build
	grunt copy_deploy_dist
	grunt compress_release_docs
	open .tmp/

# clean out generated files
clean:
	rm -fr _site/
	rm -fr _deploy/
	rm -fr .tmp/

# run the jekyll server
run:
	grunt exec:inject_version
	(cd docs/ && bundle exec jekyll serve)

# build static site into _site
build:
	grunt exec:inject_version
	(cd docs/ && bundle exec jekyll build)

# install node modules from npm-shrinkwrap.json
node_modules:
	npm install
	npm prune

# shrinkwrap node modules
# * installs modules from package.json
# * prunes modules we don't need
# * generates npm-shrinkwrap.json
shrinkwrap:
	npm install --no-shrinkwrap
	npm prune
	npm shrinkwrap --dev
