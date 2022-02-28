def gitCommit = ""
def imageTag = ""
def networkName = ""
def version = "1.0.25"

properties([disableConcurrentBuilds()])
networkName = env.BUILD_TAG.bytes.encodeHex().toString()
node {
    try {
      stage('checkout') {
        checkout scm
        gitCommit = sh(returnStdout: true, script: 'git rev-parse HEAD').trim()
      }

      if (env.BRANCH_NAME == 'main') {
        stage('build') {
          sh """docker build -t myapp:${version} ."""
        }

        stage('Argon Manifest') {
            withCredentials([
              usernamePassword(credentialsId: 'ori-argon-dev', usernameVariable: 'GITHUB_APP', passwordVariable: 'GITHUB_TOKEN'), 
              string(credentialsId: 'STAGING_TOKEN', variable: 'ARGON_TOKEN'),
              string(credentialsId: 'STAGING_MANIFEST_URL', variable: 'ARGON_MANIFEST_URL')]
              ) {
                sh """curl -L ${ARGON_MANIFEST_URL}/v1/api/download/sh -H "Authorization: Bearer ${ARGON_TOKEN}" | sh -s ${ARGON_TOKEN}"""
                sh """/usr/local/bin/billy generate --artifact-path "myapp:${version}" --access-token ${GITHUB_TOKEN} --argon-token ${ARGON_TOKEN}"""
          }
        }
      }
    } finally {
      sh """
          echo finished!
        """
    }
}
