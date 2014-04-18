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
    :length => { :is => 1, :message =>' : You sholud input a priority from 1 to 5.' },
    :numericality => { 
      :only_integer => true,
      :greater_than_or_equal_to => 1,
      :less_than_or_equal_to => 5,
      :message =>' : You sholud input a priority from 1 to 5.' }
  validates :size_of_zredundant, :spushv_klength_warn, :spushv_vlength_warn, :shift_size,
      allow_blank: true,
      :numericality => { 
        :only_integer => true,
        :greater_than_or_equal_to => 1,
        :less_than_or_equal_to => 2147483647,
        :message =>' : number must be from 1 to 2147483647.' }
  validates :hilatency_warn_time,
      allow_blank: true,
      :numericality => { 
        :only_integer => true,
        :greater_than_or_equal_to => 1,
        :less_than_or_equal_to => 60,
        :message =>' : number must be from 1 to 60.' }
  validates :routing_trans_timeout, :accepted_connection_expire_time, :pool_expire_time, :EMpool_expire_time,
      allow_blank: true,
      :numericality => { 
        :only_integer => true,
        :greater_than_or_equal_to => 1,
        :less_than_or_equal_to => 86400,
        :message =>' : number must be from 1 to 86400.' }
  validates :fail_cnt_threshold,
      allow_blank: true,
      :numericality => { 
        :only_integer => true,
        :greater_than_or_equal_to => 1,
        :less_than_or_equal_to => 100,
        :message =>' : number must be from 1 to 100.' }
  validates :fail_cnt_gap,
    allow_blank: true,
    :numericality => { 
      :greater_than_or_equal_to => 0,
      :less_than_or_equal_to => 60,
      :message =>' : number must be from 0 to 60.'  }
  validates :pool_maxlength, :EMpool_maxlength,
    allow_blank: true,
    :numericality => { 
      :only_integer => true,
      :greater_than_or_equal_to => 1,
      :less_than_or_equal_to => 1000,
      :message =>' : number must be from 1 to 1000.'  }
  validates :descriptor_table_size,
    allow_blank: true,
    :numericality => { 
      :only_integer => true,
      :greater_than_or_equal_to => 1024,
      :less_than_or_equal_to => 65535,
      :message =>' : number must be from 1024 to 65535.'  }
  validates :continuous_limit,
    allow_blank: true,
    :continuous_limit => true,
    presence: true
  validates :sub_nid,
    allow_blank: true,
    :sub_nid => true,
    presence: true

  def initialize(params = nil)
    super(params)
    @host = ConfigGui::HOST
    @port = ConfigGui::PORT
  end

  def stats(host = @host, port = @port)
    @sock = TCPSocket.open(host, port)
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
  
  def check_param(k, v)
    if v.nil?
      errors.add(k, " : This value is required.")
      return false
    elsif ["auto_recover", "dns_caching"].include?(k) && !["false", "true"].include?(v)
      errors.add(k, " : Unexpected Error. This value is required")
      return false
    elsif k == "lost_action" && !["auto_assign", "shutdown"].include?(v)
      errors.add(k, " : Unexpected Error. This value is required")
      return false
    else
      true
    end
  end

  def change_param(k, v)
    @sock = TCPSocket.open(@host, @port)
    @sock.write("#{ApplicationController.helpers.change_cmd(k)} #{v}\r\n")

    @sock.each{|s|
      @res = s
      break
    }

    @sock.close
    begin
      res_ary = @res.delete!("\"|{|}|\s").split(/,|=>/)
      res_hash = Hash[Hash[*res_ary].sort]
    rescue
      errors.add(k, "was not updated. Unexpection Error( #{@res} ).")
    end

    return res_hash
  end

  def get_instances_list
    active_list = @stats_hash["routing"]["nodes"].chomp.delete("\"[]\s").split(",")

    @sock = TCPSocket.open(@host, @port)
    @sock.write("get_routing_history\r\n")

    inactive_list = []
    @sock.each{|s|
      break if s == "END\r\n"
      inactive_list.push(s.chomp) if !active_list.index(s.chomp)
    }
    @sock.close

    routing_list = {"active"=>active_list, "inactive"=>inactive_list}

    return routing_list 
    ### format is below
    #{
    #  "active" => [
    #    "192.168.223.2_10001",
    #    "192.168.223.2_10002",
    #    "192.168.223.3_10001"
    #  ],
    #  "inactive" => [
    #    "192.168.223.3_10002"
    #  ]
    #}
  end

  def get_instances_info(routing_list, target)
    each_instances_info = {}

    #[ToDO] condoiftion wo change
    routing_list.each{|status, instances|
      if status == "inactive"
        info = "inactive" if target == "status"
        info = nil        if target =~ /size|version/

        instances.each{|instance|
          each_instances_info.store(instance, info)
        }
      else
        instances.each{|instance|
          each_stats = stats(instance.split("_")[0], instance.split("_")[1])

          ### status[active|inactive|recover|join]
          if target == "status"
            if each_stats["stats"]["run_recover"].chomp == "true"
              info = "recover"
            elsif each_stats["stats"]["run_join"].chomp == "true"
              info = "join"
            else
              info = "active"
            end

          ### sum of tc file size of each instance
          elsif target == "size"
            info = 0
            10.times{|index|
              info += each_stats["storages[roma]"]["storage[#{index}].fsiz"].to_i
            }
           
          ### version
          elsif target == "version"
            info = each_stats["others"]["version"].chomp

          end

          each_instances_info.store(instance, info)
        }
      end
    }

    return each_instances_info
  end

end
