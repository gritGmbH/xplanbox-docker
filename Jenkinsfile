pipeline {
  environment {
    repository = "grit"
    registryUrl = 'https://index.docker.io/v1/'
    registryCredential = 'hub.docker.com-gritgmbh'
    dockerTrustCredential = 'docker_trust_jenkins_werne_grit_de'
    gitBranchShort = ''
    dockerTagShort = ''
    dockerTagLong = ''
    prepare01 = 'xplan-base-tomcat'
    prepare02 = 'xplan-buildpack-deps'
    prepare03 = 'xplan-init'
    image01 = 'xplan-api-docker'
    image02 = 'xplan-db-docker'
    image03 = 'xplan-db-inspireplu-docker'
    image04 = 'xplan-manager-web-docker'
    image05 = 'xplan-services-docker'
    image06 = 'xplan-services-inspireplu-docker'
    image07 = 'xplan-validator-web-docker'
    image08 = 'xplan-startup'
    image09 = 'xplan-init'
    DEE_REPO = credentials('dee.nexus.developer')
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
    stage('Prepare builder images') {
      steps{
        script {
          timeStamp = (new Date()).format("yyyy-MM-dd'T'HH:mm")
          repoCreds = "--build-arg DEE_REPO_USER=$DEE_REPO_USR --build-arg DEE_REPO_PASS=$DEE_REPO_PSW"
          buildArgs = "--pull --build-arg XPLANBOX_VERSION=${gitBranchShort} --build-arg GIT_COMMIT=${GIT_COMMIT} --build-arg XPLANBOX_BUILD=${timeStamp}"
          dockerPrepare01 = docker.build( "${prepare01}:${dockerTagLong}", "${buildArgs} ${repoCreds} ${prepare01}" )
          dockerPrepare02 = docker.build( "${prepare02}:${dockerTagLong}", "${buildArgs} ${repoCreds} ${prepare02}" )
          dockerPrepare03 = docker.build( "${prepare03}:${dockerTagLong}", "${buildArgs} ${repoCreds} ${prepare03}" )
        }
      }
    }
    stage('Building image') {
      steps{
        script {
          timeStamp = (new Date()).format("yyyy-MM-dd'T'HH:mm")
          repoCreds = "--build-arg DEE_REPO_USER=$DEE_REPO_USR --build-arg DEE_REPO_PASS=$DEE_REPO_PSW"
          buildArgs = "--build-arg XPLANBOX_VERSION=${gitBranchShort} --build-arg GIT_COMMIT=${GIT_COMMIT} --build-arg XPLANBOX_BUILD=${timeStamp} --build-arg BUILD_TAG=${dockerTagLong}"
          dockerImage01 = docker.build( "${repository}/${image01}:$dockerTagLong", "${buildArgs} ${repoCreds} ${image01}" )
          dockerImage02 = docker.build( "${repository}/${image02}:$dockerTagLong", "${buildArgs} ${repoCreds} ${image02}" )
          dockerImage03 = docker.build( "${repository}/${image03}:$dockerTagLong", "${buildArgs} ${repoCreds} ${image03}" )
          dockerImage04 = docker.build( "${repository}/${image04}:$dockerTagLong", "${buildArgs} ${repoCreds} ${image04}" )
          dockerImage05 = docker.build( "${repository}/${image05}:$dockerTagLong", "${buildArgs} ${repoCreds} ${image05}" )
          dockerImage06 = docker.build( "${repository}/${image06}:$dockerTagLong", "${buildArgs} ${repoCreds} ${image06}" )
          dockerImage07 = docker.build( "${repository}/${image07}:$dockerTagLong", "${buildArgs} ${repoCreds} ${image07}" )
          dockerImage08 = docker.build( "${repository}/${image08}:$dockerTagLong", "${buildArgs} ${repoCreds} ${image08}" )
          dockerImage09 = docker.build( "${repository}/${image09}:$dockerTagLong", "${buildArgs} ${repoCreds} ${image09}" )
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
                dockerImage08.push("$dockerTagLong")
                dockerImage08.push("$dockerTagShort")
                dockerImage09.push("$dockerTagLong")
                dockerImage09.push("$dockerTagShort")
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
        sh "docker rmi ${prepare01}:${dockerTagLong} ${prepare02}:${dockerTagLong}"
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
