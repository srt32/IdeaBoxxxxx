ENV['RACK_ENV'] = 'test'

require 'bundler'
Bundler.require

require 'rack/test'
require 'minitest/autorun'
require 'minitest/pride'

require_relative '../../lib/idea_box/group'
