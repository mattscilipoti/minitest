module MiniTest
  
  class ProgressBar
  
    class RunAnythingFinishHandler
    
      def initialize(event)
        @event = event
        @output = event.output
        @runner = event.runner
        @type = event.type
        @suites = event.suites
        @options = event.options
      end
    
      def call
        @runner.progress_bar.finish
      end
    
    end
    
  end
  
end