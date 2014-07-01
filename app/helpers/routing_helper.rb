module RoutingHelper

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

end
