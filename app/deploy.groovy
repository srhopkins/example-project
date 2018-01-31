#!/groovy

node('ec2') {
    
    def IMAGE = params.IMAGE
    def NAMESPACE = params.NAMESPACE
    def DEPLOYMENT = params.DEPLOYMENT
    def SERVER = params.SERVER
    
    withCredentials([string(credentialsId: "${NAMESPACE}-token", variable: 'TOKEN')]) {

        def kubectl = """docker run --rm lachlanevenson/k8s-kubectl:v1.9.2 \
                --namespace=${NAMESPACE} \
                --server=${SERVER} \
                --token=${TOKEN} \
                --insecure-skip-tls-verify=true"""

        sh "${kubectl} get -o wide deployment ${DEPLOYMENT}"
        sh "${kubectl} set image deployment/${DEPLOYMENT} ${DEPLOYMENT}=${IMAGE}"

        sh "for _ in {1..5}; do ${kubectl} rollout status --watch=true deployment/${DEPLOYMENT} || : && break; done"

        sh "${kubectl} get -o wide deployment ${DEPLOYMENT}"
    }
}
