# -*- mode: ruby -*-
# vi: set ft=ruby :

$box_name = "bento/centos-7"
# $box_url = ""
$box_url = "bento/rockylinux-8.4"
$num_instances = 3

Vagrant.configure(2) do |config|
  config.vm.box = "bento/ubuntu-16.04" # 16.04 LTS

  # 3-node configuration - Region A
  (1..$num_instances).each do |i|
    config.vm.define "nomad-a-#{i}" do |n|
      n.vm.provider "virtualbox" do |vb|
        vb.memory = "1042"
        vb.cpus = "2"
        vb.customize ["modifyvm", :id, "--ioapic", "off"]
      end
      n.vm.provision "shell", path: "node-install-a.sh"
      n.vm.provision "shell", inline: <<-SHELL
      mkdir -p /opt/mysql/data
      SHELL
      n.vm.provision "shell", inline: <<-SHELL
      /vagrant/launch-a-#{i}.sh
      SHELL
      if i == 1
        # Expose the nomad ports
        n.vm.network "forwarded_port", guest: 4646, host: 4646, auto_correct: true
      end
      n.vm.hostname = "nomad-a-#{i}"
      n.vm.network "private_network", ip: "172.16.1.#{i+100}"
    end
  end

  config.vm.define "haproxy-nomad" do |haproxy_nomad|
    haproxy_nomad.vm.box = $box_name
   # haproxy_nomad.vm.box_url = $box_url
    haproxy_nomad.vm.network "private_network", ip: "172.16.1.10"
    haproxy_nomad.vm.provider "virtualbox" do |vb|
      vb.memory = "256"
      vb.cpus = "1"
      vb.customize ["modifyvm", :id, "--ioapic", "off"]
    end

    haproxy_nomad.vm.provision "shell", inline: <<-SHELL
      systemctl disable firewalld.service
      systemctl stop firewalld.service
      yum -y install haproxy
      mv /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg.org
      systemctl enable haproxy.service
    SHELL

    haproxy_nomad.vm.provision "file", source: "haproxy_nomad.cfg", destination: "~/haproxy.cfg"

    (1..$num_instances).each do |i|
      ip = "172.16.1.#{i+100}"
      haproxy_nomad.vm.provision "shell", inline: <<-SHELL
        echo "    server  nomad-consul-services#{i} #{ip}" >> /home/vagrant/haproxy.cfg
      SHELL
    end

    haproxy_nomad.vm.provision "shell", inline: <<-SHELL
      mv /home/vagrant/haproxy.cfg /etc/haproxy/
      systemctl start haproxy.service
    SHELL
  end
end
