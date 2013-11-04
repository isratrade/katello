# When adding new version requirement check out EPEL6 repository first
# and use this version if possible. Also check Fedora version (usually higher).
# With a pull request, send also link to our (or Fedora) koji with RPMs.
source 'http://rubygems.org'

# Load all sub-gemfiles from bundler.d directory
Dir[File.expand_path('bundler.d/*.rb', File.dirname(__FILE__))].each do |bundle|
  self.instance_eval(Bundler.read_file(bundle), bundle)
end

# Declare your gem's dependencies in katello.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# gems used by dummy application
gem "jquery-rails"
gem 'pg'
group :assets do
  gem 'sass-rails', '~> 3.2.3'
end
