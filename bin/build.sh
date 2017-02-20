#!/bin/sh

SCRIPT=$(basename $0)
REPO_BASE=$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )

[ -d "${REPO_BASE}/bitbake/.git" ] || git submodule update --init --recursive

# Set ADMINS in settings.py
if [ -n "$TOASTER_ADMIN_NAME" -a -n "$TOASTER_ADMIN_EMAIL" ]; then
  BUILD_ARGS="--build-arg TOASTER_ADMIN_NAME=$TOASTER_ADMIN_NAME --build-arg TOASTER_ADMIN_EMAIL=$TOASTER_ADMIN_EMAIL"
fi

# Generate random secret key each time in build image
cat ${REPO_BASE}/settings.py | sed -e "s#SECRET_KEY.*#SECRET_KEY = '$(openssl rand -base64 64 | tr -d '\n')'#" > ${REPO_BASE}/bitbake/lib/toaster/toastermain/settings.py

cd ${REPO_BASE}/bitbake
cp ../Dockerfile ./Dockerfile
# Set up requirements.txt for ONBUILD instructions to install
ln -s toaster-requirements.txt requirements.txt

docker build $BUILD_ARGS -t trinitronx/yocto-bitbake-toaster:latest .

# -v $(pwd)/data:/data
docker run -ti -p 3800:80 trinitronx/yocto-bitbake-toaster:latest
