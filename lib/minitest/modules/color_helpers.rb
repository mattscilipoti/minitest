module MiniTest
  
  module ColorHelpers
    
    COLORS = { :green =>  "\e[32m", :yellow => "\e[33m", :red => "\e[31m", :white => "\e[37m" }
    
    def color(text, color_code)
      "#{color_code}#{text}\e[0m"
    end

    def bold(text)
      color(text, "\e[1m")
    end

    def white(text)
      color(text, "\e[37m")
    end

    def green(text)
      color(text, "\e[32m")
    end

    def red(text)
      color(text, "\e[31m")
    end

    def magenta(text)
      color(text, "\e[35m")
    end

    def yellow(text)
      color(text, "\e[33m")
    end

    def blue(text)
      color(text, "\e[34m")
    end

    def grey(text)
      color(text, "\e[90m")
    end
    
  end
  
end