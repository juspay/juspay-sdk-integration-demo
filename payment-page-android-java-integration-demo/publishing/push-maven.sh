#!/bin/bash
cd mavenRepo || exit
git add .
git commit -m "Publishing HyperWebViewSDK: $1"
git push
