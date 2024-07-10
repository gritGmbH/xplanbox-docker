#!/bin/bash

GIT_SHORT_ID=$(git rev-parse --short HEAD)
GIT_LONG_ID=$(git rev-parse HEAD)
GIT_BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)

echo Prepared commands:
echo git clean -fdx
echo git checkout --orphan $GIT_BRANCH_NAME-$GIT_SHORT_ID
echo git add .
echo git commit -m \"code without history of ${GIT_LONG_ID}\"
