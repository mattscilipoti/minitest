module MiniTest
  
  module Events
    
    class RunTestSuitesEvent < BaseEvent
      
      attr_accessor :runner, :output, :suites, :type
      
      def initialize(runner, suites, type)
        super()
        @runner = runner
        @output = runner.output
        @suites = suites
        @type = type
      end
      
    end
    
  end
  
end