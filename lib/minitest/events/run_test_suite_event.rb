module MiniTest
  
  module Events
    
    class RunTestSuiteEvent < BaseEvent
      
      attr_reader :runner, :output, :suite, :type
      
      def initialize(runner, suite, type)
        super()
        @runner = runner
        @output = runner.output
        @suite = suite
        @type = type
      end
      
    end
    
  end
  
end