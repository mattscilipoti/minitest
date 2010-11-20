module MiniTest
  
  module Events
    
    class RunTestEvent < BaseEvent
      
      attr_reader :runner, :output, :suite_instance
      attr_accessor :result
      
      def initialize(runner, suite_instance)
        super()
        @runner = runner
        @output = runner.output
        @suite_instance = suite_instance
      end
      
    end
    
  end
  
end