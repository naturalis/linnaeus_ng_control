Host 172.16.*
  #ProxyCommand    ssh -o StrictHostKeyChecking=no -W %h:%p [user]@145.136.241.215 // Production
  #ProxyCommand    ssh -o StrictHostKeyChecking=no -W %h:%p [user]@145.136.242.19 // Test
Host *
  ControlMaster   auto
  ControlPath     ./ansible-mux-%r@%h:%p
  ControlPersist  15m
