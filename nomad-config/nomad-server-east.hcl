data_dir = "/tmp/nomad/server"

acl {
  enabled = false
}

server {
  enabled          = true
  bootstrap_expect = 3
  job_gc_threshold = "2m"
}

datacenter = "toronto"

region = "east"

advertise {
  http = "{{ GetInterfaceIP `eth1` }}"
  rpc  = "{{ GetInterfaceIP `eth1` }}"
  serf = "{{ GetInterfaceIP `eth1` }}"
}

plugin "raw_exec" {
  config {
    enabled = true
  }
}

plugin "docker" {
  config {
    volumes {
      enabled = true
    #  selinuxlabel = "z"
    }
    allow_privileged = true
   # allow_caps       = ["chown", "net_raw"]
  }
}

client {
  enabled           = true
  network_interface = "eth1"
  servers           = ["172.16.1.101", "172.16.1.102", "172.16.1.103"]
   host_volume "jenkins_home" {
    path      = "/opt/shared/jenkins_home"
    read_only = false
  }
  host_volume "mysql_data" {
    path      = "/opt/shared/mysql-data"
    read_only = false
  }
}
