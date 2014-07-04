module RoutingHelper

  def dump_format_check(format)
    if format =~ /^(json|yaml)$/
      return true
    else
      return false
    end
  end

end
