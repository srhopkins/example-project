#!/bin/bash

kops create cluster \
    --ssh-public-key ${HOME}/.ssh/hopkins-account.pub \
    --state s3://int-steven.hopkins.rocks-kops-state \
    --name steven.hopkins.rocks \
    --dns-zone steven.hopkins.rocks \
    --node-count 3 \
    --zones us-east-1a,us-east-1b \
    --master-zones us-east-1a \
    --node-size t2.medium \
    --master-size t2.medium \
    --topology private \
    --networking kopeio-vxlan \
    --out . \
    --target terraform
