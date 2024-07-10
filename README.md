# Build scripts for docker builds of xPlanBox

## License

GNU Affero General Public License Version 3

## Additional components

/xplan-startup/app.tar.gz/wait-for-it.sh
	Source:  https://github.com/vishnubob/wait-for-it
	License: The MIT License (MIT)

## Development setup for Docker Desktop (Windows)

Prepare nginx ingress with:

```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.2.0/deploy/static/provider/cloud/deploy.yaml
```

## Commands to run or test builds locally

```bash
docker run -it --rm -e POSTGRES_DB=xplanbox -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=... grit/xplan-db:${XPLANBOX_VERSION}${BUILD_SUFFIX} 
```

```bash
export DEE_REPO_USER=user
export DEE_REPO_PASS=pass
export DEE_REPO_URL=http://maven.werne.grit.de/artifactory/xplanbox-repos
export XPLANBOX_VERSION=5.0.3-7ff28682-3
export BUILD_SUFFIX=
export BUILD_TAG=${XPLANBOX_VERSION}${BUILD_SUFFIX}

docker build \
   --build-arg DEE_REPO_USER=$DEE_REPO_USER \
   --build-arg DEE_REPO_PASS=$DEE_REPO_PASS \
   --build-arg XPLANBOX_VERSION=$XPLANBOX_VERSION \
   --build-arg DEE_REPO_URL=$DEE_REPO_URL \
   -t xplan-buildpack-deps:${BUILD_TAG} \
   xplan-buildpack-deps

docker build \
   --build-arg BUILD_TAG=$BUILD_TAG \
   --build-arg XPLANBOX_VERSION=$XPLANBOX_VERSION \
   --build-arg XPLANBOX_BUILD=$(date --rfc-3339=seconds | sed 's/ /T/') \
   -t xplan-init:${BUILD_TAG} \
   -t grit/xplan-init:${BUILD_TAG} \
   xplan-init

docker build \
   --build-arg BUILD_TAG=$BUILD_TAG \
   --build-arg XPLANBOX_VERSION=$XPLANBOX_VERSION \
   --build-arg XPLANBOX_BUILD=$(date --rfc-3339=seconds | sed 's/ /T/') \
   -t xplan-startup:${BUILD_TAG} \
   -t grit/xplan-startup:${BUILD_TAG} \
   xplan-startup

docker build \
   -t xplan-base-tomcat:${BUILD_TAG} \
   -t grit/xplan-base-tomcat:${BUILD_TAG} \
   xplan-base-tomcat

docker build \
   --build-arg DEE_REPO_USER=$DEE_REPO_USER \
   --build-arg DEE_REPO_PASS=$DEE_REPO_PASS \
   --build-arg XPLANBOX_VERSION=$XPLANBOX_VERSION \
   --build-arg DEE_REPO_URL=$DEE_REPO_URL \
   --build-arg BUILD_TAG=$BUILD_TAG \
   --build-arg XPLANBOX_BUILD=$(date --rfc-3339=seconds | sed 's/ /T/') \
   -t grit/xplan-db-docker:${BUILD_TAG} \
   xplan-db-docker

docker build \
   --build-arg DEE_REPO_USER=$DEE_REPO_USER \
   --build-arg DEE_REPO_PASS=$DEE_REPO_PASS \
   --build-arg XPLANBOX_VERSION=$XPLANBOX_VERSION \
   --build-arg DEE_REPO_URL=$DEE_REPO_URL \
   --build-arg BUILD_TAG=$BUILD_TAG \
   --build-arg XPLANBOX_BUILD=$(date --rfc-3339=seconds | sed 's/ /T/') \
   -t grit/xplan-db-inspireplu-docker:${BUILD_TAG} \
   xplan-db-inspireplu-docker

docker build \
   --build-arg XPLANBOX_VERSION=$XPLANBOX_VERSION \
   --build-arg BUILD_TAG=$BUILD_TAG \
   --build-arg XPLANBOX_BUILD=$(date --rfc-3339=seconds | sed 's/ /T/') \
   -t grit/xplan-manager-web-docker:${BUILD_TAG} \
   xplan-manager-web-docker

docker build \
   --build-arg XPLANBOX_VERSION=$XPLANBOX_VERSION \
   --build-arg BUILD_TAG=$BUILD_TAG \
   --build-arg XPLANBOX_BUILD=$(date --rfc-3339=seconds | sed 's/ /T/') \
   -t grit/xplan-services-docker:${BUILD_TAG} \
   xplan-services-docker

docker build \
   --build-arg XPLANBOX_VERSION=$XPLANBOX_VERSION \
   --build-arg BUILD_TAG=$BUILD_TAG \
   --build-arg XPLANBOX_BUILD=$(date --rfc-3339=seconds | sed 's/ /T/') \
   -t grit/xplan-api-docker:${BUILD_TAG} \
   xplan-api-docker

docker build \
   --build-arg XPLANBOX_VERSION=$XPLANBOX_VERSION \
   --build-arg BUILD_TAG=$BUILD_TAG \
   --build-arg XPLANBOX_BUILD=$(date --rfc-3339=seconds | sed 's/ /T/') \
   -t grit/xplan-validator-web-docker:${BUILD_TAG} \
   xplan-validator-web-docker

docker build \
   --build-arg XPLANBOX_VERSION=$XPLANBOX_VERSION \
   --build-arg BUILD_TAG=$BUILD_TAG \
   --build-arg XPLANBOX_BUILD=$(date --rfc-3339=seconds | sed 's/ /T/') \
   -t grit/xplan-services-inspireplu-docker:${BUILD_TAG} \
   xplan-services-inspireplu-docker
```

### Commands to create test configuration 

Example usage:
```
docker run -it --rm \
  -v /media/shared/workspaces/${TARGET_NAME}:/dst/srv-ws \
  -v /media/shared/workspaces/${TARGET_NAME}-plu:/dst/plu-ws \
  -v /media/shared/workspaces/${TARGET_NAME}-val:/dst/val-ws \
  -v /media/shared/managers/${TARGET_NAME}:/dst/mng-cfg \
  -v /media/shared/validators/${TARGET_NAME}:/dst/val-cfg \
  grit/xplan-init:${XPLANBOX_VERSION}
```