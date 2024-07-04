#!/bin/bash

TARGET=$1
shift
echo "Start the optimization of $@"
for DIR in $@
do
    for FILE in $DIR/*
    do
        BASENAME=$(basename $FILE)
        diff -q "$FILE" "${TARGET}/${BASENAME}" 2>/dev/null && ln -vf "${TARGET}/${BASENAME}" "${FILE}"
    done
done
echo "Optimization completed"