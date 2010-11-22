module MiniTest
  
  module Events
    
    class RunAnythingEvent < BaseEvent
      
      attr_reader :runner, :type, :output, :suites, :options
      attr_accessor :test_count, :assertion_count, :report, :failures, :errors, :skips
      
      def initialize(runner, type, suites, options)
        super()
        @runner = runner
        @output = runner.output
        @suites = suites
        @type = type
        @options = options
      end
      
    end
    
  end
  
end