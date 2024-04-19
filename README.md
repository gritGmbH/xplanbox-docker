
# Files from container

docker cp 33db:/docker-entrypoint-initdb.d/setup_db.sh xplan-db-docker/setup.sh


# Docker Desktop (Windows)

Prepare nginx ingress with:

```bash
#kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.0.2/deploy/static/provider/cloud/deploy.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.2.0/deploy/static/provider/cloud/deploy.yaml
```

Note: May require to set -Xmx Parameter with smaler default value for deployments

# Build commands locally

```bash
docker run -it --rm -e POSTGRES_DB=xplanbox -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres01 grit/xplan-db:${XPLANBOX_VERSION}${BUILD_SUFFIX} 
```

```bash
export DEE_REPO_USER=user
export DEE_REPO_PASS=pass
#export DEE_REPO_URL=http://192.168.100.42:8088
#export DEE_REPO_URL=http://194.115.58.42:8088
export DEE_REPO_URL=https://maven.werne.grit.de/artifactory/xplanbox-repos
export XPLANBOX_VERSION=7.1.3
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


### Create initial configuration

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

### Manager web ?

```properties
more /etc/java-8-openjdk/accessibility.properties 
#
# The following line specifies the assistive technology classes
# that should be loaded into the Java VM when the AWT is initailized.
# Specify multiple classes by separating them with commas.
# Note: the line below cannot end the file (there must be at
# a minimum a blank line following it).
#
#assistive_technologies=org.GNOME.Accessibility.AtkWrapper
```
