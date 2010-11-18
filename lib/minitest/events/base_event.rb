module MiniTest
  
  module Events
    
    class BaseEvent
      
      attr_reader :start, :stop
      
      def initialize
        @start = Time.now
        @stop = nil
      end
      
      def complete!
        @stop = Time.now
        self
      end
      
      def duration
        @stop - @start
      end
      
    end
    
  end
  
end