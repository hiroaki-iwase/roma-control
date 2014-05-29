class User
  include ActiveModel::Model

  def initialize(params = nil)
  end

  def self.authenticate(username, password)
    #if ConfigGui::ROOT_USER.has_key?(username) && ConfigGui::ROOT_USER.has_value?(password)
    if  user_info = ConfigGui::ROOT_USER.find{|info| info[0] == username && info[1] == password }
      return user_info
    end

    return false
  end

  #def self.authenticate_sha1(sha1_hash)
  #  if ConfigGui::ROOT_USER.select{|k, v| sha1_hash == Digest::SHA1.hexdigest(Hash[k,v].to_s)}.size != 0
  def self.authenticate_sha1(username, password)
    #if ConfigGui::ROOT_USER.find{|k, v| k == username && Digest::SHA1.hexdigest(v) == password }
    if ConfigGui::ROOT_USER.find{|info| info[0] == username && Digest::SHA1.hexdigest(info[1]) == password }
      return true
    end

    return false
  end

end
