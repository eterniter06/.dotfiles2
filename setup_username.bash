#!/bin/bash

mapfile -t file_list < <( grep -Ir --files-with-matches infinity * ) &&
    for file in "${file_list[@]}"; do
        sed -i "s/infinity/$USER/g" $file
    done
