module MiniTest
  class Reporting  
    class RunTestFinishHandler
      
      def initialize(event)
        @event = event
        @runner = event.runner
        @output = event.output
        @suite_instance = event.suite_instance
      end
    
      def call
        @output.print "#{suite}##{method} = %.2f s = " % time if @runner.verbose
        @output.print @event.result
        @output.puts if @runner.verbose
      end
    
    end
  end
end