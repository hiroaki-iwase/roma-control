module LoginHelper

  def get_gravatar_src(email_address = nil)
    hash = Digest::MD5.hexdigest(email_address)
    image_src = "http://www.gravatar.com/avatar/#{hash}"
  end

end
