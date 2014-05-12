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
  
  def opt_join(status)
    opt_join = "disabled"
    if status == "inactive" 
      opt_join = nil
    end
    opt_join
  end
  
  def opt_recover(status)
    opt_recover = "disabled"
    if status == "active" && @stats_hash["routing"]["short_vnodes"].to_i != 0
      opt_recover = nil
    end
    opt_recover
  end

end
