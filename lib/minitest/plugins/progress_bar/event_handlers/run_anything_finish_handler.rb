module MiniTest
  
  class Reporting
    
    class RunAnythingFinishHandler
    
      def initialize(event)
        @event = event
        @output = event.output
        @type = event.type
      end
    
      def call
        @output.puts
        @output.puts
        t = @event.duration
        @output.puts "Finished #{@type}s in %.6fs, %.4f tests/s, %.4f assertions/s." %
          [t, @event.test_count / t, @event.assertion_count / t]

        @event.report.each_with_index do |msg, i|
          @output.puts "\n%3d) %s" % [i + 1, msg]
        end

        @output.puts
      
        format = "%d tests, %d assertions, %d failures, %d errors, %d skips"
        @output.puts format % [@event.test_count, @event.assertion_count, @event.failures, @event.errors, @event.skips]
      end
    
    end
    
  end
  
end