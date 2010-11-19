module MiniTest
  
  class RunTestFinishHandler
    
    def initialize(event)
      
    end
    
    def call
      case a
      when ["."] then
        # do nothing
      when ["E"] then
        current_state = "error"
        @@state = :red
      when ["F"] then
        current_state = "fail"
        @@state = :red
      when ["S"] then
        current_state = "skip"
        @@state ||= :yellow
      else
        # nothing
      end
      if report = @report.pop
        @@report_count += 1
        self.send("print_#{current_state}", report)
      end
      output.print COLORS[state]
      progress_bar.inc
      output.print COLORS[:white]
    end
    
  end
  
end