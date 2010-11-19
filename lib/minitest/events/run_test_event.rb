module MiniTest
  
  module Events
    
    class RunTestEvent < BaseEvent
      
      def initialize(output, suite_instance)
        super()
      end
      
    end
    
  end
  
end