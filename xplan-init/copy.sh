#!/bin/bash

for dir in srv-ws mng-cfg val-cfg val-ws plu-ws
do
    if [ -d "/dst/${dir}" -a -z "$(ls -A /dst/${dir})" ]; then
        echo "Copy template for ${dir}"
        tar -xvzf /tpl/${dir}.tgz -C /dst/${dir}/
    else
        echo "Skipped ${dir} - not a directory or not empty"
    fi
done