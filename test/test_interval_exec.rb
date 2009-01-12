require File.dirname(__FILE__) + '/test_helper.rb'

module Kernel  
  # cattr_accessor to store expected sleep value
  @@expected_sleep = nil
  def self.expected_sleep= val
    @@expected_sleep = val
  end
     
  def expected_sleep
    @@expected_sleep
  end
  
  # Stubbed sleep raises exception if request isn't approx equal to expected_sleep
  def self.sleep requested_sec
    raise "No sleep expectation defined" if self.expected_sleep.nil?
    sleep_delta = self.expected_sleep - requested_sec
    
    tolerance = 1
    if sleep_delta > tolerance || sleep_delta < (-1 * tolerance)
      raise "Sleep request (#{requested_sec}) was #{sleep_delta} different from expectation (#{self.expected_sleep})!" 
    end
  end
end


class TestIntervalExec < Test::Unit::TestCase

  def teardown
    Time.unmock!
  end
  
  def run_interval duration, overflow_handler, block_execution_time, opts={}
    first_cycle = true
    IntervalExec.run(duration, overflow_handler, opts) do
      break if !first_cycle
      
      first_cycle = false
      Time.freeze_time(Time.now + block_execution_time)
    end
  end

  context "code completes within interval" do
    
    should "call sleep when overrun_handler=:immediate" do
      Kernel.expects(:sleep)      
      run_interval(10, :immediate, 6)
    end
    
    should "sleep until interval expires when overrun_handler=:immediate" do
      Kernel.expected_sleep = 4
      assert_nothing_raised { run_interval(10, :immediate, 6) }
    end
    
    should "sleep until interval expires when overrun_handler=:fixed" do
      Kernel.expected_sleep = 6      
      assert_nothing_raised { run_interval(12, :fixed, 6) }
    end
    
    should "sleep until interval expires when overrun_handler=:next" do
      Kernel.expected_sleep = 8     
      assert_nothing_raised { run_interval(14, :fixed, 6) }
    end
  end
  
  context "code runs past interval" do
    should "not sleep at all when overrun_handler=:immediate" do
      Kernel.expects(:sleep).never
      run_interval(14, :immediate, 20)
    end
    
    should "sleep when overrun_handler=:fixed" do
      Kernel.expects(:sleep)
      assert_nothing_raised { run_interval(14, :fixed, 20) }
    end
    
    should "sleep for duration when overrun_handler=:fixed" do
      Kernel.expected_sleep = 14
      assert_nothing_raised { run_interval(14, :fixed, 20) }
    end
    
    should "sleep when overrun_handler=:next" do
      Kernel.expects(:sleep)
      assert_nothing_raised { run_interval(15, :next, 20) }
    end
    
    should "sleep until interval would expire when overrun_handler=:next" do
      Kernel.expected_sleep = 10
      assert_nothing_raised { run_interval(15, :next, 20) }
    end
    
    should "sleep until interval would expire when overrun_handler=:next and execution exceeds several intervals" do
      Kernel.expected_sleep = 10
      assert_nothing_raised { run_interval(15, :next, 35) }
    end
  end
  
  should "call interval_end_proc when specified" do
    Kernel.stubs(:sleep)
    test_proc = Proc.new {}
    test_proc.expects(:call)
    run_interval(10, :immediate, 5, :interval_end_proc => test_proc)
  end

end