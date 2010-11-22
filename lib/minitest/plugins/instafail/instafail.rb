module MiniTest
  
  class Instafail < Plugin
    
    def self.enable!
      Dir[Pathname(__FILE__).dirname + "event_handlers/**/*.rb"].each { |file| require file }
      MiniTest::Unit.register_event_handler(:run_test_finish, MiniTest::Instafail::RunTestFinishHandler)
      MiniTest::Unit.unregister_event_handler(:run_test_finish, MiniTest::Reporting::RunTestFinishHandler)
    end
    
    def self.disable!
      MiniTest::Unit.unregister_event_handler(:run_test_finish, MiniTest::Instafail::RunTestFinishHandler)
      MiniTest::Unit.register_event_handler(:run_test_finish, MiniTest::Reporting::RunTestFinishHandler)
    end
    
  end
  
end

module MiniTest
  
  class Unit
    
    def self.report_count
      @@report_count ||= 0
    end
    
    def self.report_count=(n)
      @@report_count = n
    end
    
    def report_count
      self.class.report_count
    end
    
    def report_count=(n)
      self.class.report_count = n
    end
    
  end
  
end