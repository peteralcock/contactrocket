# Copyright (c) 2011-2016 Velo Inc.
#
#
#
#------------------------------------------------------------------------------
require 'rubygems/package_task'

Bundler::GemHelper.install_tasks

gemspec = eval(File.read('contact_rocket_crm.gemspec'))
Gem::PackageTask.new(gemspec) do |p|
  p.gem_spec = gemspec
end
