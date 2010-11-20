module MiniTest
  class Instafail  
    class RunTestFinishHandler
      include MiniTest::ColorHelpers
      PADDING = '     '
      
      def initialize(event)
        @event = event
        @runner = event.runner
        @output = event.output
        @suite_instance = event.suite_instance
      end
    
      def call
        if report = @runner.report.pop
          @runner.report_count += 1
          @output.print "\e[K"
          @output.puts
          case report[0,1]
          when 'E','F'
            handle_fail(report)
          when 'S'
            handle_skip(report)
          else
            # wtf
          end
        else
          @output.print "."
        end
      end
      
      private
      
      def handle_fail(report)
        report_lines = report.split("\n")
        @output.puts red("\n%3d) %s" % [@runner.report_count, report_lines.shift + " " + report_lines.shift])
        report_lines.each do |line|
          @output.puts grey("#{PADDING}#{line}")
        end
      end
      
      def handle_skip(report)
        report_lines = report.split("\n")
        @output.puts yellow("\n%3d) %s" % [@runner.report_count, report_lines.shift + " " + report_lines.shift])
        report_lines.each do |line|
          @output.puts grey("#{PADDING}#{line}")
        end
      end
    
    end
  end
end