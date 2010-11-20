module MiniTest
  
  class Unit
    
    COLORS = { :green =>  "\e[32m", :yellow => "\e[33m", :red => "\e[31m", :white => "\e[37m" }
    @@state = nil
    self.class.progress_bar = ProgressBar.new(type.to_s.capitalize, suites.inject(0) { |i, suite| i += suite.send("#{type}_methods").grep(filter).size })
    def state
      @@state || :green
    end

    def progress_bar
      self.class.progress_bar
    end

    def self.progress_bar
      @@progress_bar ||= ProgressBar.new("Tests")
    end

    def self.progress_bar=(bar)
      @@progress_bar = bar
    end
    
    private

    def print_skip(report)
      output.print COLORS[:yellow]
      print_report(report)
    end

    def print_fail(report)
      output.print COLORS[:red]
      print_report(report)
    end

    def print_error(report)
      output.print COLORS[:red]
      print_report(report)
    end

    def print_report(report)
      output.print "\e[K"
      output.puts
      output.puts "\n%3d) %s" % [@@report_count, report]
      puts
      output.flush
    end
    
  end
  
end