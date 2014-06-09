class String
  def to_b
    case self
      when "true"
        true
      when "false"
        false
    end
  end
end
