module MiniTest
  
  class ProgressBar
  
    class RunAnythingStartHandler
    
      def initialize(event)
        @event = event
        @output = event.output
        @type = event.type
        @suites = event.suites
        @options = event.options
      end
    
      def call
        filter = @options[:filter] || '/./'
        filter = Regexp.new $1 if filter =~ /\/(.*)\//
        MiniTest::Unit.progress_bar = ::ProgressBar.new(@event.type.to_s.capitalize, @event.suites.inject(0) { |i, suite| i += suite.send("#{@event.type}_methods").grep(filter).size })
      end
    
    end
    
  end
  
end