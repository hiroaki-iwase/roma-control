module ConfigGui
  HOST = "192.168.223.2"
  PORT = 10001

  # user list
  ROOT_USER = [
    #{:username => 'input your username', :password => 'input passsword', :email => '[optional]gravatar's email address},
    #[:username] and [:password] are set a limit by 30 characters.
    {:username => 'hiroaki.iwase', :password => 'rakuten', :email => 'hiroaki.iwase.r@gmail.com' },
    {:username => 'root', :password => '1234', :email => '' },
  ]

  NORMAL_USER = [
    {:username => 'roma1', :password => 'pass1', :email => 'dev-act-roma@mail.rakuten.com' },
    {:username => 'roma2', :password => 'pass2', :email => '' },
  ]

end
