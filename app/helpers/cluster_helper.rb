module ClusterHelper

  def get_server_list
    active_server_list = []
    @active_routing_list.each do |active_instance|
      active_instance =~ /^([-\.a-zA-Z\d]+)_/
      active_server_list.push($1)
    end
    active_server_list.uniq.size
  end

  def main_version
    main_version = @stats_hash["others"]["version"].chomp
  end
  
  def chk_main_version(vs)
    if vs != main_version && vs != nil
      true
    else
      false
    end
  end

  def is_active?(status)
    status != "inactive"
  end

  def short_vnodes?(stats_hash)
    if stats_hash["routing"]["short_vnodes"].chomp == "0"
      return false
    else
      return true
    end
  end

  def lost_vnodes?(stats_hash)
    if stats_hash["routing"]["lost_vnodes"].chomp == "0"
      return false
    else
      return true
    end
  end
  
  def current_size_rate(current_size)
    total_size = 0
    @routing_info.each{|instance, info|
      total_size += info["size"].to_f
    }
    (current_size / total_size * 100).round(1)
  end

  def instance_size(size)
    size / 1024 / 1024
  end

  def extra_process_chk(routing_info)
    routing_info.values.each{|info|
      return $& if info["status"] =~ /recover|join|release/
      #return $& if info["status"] =~ /recover|join|inactive/ #debug
    }
    return nil
  end

  def can_i_recover?(stats_hash, routing_info)
    if !short_vnodes?(stats_hash) || extra_process_chk(routing_info) || 
       stats_hash["routing"]["nodes.length"] < stats_hash["routing"]["redundant"]
      return "disabled"
    else
      return nil
    end
  end

  def get_button_option(stats_hash, routing_info, target_instance)
    if can_i_release?(stats_hash, routing_info, target_instance)
      return nil
    else
      return "disabled"
    end
  end

  def can_i_release?(stats_hash, routing_info, target_instance)

    if extra_process_chk(routing_info)
      return false
    end

    buf = living_nodes #[TODO] getting living nodes
    buf.delete(target_instance)
    receptive_instance = []

    unless rep_host? # [toDO] check enabled_repeasthost (make "def enabled_repeasthost?")
      buf.each{|instance|
        host = instance.split(/[:_]/)[0]
        receptive_instance << host unless receptive_instance.include?(host)
      }
    else # in case of --enabled_repeathost
      receptive_instance = host
    end

    return false if receptive_instance.size < stats_hash["routing"]["redundant"]

    return true
  end


end
