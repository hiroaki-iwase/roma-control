module ClusterHelper

  def get_active_server_list
    active_server_list = []
    @active_routing_list.each do |active_instance|
      active_instance =~ /^([-\.a-zA-Z\d]+)_/
      active_server_list.push($1)
    end
    active_server_list.uniq
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
    status !~ /inactive|unknown/
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

  def get_button_option(command, stats_hash, routing_info, target_instance=nil)
    case command
    when "recover"
      return nil if can_i_recover?(stats_hash, routing_info)
    when "release"
      return nil if can_i_release?(stats_hash, routing_info, target_instance)
    when "rbalse"
      return nil if can_i_rbalse?(stats_hash, routing_info, target_instance)
    end

    return "disabled"
  end

  def can_i_recover?(stats_hash, routing_info)
    return false if released_flg?(routing_info)

    if !short_vnodes?(stats_hash) || extra_process_chk(routing_info) || 
       stats_hash["routing"]["nodes.length"] < stats_hash["routing"]["redundant"]
      return false
    else
      return true
    end
  end

  def can_i_release?(stats_hash, routing_info, target_instance)
    return false if released_flg?(routing_info)

    if extra_process_chk(routing_info)
      return false
    end

    buf = @active_routing_list.reject{|instance| instance == target_instance }
    receptive_instance = []

    if repetition_host?(stats_hash)  # in case of --enabled_repeathost
      receptive_instance = buf
    else
      buf.each{|instance|
        host = instance.split(/[:_]/)[0]
        receptive_instance << host unless receptive_instance.include?(host)
      }
    end

    return false if receptive_instance.size < stats_hash["routing"]["redundant"].to_i
    return true
  end

  def can_i_rbalse?(stats_hash, routing_info, target_instance)
    if extra_process_chk(routing_info)
      return false
    end

    if released_flg?(routing_info)
      if target_instance != session[:released] 
        return false
      end
    end

    true
  end

  # check "--enabled_repeathost" option is on or off.
  def repetition_host?(stats_hash)
    stats_hash["stats"]["enabled_repetition_host_in_routing"].to_boolean
  end

  def extra_process_chk(routing_info)
    routing_info.values.each{|info|
      return $& if info["status"] =~ /recover|join|release/
    }
    return nil
  end

  def released_flg?(routing_info)
    return true if session[:released]
    routing_info.each{|instance, info|
      if info["primary_nodes"] == 0 && info["secondary_nodes"] == 0
        session[:released] = instance if session[:released] == nil
        return true
      end
    }

    false
  end

  def rbalse_modal

<<"EOS"
<div class="modal fade" id="rbalse-modal" tabindex="-1" role="dialog" aria-labelledby="rbalseModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title" id="rbalseModalLabel">Do you want to run rbalse?</h4>
      </div>
      <div class="modal-body">
        <ul>
          <li>This function kill the instance without release vnodes.</li>
            <ul class="modal-explanation-detail">
              <li>Target instance will be removed from routing file. </li>
              <li>Vnodes in charge of target instance will not be automatically released. </li>
              <li>This process generate short vnodes. </li>
              <li>If you wanna release vnodes before killing process, please use Release button.</li>
            </ul>
          </li>
        </ul>
      </div>
      <div class="modal-footer">
        <form action="destroy" method="post">
          <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
          <button type="submit" class="btn btn-primary">Run rbalse</button>
          <input id="rbalse-hidden-value" type="hidden" name="target_instance" value=''>
        </form>
      </div>
    </div>
  </div>
</div><!-- End of rbalse Modal -->
EOS
end














end
