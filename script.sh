#!/bin/bash

cd /tmp
curl -O https://kasm-static-content.s3.amazonaws.com/kasm_release_1.12.0.d4fd8a.tar.gz
tar -xf kasm_release_1.12.0.d4fd8a.tar.gz
yes | bash kasm_release/install.sh
