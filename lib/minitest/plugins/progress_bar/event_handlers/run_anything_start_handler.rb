module MiniTest
  
  class Reporting
  
    class RunAnythingStartHandler
    
      def initialize(event)
        @event = event
        @output = event.output
        @type = event.type
      end
    
      def call
        @output.puts
        @output.puts "# Running #{@type}s:"
        @output.puts
      end
    
    end
    
  end
  
end