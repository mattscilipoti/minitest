module MiniTest
  
  class Plugin
    
    def self.enable!
      raise "Plugin#enable must be implemented by inheriting class!"
    end
    
    def self.disable!
      raise "Plugin#disable must be implemented by inheriting class!"
    end
    
  end
  
end