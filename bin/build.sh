#!/bin/sh

SCRIPT=$(basename $0)
REPO_BASE=$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )

[ -d "${REPO_BASE}/bitbake/.git" ] || git submodule update --init --recursive

# Generate random secret key each time in build image
cat ${REPO_BASE}/settings.py | sed -e "s#SECRET_KEY.*#SECRET_KEY = '$(openssl rand -base64 64 | tr -d '\n')'#" > ${REPO_BASE}/bitbake/lib/toaster/toastermain/settings.py

cd ${REPO_BASE}/bitbake
docker build -t trinitronx/yocto-bitbake-toaster:latest -f ../Dockerfile .

docker run -ti -v $(pwd)/data:/data -p 3800:80 trinitronx/yocto-bitbake-toaster:latest
