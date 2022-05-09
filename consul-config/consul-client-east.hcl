data_dir = "/tmp/consul/server"

advertise_addr   = "{{ GetInterfaceIP `eth1` }}"
client_addr      = "0.0.0.0"
ui               = true
datacenter       = "toronto"
retry_join       = ["172.16.1.101", "172.16.1.102", "172.16.1.103"]
