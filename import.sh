#!/bin/bash
test -f ".env" && . ".env"
test -z "$user" && echo "Please specify user in .env"
test -z "$password" && echo "Please specify password in .env"
test -z "$user" && exit 5
test -z "$password" && exit 5

XPLAN_IMAGE_LIST="xplan-db-docker xplan-db-inspireplu-docker xplan-manager-web-docker xplan-services-docker xplan-services-inspireplu-docker xplan-validator-web-docker"
XPLAN_VERSION=3.3

for image in $XPLAN_IMAGE_LIST ; do
    echo "loading ${image} from http://buildserver.deegree-enterprise.de/nexus/service/local/repositories/dee-distribution-releases/content/de/latlon/product/xplanbox/${image}-image/${XPLAN_VERSION}/${image}-image-${XPLAN_VERSION}.tar"
    curl --output ${image}.tar --user "$user:$password" "http://buildserver.deegree-enterprise.de/nexus/service/local/repositories/dee-distribution-releases/content/de/latlon/product/xplanbox/${image}-image/${XPLAN_VERSION}/${image}-image-${XPLAN_VERSION}.tar"
    docker load -i ${image}.tar
    #docker tag xplanbox/${image}:${XPLAN_VERSION} $CI_REGISTRY_IMAGE/$image:$XPLAN_VERSION
    #docker push $CI_REGISTRY_IMAGE/$image:$XPLAN_VERSION
done