module MiniTest
  
  class Reporting < Plugin
    
    def self.enable!
      Dir[Pathname(__FILE__).dirname + "event_handlers/**/*.rb"].each { |file| require file }
      MiniTest::Unit.register_event_handler(:run_anything_start, MiniTest::Reporting::RunAnythingStartHandler)
      MiniTest::Unit.register_event_handler(:run_anything_finish, MiniTest::Reporting::RunAnythingFinishHandler)
      MiniTest::Unit.register_event_handler(:run_test_suites_start, MiniTest::Reporting::RunTestSuitesStartHandler)
      MiniTest::Unit.register_event_handler(:run_test_suites_finish, MiniTest::Reporting::RunTestSuitesFinishHandler)
      MiniTest::Unit.register_event_handler(:run_test_suite_start, MiniTest::Reporting::RunTestSuiteStartHandler)
      MiniTest::Unit.register_event_handler(:run_test_suite_finish, MiniTest::Reporting::RunTestSuiteFinishHandler)
      MiniTest::Unit.register_event_handler(:run_test_start, MiniTest::Reporting::RunTestStartHandler)
      MiniTest::Unit.register_event_handler(:run_test_finish, MiniTest::Reporting::RunTestFinishHandler)
    end
    
    def self.disable!
      MiniTest::Unit.unregister_event_handler(:run_anything_start, MiniTest::Reporting::RunAnythingStartHandler)
      MiniTest::Unit.unregister_event_handler(:run_anything_finish, MiniTest::Reporting::RunAnythingFinishHandler)
      MiniTest::Unit.unregister_event_handler(:run_test_suites_start, MiniTest::Reporting::RunTestSuitesStartHandler)
      MiniTest::Unit.unregister_event_handler(:run_test_suites_finish, MiniTest::Reporting::RunTestSuitesFinishHandler)
      MiniTest::Unit.unregister_event_handler(:run_test_suite_start, MiniTest::Reporting::RunTestSuiteStartHandler)
      MiniTest::Unit.unregister_event_handler(:run_test_suite_finish, MiniTest::Reporting::RunTestSuiteFinishHandler)
      MiniTest::Unit.unregister_event_handler(:run_test_start, MiniTest::Reporting::RunTestStartHandler)
      MiniTest::Unit.unregister_event_handler(:run_test_finish, MiniTest::Reporting::RunTestFinishHandler)
    end
    
  end
  
end