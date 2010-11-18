module MiniTest
  
  module Events
    
    class RunTestSuitesEvent < BaseEvent
      
      def initialize(output, suites, type)
        super
      end
      
    end
    
  end
  
end