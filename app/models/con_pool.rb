require 'thread'
require 'socket'
require 'singleton'

#module Roma
#  module Client
    
    class ConPool
      include Singleton

      attr_accessor :maxlength
      attr_accessor :expire_time

      #def initialize(maxlength = 10, expire_time = 60)
      def initialize(maxlength = 5, expire_time = 10)
        @pool = {}
        @maxlength = maxlength
        @expire_time = expire_time
        @lock = Mutex.new
      end

      #ap => node_id
      def get_connection(ap)
        #@pool[ap].shift is double hash?
        #  {
        #    'localhost_10001' => [
        #      [connection1, time_of_created],
        #      [connection2, time_of_created],
        #      ....
        #      [connection10, time_of_created]
        #    ],
        #    'localhost_10002' => [
        #      ....
        #  }
        # shift & unshift in every access?
        ret,last = @pool[ap].shift if @pool.key?(ap) && @pool[ap].length > 0

        if ret && last < Time.now - @expire_time
          # in case of passed expire_time
          ret.close
          ret = nil
        end
        ret = create_connection(ap) unless ret
        ret
      rescue
        nil
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
          # itiban saisyo dake
          @pool[ap] = [[con, Time.now]]
        end
      rescue
      end

      #def delete_connection(ap)
      #  @pool.delete(ap)
      #end

      #def close_all
      #  @pool.each_key{|ap| close_at(ap) }
      #end

      #def close_same_host(ap)
      #  host,port = ap.split(/[:_]/)
      #  @pool.each_key{|eap|
      #    close_at(eap) if eap.split(/[:_]/)[0] == host
      #  }
      #end
      #
      #def close_at(ap)
      #  return unless @pool.key?(ap)
      #  @lock.synchronize {
      #    while(@pool[ap].length > 0)
      #      begin
      #        @pool[ap].shift.close
      #      rescue =>e
      #      end
      #    end
      #    @pool.delete(ap)
      #  }
      #end

    end # class ConPool

#  end # module Client
#end # module Roma
