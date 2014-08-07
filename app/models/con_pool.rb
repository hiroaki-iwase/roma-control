require 'socket'
require 'singleton'

class ConPool
  include Singleton

  attr_accessor :maxlength
  attr_accessor :expire_time

  def initialize(maxlength = 1, expire_time = 60)
    @pool = {}
    @maxlength = maxlength
    @expire_time = expire_time
  end

  def get_connection(ap)
    ret,last = @pool[ap].shift if @pool.key?(ap) && @pool[ap].length > 0
    if ret && last < Time.now - @expire_time
      ret.close
      ret = nil
    end
    ret = create_connection(ap) unless ret
    ret
  end

  def create_connection(ap)
    addr, port = ap.split(/[:_]/)
    TCPSocket.new(addr, port)
  end

  def return_connection(ap, con)
    if @pool.key?(ap) && @pool[ap].length > 0
      if @pool[ap].length > @maxlength
        con.close
      else
        @pool[ap] << [con, Time.now]
      end
    else
      @pool[ap] = [[con, Time.now]]
    end
  end

  def delete_connection(ap)
    @pool.delete(ap)
  end
end # class ConPool
