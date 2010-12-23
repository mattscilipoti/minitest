require 'stringio'
require 'pathname'
require 'minitest/unit'

MiniTest::Unit.autorun

module MyModule; end
class AnError < StandardError; include MyModule; end

class TestMiniTestUnit < MiniTest::Unit::TestCase
  pwd = Pathname.new(File.expand_path(Dir.pwd))
  basedir = Pathname.new(File.expand_path(MiniTest::MINI_DIR)) + 'mini'
  basedir = basedir.relative_path_from(pwd).to_s
  MINITEST_BASE_DIR = basedir[/\A\./] ? basedir : "./#{basedir}"
  BT_MIDDLE = ["#{MINITEST_BASE_DIR}/test.rb:161:in `each'",
               "#{MINITEST_BASE_DIR}/test.rb:158:in `each'",
               "#{MINITEST_BASE_DIR}/test.rb:139:in `run'",
               "#{MINITEST_BASE_DIR}/test.rb:106:in `run'"]