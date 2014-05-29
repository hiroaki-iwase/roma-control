module ConfigGui
  #HOST = "10.0.2.15"
  HOST = "192.168.223.2"
  #HOST = "192.168.223.3"
  PORT = 10001
  #PORT = 10006 #debug

  # user list
  ROOT_USER = [
    #{:username => 'input your username', :password => 'input passsword', :email => '[optional]gravatar's email address},
    {:username => 'hiroaki.iwase', :password => 'rakuten', :email => 'hiroaki.iwase.r@gmail.com' },
    {:username => 'root', :password => '1234', :email => '' },
  ]

  NORMAL_USER = [
    {:username => 'roma1', :password => 'pass1', :email => 'dev-act-roma@mail.rakuten.com' },
    {:username => 'roma2', :password => 'pass2', :email => '' },
  ]

end
