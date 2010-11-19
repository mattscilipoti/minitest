module MiniTest
  
  module Events
    
    class RunAnythingEvent < BaseEvent
      
      attr_reader :output, :type
      attr_accessor :test_count, :assertion_count, :report, :failures, :errors, :skips
      
      def initialize(output, type)
        super()
        @output = output
        @type = type
      end
      
    end
    
  end
  
end