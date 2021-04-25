# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'sinatra/activerecord/rake'

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
end

task default: :spec

namespace :db do
  task :load_config do
    require './config/environment'
  end
end
