job "jenkins" {
  type = "service"
    datacenters = ["toronto"]
    update {
      stagger      = "30s"
      max_parallel = 1
      health_check     = "checks"
      min_healthy_time = "10s"
      healthy_deadline = "5m"
      auto_revert      = false
      canary           = 0
    }

  group "web" {
    count = 1
      # Size of the ephemeral storage for Jenkins. Consider that depending
      # on job count and size it could require larger storage.
      ephemeral_disk {
       migrate = true
       size    = "500"
       sticky  = true
       
     }
    task "frontend" {
      env {
        # Use ephemeral storage for Jenkins data.
        JENKINS_HOME = "/alloc/data"
      }
      driver = "java"
      config {
        jar_path    = "local/jenkins.war"
        jvm_options = ["-Xmx768m", "-Xms384m"]
        args        = ["--httpPort=8080"]
      }
      artifact {
        source = "https://get.jenkins.io/war-stable/2.332.3/jenkins.war"
        options {
          # Checksum will change depending on the Jenkins Version.
          checksum = "sha256:d193f179aadf3a7ceb61adebc3ab51218ac4a7852b88932ff33b44fd7be6010f"
        }
      }
      service {
        # This tells Consul to monitor the service on the port
        # labeled "http".
        port = "http"
        name = "jenkins"

        check {
          type     = "http"
          path     = "/login"
          interval = "10s"
          timeout  = "2s"
        }
    }

      resources {
          cpu    = 2400 # MHz
          memory = 768 # MB
          network {
            mbits = 100
            port "http" {
                static = 8080
            }
          }
        }
      }
    }
}