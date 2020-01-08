podTemplate(label: 'jenkins-slave-pod', 
  containers: [
    containerTemplate(
      name: 'git',
      image: 'alpine/git',
      command: 'cat',
      ttyEnabled: true
    ),
    containerTemplate(
      name: 'maven',
      image: 'maven:3.6.2-jdk-8',
      command: 'cat',
      ttyEnabled: true
    ),
    containerTemplate(
      name: 'node',
      image: 'node:8.16.2-alpine3.10',
      command: 'cat',
      ttyEnabled: true
    ),
    containerTemplate(
      name: 'docker',
      image: 'docker',
      command: 'cat',
      ttyEnabled: true
    ),
  ],
  volumes: [ 
    hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock'), 
  ]
)

{
    node('jenkins-slave-pod') { 
        //def registry = "192.168.194.129:5000"
        //def registryCredential = "nexus3-docker-registry"

        def registry = "docker.io"
        def registryCredential = "registryCredential"

        // https://jenkins.io/doc/pipeline/steps/git/
        stage('Clone repository') {
            container('git') {
                // https://gitlab.com/gitlab-org/gitlab-foss/issues/38910
                checkout([$class: 'GitSCM',
                    //branches: [[name: '*/dockerizing']],
                    branches: [[name: '*/master']],
                    userRemoteConfigs: [
                        //[url: 'http://192.168.194.132/root/playce-iot.git', credentialsId: 'jacobbaek-privategitlab']
                        [url: 'https://github.com/onek0708/jpetstore-6.git']
                    ],
                ])
            }
        }
        
        //stage('build the source code via npm') {
        //    container('node') {
        //        sh 'cd frontend && npm install && npm run build:production'
        //    }
        //}
        
        stage('build the source code via maven') {
            container('maven') {
                sh 'mvn clean package'
                //sh 'bash build.sh'
            }
        }

        stage('Build docker image') {
            container('docker') {
                withDockerRegistry([ credentialsId: "$registryCredential", url: "http://$registry" ]) {
                    sh "docker build -t onek0708/jpetstore:1.0 -f ./Dockerfile ."
                }
            }
        }

        stage('Push docker image') {
            container('docker') {
                withDockerRegistry([ credentialsId: "$registryCredential", url: "http://$registry" ]) {
                    //docker.image("$registry/jpetstore:1.0").push()
                    docker.image("onek0708/JPetstore:latest").push()
                }
            }
        }
    }   
}
