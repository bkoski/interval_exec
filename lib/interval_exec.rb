$:.unshift(File.dirname(__FILE__)) unless
$:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require File.dirname(__FILE__) + '/interval_exec/interval_exec'

module IntervalExecGem
  VERSION = '0.5.0'
end