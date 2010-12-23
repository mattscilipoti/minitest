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

  def assert_report expected = nil
    expected ||= "Run options: --seed 42

# Running tests:

.

Finished tests in 0.00

1 tests, 1 assertions, 0 failures, 0 errors, 0 skips
"
    output = @output.string.sub(/Finished tests in .*/, "Finished tests in 0.00")
    output.sub!(/Loaded suite .*/, 'Loaded suite blah')
    output.sub!(/^(\s+)(?:#{Regexp.union(__FILE__, File.expand_path(__FILE__))}):\d+:/o, '\1FILE:LINE:')
    output.sub!(/\[(?:#{Regexp.union(__FILE__, File.expand_path(__FILE__))}):\d+\]/o, '[FILE:LINE]')
    assert_equal(expected, output)
  end

  def setup
    srand 42
    MiniTest::Unit::TestCase.reset
    @tu = MiniTest::Unit.new
    @output = StringIO.new("")
    MiniTest::Unit.output = @output
  end

  def teardown
    MiniTest::Unit.output = $stdout
    Object.send :remove_const, :ATestCase if defined? ATestCase
  end
  
  
end