module ClusterHelper

  def get_server_list
    server_list = []
    @routing_list["active"].each do |active_instance|
      active_instance =~ /^([-\.a-zA-Z\d]+)_/
      server_list.push($1)
    end
    server_list.uniq.size
  end

  def main_version
    main_version = @stats_hash["others"]["version"].chomp
  end
  
  def chk_main_version(vs)
    main_version
    if vs != main_version && vs != nil
      true
    else
      false
    end
  end

  def is_active?(status)
    status != "inactive"
  end
  
  def current_size(instance)
    total_size = @each_instance_size.values.compact.inject(:+).to_f
    (@each_instance_size[instance] / total_size * 100).round(1)
  end

  def instance_size(instance)
    @each_instance_size[instance] / 1024 / 1024
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
    if status != "inactive" && @stats_hash["routing"]["short_vnodes"].to_i != 0
      opt_recover = nil
    end
    opt_recover
  end

end
