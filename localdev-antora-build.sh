#!/usr/bin/env bash
set -e # exit on error
set -u # exit on unset variables

antoraRootDir="."

function showConfig() {
    echo "╭─────────────────────────────────────"
    echo "│      ⚙️  Config"
    echo "│  Launch ⏱:         $(date)"
    echo "│  antora root dir:  '$antoraRootDir'"
    echo "╰─────────────────────────────────────"
}
showConfig

function antoraBuild() {
  echo "╭─────────────────────────────────────"
  echo "│      🔨 Run Calpano extended docker image 'calpano/antora-docker'."
  # for debug: $ docker pull ghcr.io/calpano/antora-docker:3.1.2.3
  antoraVolume="${antoraRootDir}:/antora:Z" # `:Z` tells Docker to apply a private volume label unshared with other containers
  docker run -u "$(id -u)" -v "$antoraVolume" --rm --net=host -t ghcr.io/calpano/antora-docker:3.1.10 --cache-dir=./.antora-cache --stacktrace localdev-antora-playbook.yml
  echo "╰─────────────────────────────────────"
}
antoraBuild

echo ""
echo "🏁  Build finished successfully"
echo "See docs at '/doc-site/index.html'"
