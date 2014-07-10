module LogsHelper

  def compact_instance(instance)
    instance.scan(/\d/).join("")
  end

end
