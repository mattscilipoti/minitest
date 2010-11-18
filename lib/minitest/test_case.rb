##
# Subclass TestCase to create your own tests. Typically you'll want a
# TestCase subclass per implementation class.
#
# See MiniTest::Assertions
module MiniTest
  
  class Unit
    
    class TestCase
      attr_reader :__name__ # :nodoc:

      PASSTHROUGH_EXCEPTIONS = [NoMemoryError, SignalException,
                                Interrupt, SystemExit] # :nodoc:

      SUPPORTS_INFO_SIGNAL = Signal.list['INFO'] # :nodoc:

      ##
      # Runs the tests reporting the status to +runner+

      def run runner
        trap "INFO" do
          time = Time.now - runner.start_time
          warn "%s#%s %.2fs" % [self.class, self.__name__, time]
          runner.status $stderr
        end if SUPPORTS_INFO_SIGNAL

        result = ""
        begin
          @passed = nil
          self.setup
          self.__send__ self.__name__
          result = "." unless io?
          @passed = true
        rescue *PASSTHROUGH_EXCEPTIONS
          raise
        rescue Exception => e
          @passed = false
          result = runner.puke self.class, self.__name__, e
        ensure
          begin
            self.teardown
          rescue *PASSTHROUGH_EXCEPTIONS
            raise
          rescue Exception => e
            result = runner.puke self.class, self.__name__, e
          end
          trap 'INFO', 'DEFAULT' if SUPPORTS_INFO_SIGNAL
        end
        result
      end

      def initialize name # :nodoc:
        @__name__ = name
        @__io__ = nil
        @passed = nil
      end

      def io
        @__io__ = true
        MiniTest::Unit.output
      end

      def io?
        @__io__
      end

      def self.reset # :nodoc:
        @@test_suites = {}
      end

      reset

      def self.inherited klass # :nodoc:
        @@test_suites[klass] = true
      end

      ##
      # Defines test order and is subclassable. Defaults to :random
      # but can be overridden to return :alpha if your tests are order
      # dependent (read: weak).

      def self.test_order
        :random
      end

      def self.test_suites # :nodoc:
        @@test_suites.keys.sort_by { |ts| ts.name.to_s }
      end

      def self.test_methods # :nodoc:
        methods = public_instance_methods(true).grep(/^test/).map { |m| m.to_s }

        case self.test_order
        when :random then
          max = methods.size
          methods.sort.sort_by { rand max }
        when :alpha, :sorted then
          methods.sort
        else
          raise "Unknown test_order: #{self.test_order.inspect}"
        end
      end

      ##
      # Returns true if the test passed.

      def passed?
        @passed
      end

      ##
      # Runs before every test. Use this to refactor test initialization.

      def setup; end

      ##
      # Runs after every test. Use this to refactor test cleanup.

      def teardown; end

      include MiniTest::Assertions
    end # class TestCase
    
  end
  
end