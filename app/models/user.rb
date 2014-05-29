class User
  include ActiveModel::Model

  def initialize(params = nil)
  end

  def self.authenticate(username, password)
    if ConfigGui::ROOT_USER.has_key?(username) && ConfigGui::ROOT_USER.has_value?(password)
      return ConfigGui::ROOT_USER.select{|k, v| k == username && v == password}
    end

    return false
  end

  def self.authenticate_sha1(sha1_hash)
    #if ConfigGui::ROOT_USER.select{|k, v| sha1_hash == Digest::SHA1.hexdigest(Hash[k,v].to_s)}.size != 0
    if !ConfigGui::ROOT_USER.select{|k, v| sha1_hash == Digest::SHA1.hexdigest(Hash[k,v].to_s)}.blank?
      return true
    end

    return false
  end

end
