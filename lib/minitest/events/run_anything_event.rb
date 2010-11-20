module MiniTest
  
  module Events
    
    class RunAnythingEvent < BaseEvent
      
      attr_reader :runner, :type, :output
      attr_accessor :test_count, :assertion_count, :report, :failures, :errors, :skips
      
      def initialize(runner, type)
        super()
        @runner = runner
        @output = runner.output
        @type = type
      end
      
    end
    
  end
  
end