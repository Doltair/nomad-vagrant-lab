job "docker-registry" {
  datacenters = ["toronto"]
  type        = "service"
  group "server" {
    count = 1

    volume "shared" {
      type      = "host"
      read_only = false
      source    = "shared"
    }

    network {
      port "http" {
        to     = 5000
        static = 5000
      }
    }

    task "registry" {
      driver = "docker"

      volume_mount {
        volume      = "shared"
        destination = "/var/lib/registry"
      }

      config {
        image = "registry"
        ports = ["http"]
        sysctl = {
          "net.core.somaxconn" = "16384"
        }
      }

      resources {
        memory = 256
        cpu    = 250
        network {
          mbits = 100
        }
      }
    }
  }
}