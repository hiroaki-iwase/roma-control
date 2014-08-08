#class ConPoolError < Errno::ECONNREFUSED; end
class ConPoolError < StandardError; end
