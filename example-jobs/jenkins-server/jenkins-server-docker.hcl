job "jenkins-docker-server" {
  type        = "service"
  datacenters = ["toronto"]
  update {
    stagger          = "30s"
    max_parallel     = 1
    health_check     = "checks"
    min_healthy_time = "10s"
    healthy_deadline = "5m"
    auto_revert      = false
    canary           = 0
  }

  group "jenkins-server" {
    count = 1

    volume "jenkins_home" {
      type      = "host"
      read_only = false
      source    = "jenkins_home"
    }

    restart {
      attempts = 10
      interval = "5m"
      delay    = "25s"
      mode     = "delay"
    }


    task "jenkins" {
      driver = "docker"

      volume_mount {
        volume      = "jenkins_home"
        destination = "/var/jenkins_home"
        read_only   = false
      }

      config {
        image = "jenkins/jenkins:lts"
        volumes = [
            "/var/run/docker.sock:/var/run/docker.sock"
        ]
        port_map = {
          http_ui = 8080
          agents  = 50000
        }
      }

      resources {
        memory = 768
        cpu    = 2400
        network {
          mbits = 100
          port "http_ui" {
            static = 8888
          }
          port "agents" {
            static = 50001
          }
        }
      }
    }

  }
}