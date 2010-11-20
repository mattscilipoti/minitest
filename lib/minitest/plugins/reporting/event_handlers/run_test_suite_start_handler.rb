module MiniTest
  class Reporting  
    class RunTestSuiteStartHandler
    
      def initialize(event)
        @event = event
        @runner = event.runner
        @type = event.type
        @suite = event.suite
        @output = @runner.output
      end
    
      def call
        header = "#{@type}_suite_header"
        @output.puts send(header, @suite) if respond_to? header
      end
    
    end
  end
end