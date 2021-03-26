#!/bin/bash
#
# run with parameter: "xpla*/*:3.3"
echo "Getting history for images matching $@"
docker image ls --format "{{.Repository}} {{.Tag}}" $@ | while read repo tag
do
    basename=$(basename $repo)
    dirname=$(dirname $repo)
    histfile="${dirname}-${tag}/${basename}.history.txt"
    echo "Generating info into ${histfile}"
    docker image history --format "{{.CreatedAt}} {{.CreatedBy}}" --no-trunc  "${repo}:${tag}" | \
        sed -e 's/&&/\n                                  \&\&/g' \
        >"$histfile"
done
