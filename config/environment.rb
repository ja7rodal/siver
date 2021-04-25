# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'sinatra/activerecord'

ENV['RACK_ENV'] = 'development' if ENV['RACK_ENV'].nil?
Bundler.require(:default, ENV['RACK_ENV'])

APP_ROOT = Pathname.new(File.expand_path('..', __dir__))
APP_NAME = APP_ROOT.basename.to_s
require APP_ROOT.join('lib/app')
Dir["#{APP_ROOT}/lib/**/*.rb"].sort.each { |file| require file }
Figaro::Application.new(environment: ENV['RACK_ENV'], path: 'config/application.yml').load

# set :database, { adapter: "sqlite3", database: "foo.sqlite3" }
set :database_file, '../config/database.yml'
