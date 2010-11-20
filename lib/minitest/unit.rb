require 'optparse'
require 'pathname'
require 'ruby-debug'
Dir[Pathname(__FILE__).dirname + "modules/**/*.rb"].each { |file| require file }
require 'minitest/events'
require 'minitest/assertions'
require 'minitest/test_case'
require 'progressbar'
require 'minitest/plugin'
require 'minitest/plugins/reporting/reporting'
require 'minitest/plugins/instafail/instafail'

##
# Minimal (mostly drop-in) replacement for test-unit.
#
# :include: README.txt

module MiniTest

  ##
  # Assertion base class

  class Assertion < Exception; end

  ##
  # Assertion raised when skipping a test

  class Skip < Assertion; end

  file = if RUBY_VERSION =~ /^1\.9/ then  # bt's expanded, but __FILE__ isn't :(
           File.expand_path __FILE__
         elsif  __FILE__ =~ /^[^\.]/ then # assume both relative
           require 'pathname'
           pwd = Pathname.new Dir.pwd
           pn = Pathname.new File.expand_path(__FILE__)
           relpath = pn.relative_path_from(pwd) rescue pn
           pn = File.join ".", relpath unless pn.relative?
           pn.to_s
         else                             # assume both are expanded
           __FILE__
         end

  # './lib' in project dir, or '/usr/local/blahblah' if installed
  MINI_DIR = File.dirname(File.dirname(file)) # :nodoc:

  def self.filter_backtrace bt # :nodoc:
    return ["No backtrace"] unless bt

    new_bt = []
    bt.each do |line|
      break if line.rindex MINI_DIR, 0
      new_bt << line
    end

    new_bt = bt.reject { |line| line.rindex MINI_DIR, 0 } if new_bt.empty?
    new_bt = bt.dup if new_bt.empty?
    new_bt
  end

  class Unit
    VERSION = "2.0.0" # :nodoc:
    include MiniTest::Events
    
    attr_accessor :report, :failures, :errors, :skips # :nodoc:
    attr_accessor :test_count, :assertion_count       # :nodoc:
    attr_accessor :start_time                         # :nodoc:
    attr_accessor :options                            # :nodoc:
    attr_accessor :help                               # :nodoc:
    attr_accessor :verbose                            # :nodoc:

    @@installed_at_exit ||= false
    @@out = $stdout

    ##
    # A simple hook allowing you to run a block of code after the
    # tests are done. Eg:
    #
    #   MiniTest::Unit.after_tests { p $debugging_info }

    def self.after_tests
      at_exit { at_exit { yield } }
    end

    ##
    # Registers MiniTest::Unit to run tests at process exit

    def self.autorun
      at_exit {
        next if $! # don't run if there was an exception
        exit_code = MiniTest::Unit.new.run ARGV
        exit false if exit_code && exit_code != 0
      } unless @@installed_at_exit
      @@installed_at_exit = true
    end

    ##
    # Returns the stream to use for output.

    def self.output
      @@out
    end

    ##
    # Returns the stream to use for output.
    #
    # DEPRECATED: use ::output instead.

    def self.out
      warn "::out deprecated, use ::output instead." if $VERBOSE
      output
    end

    ##
    # Sets MiniTest::Unit to write output to +stream+.  $stdout is the default
    # output

    def self.output= stream
      @@out = stream
    end

    ##
    # Return all plugins' run methods (methods that start with "run_").

    def self.plugins
      @@plugins ||= (["run_tests"] +
                     public_instance_methods(false).
                     grep(/^run_/).map { |s| s.to_s }).uniq
    end

    def output
      self.class.output
    end

    def puts *a  # :nodoc:
      output.puts(*a)
    end

    def print *a # :nodoc:
      output.print(*a)
    end

    def _run_anything type
      suites = TestCase.send "#{type}_suites"
      return if suites.empty?
      event = RunAnythingEvent.new(self, type)
      
      raise_event(:run_anything_start, event)

      event.test_count, event.assertion_count = 0, 0
      sync = output.respond_to? :"sync=" # stupid emacs
      old_sync, output.sync = output.sync, true if sync

      results = _run_suites suites, type

      @test_count = event.test_count = results.inject(0) { |sum, (tc, ac)| sum + tc }
      @assertion_count = event.assertion_count = results.inject(0) { |sum, (tc, ac)| sum + ac }
      event.report, event.failures, event.errors, event.skips = report, failures, errors, skips
      
      output.sync = old_sync if sync

      raise_event(:run_anything_finish, event.complete!)
    end

    def _run_suites suites, type
      event = RunTestSuitesEvent.new(self, suites, type)
      raise_event(:run_test_suites_start, event)
      filter = options[:filter] || '/./'
      filter = Regexp.new $1 if filter =~ /\/(.*)\//

      results = suites.map { |suite| _run_suite suite, type }
      raise_event(:run_test_suites_finish, event.complete!)
      results
    end

    def _run_suite(suite, type)
      suite_event = RunTestSuiteEvent.new(self, suite, type)
      raise_event(:run_test_suite_start, suite_event)

      filter = options[:filter] || '/./'
      filter = Regexp.new $1 if filter =~ /\/(.*)\//

      methods = suite.send("#{type}_methods").grep(filter)

      assertions = methods.map { |method|
        inst = suite.new method
        inst._assertions = 0
        run_event = RunTestEvent.new(self, inst)
        raise_event(:run_test_start, run_event)

        run_event.result = inst.run self
        
        raise_event(:run_test_finish, run_event.complete!)
        inst._assertions
      }
      
      raise_event(:run_test_suite_finish, suite_event.complete!)
      return assertions.size, assertions.inject(0) { |sum, n| sum + n }
    end

    def location e # :nodoc:
      last_before_assertion = ""
      e.backtrace.reverse_each do |s|
        break if s =~ /in .(assert|refute|flunk|pass|fail|raise|must|wont)/
        last_before_assertion = s
      end
      last_before_assertion.sub(/:in .*$/, '')
    end

    ##
    # Writes status for failed test +meth+ in +klass+ which finished with
    # exception +e+

    def puke klass, meth, e
      e = case e
          when MiniTest::Skip then
            @skips += 1
            "Skipped:\n#{meth}(#{klass}) [#{location e}]:\n#{e.message}\n"
          when MiniTest::Assertion then
            @failures += 1
            "Failure:\n#{meth}(#{klass}) [#{location e}]:\n#{e.message}\n"
          else
            @errors += 1
            bt = MiniTest::filter_backtrace(e.backtrace).join "\n    "
            "Error:\n#{meth}(#{klass}):\n#{e.class}: #{e.message}\n    #{bt}\n"
          end
      @report << e
      e[0, 1]
    end

    def initialize # :nodoc:
      @report = []
      @errors = @failures = @skips = 0
      @verbose = false
    end

    def process_args args = []
      options = {}
      orig_args = args.dup

      OptionParser.new do |opts|
        opts.banner  = 'minitest options:'
        opts.version = MiniTest::Unit::VERSION

        opts.on '-h', '--help', 'Display this help.' do
          puts opts
          exit
        end

        opts.on '-s', '--seed SEED', Integer, "Sets random seed" do |m|
          options[:seed] = m.to_i
        end

        opts.on '-v', '--verbose', "Verbose. Show progress processing files." do
          options[:verbose] = true
        end

        opts.on '-n', '--name PATTERN', "Filter test names on pattern." do |a|
          options[:filter] = a
        end

        opts.parse! args
        orig_args -= args
      end

      unless options[:seed] then
        srand
        options[:seed] = srand % 0xFFFF
        orig_args << "--seed" << options[:seed].to_s
      end

      srand options[:seed]

      self.verbose = options[:verbose]
      @help = orig_args.map { |s| s =~ /[\s|&<>$()]/ ? s.inspect : s }.join " "

      options
    end

    ##
    # Top level driver, controls all output and filtering.

    def run args = []
      self.options = process_args args

      puts "Run options: #{help}"

      self.class.plugins.each do |plugin|
        send plugin
        break unless report.empty?
      end

      return failures + errors if @test_count > 0 # or return nil...
    rescue Interrupt
      abort 'Interrupted'
    end

    ##
    # Runs test suites matching +filter+.

    def run_tests
      _run_anything :test
    end

    ##
    # Writes status to +io+

    def status io = self.output
      format = "%d tests, %d assertions, %d failures, %d errors, %d skips"
      io.puts format % [test_count, assertion_count, failures, errors, skips]
    end

  end # class Unit
end # module MiniTest

if $DEBUG then
  module Test                # :nodoc:
    module Unit              # :nodoc:
      class TestCase         # :nodoc:
        def self.inherited x # :nodoc:
          # this helps me ferret out porting issues
          raise "Using minitest and test/unit in the same process: #{x}"
        end
      end
    end
  end
end

MiniTest::Reporting.enable!
MiniTest::Instafail.enable!