module MiniTest
  
  class ProgressBar
    
    def self.enable!
      Dir[Pathname(__FILE__).dirname + "event_handlers/**/*.rb"].each { |file| require file }
      MiniTest::Unit.register_event_handler(:run_test_finish, MiniTest::ProgressBar::RunTestFinishHandler)
      MiniTest::Unit.register_event_handler(:run_anything_start, MiniTest::ProgressBar::RunAnythingStartHandler)
      MiniTest::Unit.register_event_handler(:run_anything_finish, MiniTest::ProgressBar::RunAnythingFinishHandler)
      MiniTest::Unit.unregister_event_handler(:run_test_finish, MiniTest::Reporting::RunTestFinishHandler)
    end
    
    def self.disable!
      MiniTest::Unit.unregister_event_handler(:run_test_finish, MiniTest::ProgressBar::RunTestFinishHandler)
      MiniTest::Unit.unregister_event_handler(:run_anything_start, MiniTest::ProgressBar::RunAnythingStartHandler)
      MiniTest::Unit.unregister_event_handler(:run_anything_finish, MiniTest::ProgressBar::RunAnythingFinishHandler)
      MiniTest::Unit.register_event_handler(:run_test_finish, MiniTest::Reporting::RunTestFinishHandler)
    end
    
  end
  
end

module MiniTest
  
  class Unit
    
    @@state = nil
    
    def state
      self.class.state
    end
    
    def state=(new_state)
      @@state = new_state
    end
    
    def self.state
      @@state ||= :green
    end
    
    def self.state=(new_state)
      @@state = new_state
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
    
  end
  
end