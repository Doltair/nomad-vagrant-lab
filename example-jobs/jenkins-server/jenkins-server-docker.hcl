job "jenkins-docker-server" {
  type        = "service"
  datacenters = ["toronto"]

  group "jenkins-server" {
    count = 1

    volume "shared" {
      type      = "host"
      read_only = false
      source    = "shared"
    }

    task "frontend" {
      volume_mount {
        volume      = "shared"
        destination = "/var/jenkins/home"
      }

      env {
        JENKINS_HOME = "/var/jenkins_home"
      }
      driver = "docker"

      config {
        image = "jenkins/jenkins:lts"

        port_map = {
          http_ui = 8080
          agents  = 50000
        }
      }

      resources {
        memory = 512
        cpu    = 750
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