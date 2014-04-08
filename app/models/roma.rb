require 'socket'

class Roma
  include ActiveModel::Model

  attr_accessor :dcnice,
    :size_of_zredundant,
    :hilatency_warn_time,
    :spushv_klength_warn,
    :spushv_vlength_warn,
    :routing_trans_timeout,
    :shift_size,
    :fail_cnt_threshold,
    :fail_cnt_gap,
    :sub_nid,
    :lost_action,
    :auto_recover,
    :descriptor_table_size,
    :continuous_limit,
    :accepted_connection_expire_time,
    :pool_maxlength,
    :pool_expire_time,
    :EMpool_maxlength,
    :EMpool_expire_time,
    :dns_caching
  attr_reader :stats_hash, :stats_json
  
  validates :dcnice,
    allow_blank: true,
    :length => { :is => 1, :message =>'only integer' }
  validates :size_of_zredundant,
    allow_blank: true,
    :length => { :is => 1, :message =>'only integer' }
  validates :hilatency_warn_time,
      allow_blank: true,
      :length => { :is => 1, :message =>'only integer' }
  validates :spushv_klength_warn, :spushv_vlength_warn,
    allow_blank: true,
    :length => { :is => 1, :message =>'only integer' }
  validates :routing_trans_timeout,
    allow_blank: true,
    :length => { :is => 1, :message =>'only integer' }

  def initialize(params = nil)
    super(params)
    @host = ConfigGui::HOST
    @port = ConfigGui::PORT
  end

  def stats
    @sock = TCPSocket.open(@host, @port)
    stats_array = []
    @sock.write("stats\r\n")
    @sock.each{|s|
      break if s == "END\r\n"
      stats_array << s
    }
    @sock.close

    @stats_hash = Hash.new { |hash,key| hash[key] = Hash.new {} }
    stats_array.each{|a|
      key   = a.split(/\s/)[0].split(".", 2)
      value = a.split(/\s/, 2)[1]
    
      if key.size == 1
        @stats_hash["others"][key[0]] = value
      else key.size == 2
        @stats_hash[key[0]][key[1]] = value
      end
    }
    
    #@stats_json = ActiveSupport::JSON.encode(@stats_hash)
    @stats_hash
  end

  def change_param(k, v)
    @sock = TCPSocket.open(@host, @port)
    @sock.write("#{ApplicationController.helpers.change_cmd(k)} #{v}\r\n")

    @sock.each{|s|
      @res = s
      break
    }

    @sock.close
    
    res_ary = @res.delete!("\"|{|}|\s").split(/,|=>/)
    res_hash = Hash[Hash[*res_ary].sort]

    return res_hash
  end

end
