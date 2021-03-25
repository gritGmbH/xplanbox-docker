#!/bin/bash

TARGET=$1
shift

for DIR in $@
do
    for FILE in $DIR/*
    do
        BASENAME=$(basename $FILE)
        diff -q "$FILE" "${TARGET}/${BASENAME}" 2>/dev/null && ln -vf "${TARGET}/${BASENAME}" "${FILE}"
    done
done