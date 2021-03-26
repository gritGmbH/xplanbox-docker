pipeline {
  environment {
    repository = "grit"
    registryUrl = 'https://index.docker.io/v1/'
    registryCredential = 'hub.docker.com-gritgmbh'
    dockerTrustCredential = 'docker_trust_jenkins_werne_grit_de'
    gitBranchShort = ''
    dockerTagShort = ''
    dockerTagLong = ''
    image01 = 'xplan-api-docker'
    image02 = 'xplan-db-docker'
    image03 = 'xplan-db-inspireplu-docker'
    image04 = 'xplan-manager-web-docker'
    image05 = 'xplan-services-docker'
    image06 = 'xplan-services-inspireplu-docker'
    image07 = 'xplan-validator-web-docker'
  }
  agent any
  stages {
    stage('Git checkout') {
      steps {
        // git configuration is made by jenkins
        checkout scm
        script {
          gitBranchShort = "${GIT_BRANCH.lastIndexOf('/') > -1 ? GIT_BRANCH.substring(GIT_BRANCH.lastIndexOf('/') + 1) : GIT_BRANCH}"
          dockerTagShort = "${gitBranchShort}"
          dockerTagLong  = "${gitBranchShort}-${GIT_COMMIT[0..7]}-${BUILD_NUMBER}"
        }
      }
    }
    stage('Building image') {
      steps{
        script {
          dockerImage01 = docker.build( "${repository}/${image01}:$dockerTagLong", "--pull --build-arg BUILD_VERSION=${gitBranchShort} --build-arg BUILD_COMMIT=${GIT_COMMIT} ${image01}" )
          dockerImage02 = docker.build( "${repository}/${image02}:$dockerTagLong", "--pull --build-arg BUILD_VERSION=${gitBranchShort} --build-arg BUILD_COMMIT=${GIT_COMMIT} ${image02}" )
          dockerImage03 = docker.build( "${repository}/${image03}:$dockerTagLong", "--pull --build-arg BUILD_VERSION=${gitBranchShort} --build-arg BUILD_COMMIT=${GIT_COMMIT} ${image03}" )
          dockerImage04 = docker.build( "${repository}/${image04}:$dockerTagLong", "--pull --build-arg BUILD_VERSION=${gitBranchShort} --build-arg BUILD_COMMIT=${GIT_COMMIT} ${image04}" )
          dockerImage05 = docker.build( "${repository}/${image05}:$dockerTagLong", "--pull --build-arg BUILD_VERSION=${gitBranchShort} --build-arg BUILD_COMMIT=${GIT_COMMIT} ${image05}" )
          dockerImage06 = docker.build( "${repository}/${image06}:$dockerTagLong", "--pull --build-arg BUILD_VERSION=${gitBranchShort} --build-arg BUILD_COMMIT=${GIT_COMMIT} ${image06}" )
          dockerImage07 = docker.build( "${repository}/${image07}:$dockerTagLong", "--pull --build-arg BUILD_VERSION=${gitBranchShort} --build-arg BUILD_COMMIT=${GIT_COMMIT} ${image07}" )
        }
      }
    }
    stage('Deploy Images') {
      steps{
        script {
          docker.withRegistry( registryUrl, registryCredential ) {
            withCredentials([
              file(credentialsId: "${dockerTrustCredential}", variable: 'KEY_LOCATION'),
              string(credentialsId: "${dockerTrustCredential}_password", variable: 'KEY_PASSPHRASE'),
              string(credentialsId: "${dockerTrustCredential}_keyname", variable: 'KEY_NAME')
            ]) {
              withEnv([
                'DOCKER_CONTENT_TRUST=1',
                "DOCKER_CONTENT_TRUST_REPOSITORY_PASSPHRASE=${KEY_PASSPHRASE}"
              ]) {
                sh '''
                  mkdir -p "${DOCKER_CONFIG}/trust/private/"
                  cp "${KEY_LOCATION}" "${DOCKER_CONFIG}/trust/private/${KEY_NAME}.key"
                '''
                dockerImage01.push("$dockerTagLong")
                dockerImage01.push("$dockerTagShort")
                dockerImage02.push("$dockerTagLong")
                dockerImage02.push("$dockerTagShort")
                dockerImage03.push("$dockerTagLong")
                dockerImage03.push("$dockerTagShort")
                dockerImage04.push("$dockerTagLong")
                dockerImage04.push("$dockerTagShort")
                dockerImage05.push("$dockerTagLong")
                dockerImage05.push("$dockerTagShort")
                dockerImage06.push("$dockerTagLong")
                dockerImage06.push("$dockerTagShort")
                dockerImage07.push("$dockerTagLong")
                dockerImage07.push("$dockerTagShort")
              }
            }
          }
        }
      }
    }
    stage('Remove Unused docker image') {
      steps{
        sh "docker rmi ${repository}/${image01}:$dockerTagLong ${repository}/${image01}:$dockerTagShort"
        sh "docker rmi ${repository}/${image02}:$dockerTagLong ${repository}/${image02}:$dockerTagShort"
        sh "docker rmi ${repository}/${image03}:$dockerTagLong ${repository}/${image03}:$dockerTagShort"
        sh "docker rmi ${repository}/${image04}:$dockerTagLong ${repository}/${image04}:$dockerTagShort"
        sh "docker rmi ${repository}/${image05}:$dockerTagLong ${repository}/${image05}:$dockerTagShort"
        sh "docker rmi ${repository}/${image06}:$dockerTagLong ${repository}/${image06}:$dockerTagShort"
        sh "docker rmi ${repository}/${image07}:$dockerTagLong ${repository}/${image07}:$dockerTagShort"
      }
    }
  }
  post{
    always {
      script { if (currentBuild.result == null) { currentBuild.result = 'SUCCESS' } }
      withCredentials([string(credentialsId: 'notification-mail', variable: 'NOTIFICATION_MAIL')]){
        step([$class: 'Mailer', notifyEveryUnstableBuild: true, recipients: "${NOTIFICATION_MAIL}", sendToIndividuals: false])
      }
    }
    cleanup {
      cleanWs cleanWhenAborted: false, cleanWhenFailure: false, cleanWhenNotBuilt: false, cleanWhenUnstable: false, notFailBuild: true
    }
  }
}
