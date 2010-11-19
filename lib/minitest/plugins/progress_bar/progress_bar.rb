module MiniTest
  
  class ProgressBar
    
    def self.enable!
      Dir[Pathname(__FILE__).dirname + "event_handlers/**/*.rb"].each { |file| require file }
    end
    
    def self.disable!
      
    end
    
  end
  
end