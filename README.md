
# Files from container

docker cp 33db:/docker-entrypoint-initdb.d/setup_db.sh xplan-db-docker/setup.sh


# Build commands locally

#


```bash
export DEE_REPO_USER=user
export DEE_REPO_PASS=pass
export DEE_REPO_URL=http://192.168.100.42:8088
export XPLANBOX_VERSION=4.0.1
export BUILD_PREFIX=-SNAPSHOT

docker build \
   --build-arg DEE_REPO_USER=$DEE_REPO_USER \
   --build-arg DEE_REPO_PASS=$DEE_REPO_PASS \
   --build-arg XPLANBOX_VERSION=$XPLANBOX_VERSION \
   --build-arg DEE_REPO_URL=$DEE_REPO_URL \
   --build-arg XPLANBOX_BUILD=$(date --rfc-3339=seconds | sed 's/ /T/') \
   -t xplanbox/xplan-db-docker:${XPLANBOX_VERSION}${BUILD_PREFIX} \
   xplan-db-docker

docker run -it --rm -e POSTGRES_DB=xplanbox -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=postgres01 xplanbox/xplan-db:${XPLANBOX_VERSION}${BUILD_PREFIX} 

docker build \
   --build-arg DEE_REPO_USER=$DEE_REPO_USER \
   --build-arg DEE_REPO_PASS=$DEE_REPO_PASS \
   --build-arg XPLANBOX_VERSION=$XPLANBOX_VERSION \
   --build-arg DEE_REPO_URL=$DEE_REPO_URL \
   --build-arg XPLANBOX_BUILD=$(date --rfc-3339=seconds | sed 's/ /T/') \
   -t xplanbox/xplan-manager-web-docker:${XPLANBOX_VERSION}${BUILD_PREFIX} \
   xplan-manager-web-docker

docker build \
   --build-arg DEE_REPO_USER=$DEE_REPO_USER \
   --build-arg DEE_REPO_PASS=$DEE_REPO_PASS \
   --build-arg XPLANBOX_VERSION=$XPLANBOX_VERSION \
   --build-arg DEE_REPO_URL=$DEE_REPO_URL \
   --build-arg XPLANBOX_BUILD=$(date --rfc-3339=seconds | sed 's/ /T/') \
   -t xplanbox/xplan-services-docker:${XPLANBOX_VERSION}${BUILD_PREFIX} \
   xplan-services-docker

docker build \
   --build-arg DEE_REPO_USER=$DEE_REPO_USER \
   --build-arg DEE_REPO_PASS=$DEE_REPO_PASS \
   --build-arg XPLANBOX_VERSION=$XPLANBOX_VERSION \
   --build-arg DEE_REPO_URL=$DEE_REPO_URL \
   --build-arg XPLANBOX_BUILD=$(date --rfc-3339=seconds | sed 's/ /T/') \
   -t xplanbox/xplan-api-docker:${XPLANBOX_VERSION}${BUILD_PREFIX} \
   xplan-api-docker
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