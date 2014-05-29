module ConfigGui
  #HOST = "10.0.2.15"
  HOST = "192.168.223.2"
  #HOST = "192.168.223.3"
  PORT = 10001
  #PORT = 10006 #debug

  # user list
  ROOT_USER = {
    ###'username' => 'password',
    'hiroaki.iwase' => 'rakuten',

    ### ['username', 'password', 'gravatar's email address']
    #['hiroaki', 'pass', 'hiroaki.iwase.r@gmail.com'],

    ### 'username' => { 'password' => 'password', 'gravatar's email address']
    #'hiroaki.iwase' => { 'password' => 'rakuten', 'email' => 'hiroaki.iwase.r@gmail.com'}      
  }

  NORMAL_USER = []

end
