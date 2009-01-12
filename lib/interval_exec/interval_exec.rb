class IntervalExec
  
  # Loops a block of code, handling execution interval as specified by _duration_ and _params_.
  #
  # *Params*:
  # [+duration+] Execution interval in seconds
  # [+overrun_handler+] Defines what should happen when the block execution exceeds duration
  #
  # <b>Possible overrun_handler values:</b>
  # [<tt>:immediate</tt>] If execution exceeds duration, next interval begins immediately after long cycle completes.
  # [<tt>:fixed</tt>] Next interval begins exactly _duration_ seconds after execution completes.
  # [<tt>:next</tt>] Execution skips a cycle, and picks up at next scheduled interval.  For example, if cycle is 10s and code
  #                  execution takes 15s, IntervalExec will sleep for 5s so execution begins at 20s mark.
  #
  # *Options*:
  # [<tt>:interval_end_proc</tt>] A proc to be called at the end of every interval with one parameter:
  #                               +actual_duration+, block execution time in seconds
  #
  # <b>Notes:</b>
  # * If code execution ends early, code sleeps until _duration_ is reached.
  # * Code runs inside a standard +loop+, so +break+ and +next+ keywords can be used to stop execution and skip to next interval
  # * IntervalExec doesn't do any exception handling
  def self.run(duration, overrun_handler, opts = {}, &block)
    interval_end_proc = opts[:interval_end_proc]
    
    loop do
      start_time = Time.now
      
      yield
      
      end_time = Time.now
      actual_duration = end_time - start_time
      
      if actual_duration < duration
        Kernel.sleep(duration - actual_duration)
      else
        case overrun_handler
        when :fixed
          Kernel.sleep(duration)
        when :next
          overrun = actual_duration % duration
          Kernel.sleep(duration - overrun)
        end
      end
      
      interval_end_proc.call(actual_duration) unless interval_end_proc.nil?
    end
  end
  
end