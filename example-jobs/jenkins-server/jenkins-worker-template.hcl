{
  "Job": {
    "Region": "global",
    "ID": "%WORKER_NAME%",
    "Type": "batch",
    "Datacenters": [
      "toronto"
    ],
    "TaskGroups": [
      {
        "Name": "jenkins-worker-taskgroup",
        "Count": 1,
        "RestartPolicy": {
          "Attempts": 0,
          "Interval": 10000000000,
          "Mode": "fail",
          "Delay": 1000000000
        },
        "Tasks": [
          {
            "Name": "jenkins-worker",
            "Driver": "docker",
            "Config": {
              "image": "carlsan/dockers:docker-inbound-agent",
              "volumes": [
                "/var/run/docker.sock:/var/run/docker.sock"
              ]
            },
            "Env": {
              "JENKINS_URL": "http://jenkins:8080",
              "JENKINS_AGENT_NAME": "%WORKER_NAME%",
              "JENKINS_SECRET": "%WORKER_SECRET%",
              "JENKINS_TUNNEL": "jenkins:50000"
            },
            "Resources": {
              "CPU": 500,
              "MemoryMB": 256
            }
          }
        ],
        "EphemeralDisk": {
          "SizeMB": 300
        }
      }
    ]
  }
}