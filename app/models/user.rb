class User
  include ActiveModel::Model

  def initialize(params = nil)
  end

  def self.authenticate(username, password)
    #if ConfigGui::ROOT_USER.find{|k, v| k == username && Digest::SHA1.hexdigest(v) == password } #hash1
    #if ConfigGui::ROOT_USER.find{|info| info[0] == username && Digest::SHA1.hexdigest(info[1]) == password } #array

# [todo] insert yield logic

    if user_info = ConfigGui::ROOT_USER.find{|user| user[:username] == username && Digest::SHA1.hexdigest(user[:password]) == password }
      return user_info
    end

    if user_info = ConfigGui::NORMAL_USER.find{|user| user[:username] == username && Digest::SHA1.hexdigest(user[:password]) == password }
      return user_info
    end

    return false
  end

end
