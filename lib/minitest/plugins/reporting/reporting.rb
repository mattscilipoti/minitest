module MiniTest
  
  class Reporting < Plugin
    
    def self.enable!
      Dir[Pathname(__FILE__).dirname + "event_handlers/**/*.rb"].each { |file| require file }
      MiniTest::Unit.register_event_handler(:run_anything_start, MiniTest::Reporting::RunAnythingStartHandler)
      MiniTest::Unit.register_event_handler(:run_anything_finish, MiniTest::Reporting::RunAnythingFinishHandler)
    end
    
    def self.disable!
      
    end
    
  end
  
end