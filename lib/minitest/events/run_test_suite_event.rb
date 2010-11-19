module MiniTest
  
  module Events
    
    class RunTestSuiteEvent < BaseEvent
      
      def initialize(output, suite, type)
        super()
      end
      
    end
    
  end
  
end