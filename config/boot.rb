ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

# Set up gems listed in the Gemfile.
require 'bundler/setup' if File.exist?(ENV['BUNDLE_GEMFILE'])
# TODO: Seems it gives a circular dependency, when running with `derailed`, commenting for now to move forward
# begin
#   require 'bootsnap/setup'
# rescue LoadError
#   # bootsnap is an optional dependency, so if we don't have it, it's fine
# end
