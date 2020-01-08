podTemplate(label: 'mypod', containers: [
    containerTemplate(name: 'maven', image: 'maven:3.3.9-jdk-8-alpine', ttyEnabled: true, command: 'cat')
]) {
    node ('mypod') {
        stage 'Get a Maven project'
        git 'https://github.com/onek0708/jpetstore-6.git'
        container('maven') {
            stage 'Build a Maven project'
            sh 'mvn clean install -Dmaven.test.skip=true'
        }
    }
}
