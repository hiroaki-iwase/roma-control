class User
  include ActiveModel::Model

  def initialize(params = nil)
  end

  def self.authenticate(username, password)
    #if ConfigGui::ROOT_USER.include?(username) && ConfigGui::ROOT_USER.include?(password)
    if ConfigGui::ROOT_USER.has_key?(username) && ConfigGui::ROOT_USER.has_value?(password)
      return true
    end

    return false
  end

end
