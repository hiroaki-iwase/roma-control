module StatHelper

  def memory_mode?(stats_hash)
    if stats_hash['storages[roma]']['storage.option'].size == 0
      return true
    else
      return false
    end
  end

end
