#!/bin/bash

cd /tmp
curl -O https://kasm-static-content.s3.amazonaws.com/kasm_release_1.13.0.0e0f9b.tar.gz
tar -xf kasm_release_1.13.0.0e0f9b.tar.gz
yes | bash kasm_release/install.sh
