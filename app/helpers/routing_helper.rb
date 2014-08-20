module RoutingHelper

  def dump_format_check(format)
    if format =~ /^(json|yaml)$/
      return true
    else
      return false
    end
  end

  def column_color(process)
    if process == "join"
      color = "info"
    elsif process == "leave"
      color = "warning"
    end

    color
  end

  def repugnant_repetition_option?(routingdump_option, stats_hash)
    if routingdump_option != stats_hash["stats"]["enabled_repetition_host_in_routing"].to_boolean
      return true
    end

    false
  end

  def change_nodes_list_color(color_type)
    case color_type
    when "primary"
      @color_type = "success"
    when "success"
      @color_type = "info"
    when "info"
      @color_type = "primary"
    end
     
  end

  def past_version?(stats_hash)
    if chk_roma_version(stats_hash['others']['version']) < 65536
      return true
    else
      return false
    end
  end

  def chk_roma_version(vs)
    if /(\d+)\.(\d+)\.(\d+)/ =~ vs
      version = ($1.to_i << 16) + ($2.to_i << 8) + $3.to_i
      return version
    end

    raise
  end

end
