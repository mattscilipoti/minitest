module MiniTest
  class ProgressBar
    class RunTestFinishHandler
      include MiniTest::ColorHelpers
      
      def initialize(event)
        @event = event
        @runner = event.runner
        @output = event.output
        @result = event.result
      end
    
      def call
        case @result
        when "F", "E"
          @runner.state = :red
        when "S"
          @runner.state = :yellow unless @runner.state == :red
        end
        
        with_color do
          @runner.progress_bar.inc
        end
      end
    
      private
    
      def with_color
        @output.print COLORS[@runner.state]
        yield
        @output.print "\e[0m"
      end
    
    end
  end
end