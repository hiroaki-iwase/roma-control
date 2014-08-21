module StorageHelper

  def can_i_use_snapshot?(stats_hash)
    if chk_roma_version(stats_hash['others']['version']) >= 2062
      return true
    else
      return false
    end
  end

end
