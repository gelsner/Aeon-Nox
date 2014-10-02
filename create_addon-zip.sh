#!/bin/bash

pushd $(dirname $0) > /dev/null
ADDON_DIR=$(pwd)
popd > /dev/null
ADDON_PARENT_DIR=$(dirname "${ADDON_DIR}")
ADDON_NAME=$(grep 'id="' addon.xml | cut -d '"' -f 2)
ADDON_VERSION=$(awk '/version=/{i++}i==2' "${ADDON_DIR}/addon.xml")
ADDON_VERSION=$(echo ${ADDON_VERSION} | awk -F 'version="' '{print $2}' | cut -d ' ' -f 1 | sed s'/"//'g)

if [[ -z ${ADDON_NAME} ]]; then
	echo "Could not read addon name!"
	exit
fi

if [[ -d "/tmp/${ADDON_NAME}" ]]; then
	rm -rf "/tmp/${ADDON_NAME}"
fi

mkdir "/tmp/${ADDON_NAME}"

rsync -av --exclude "*.git*" --exclude "*.DS_Store*" --exclude "*create_addon-zip.sh" --exclude "*.pyo" --exclude "*.pyc" "${ADDON_DIR}/" "/tmp/${ADDON_NAME}"

pushd "/tmp"
if [[ -e "/tmp/${ADDON_NAME}-${ADDON_VERSION}.zip" ]]; then
	rm "/tmp/${ADDON_NAME}-${ADDON_VERSION}.zip"
fi	
zip -r "./${ADDON_NAME}-${ADDON_VERSION}.zip" "./${ADDON_NAME}/" -x *.git* *.DS_Store* *create_addon-zip.sh
mv "./${ADDON_NAME}-${ADDON_VERSION}.zip" "${ADDON_DIR}"
popd

rm -rf "/tmp/${ADDON_NAME}"

echo "${ADDON_DIR}/${ADDON_NAME}-${ADDON_VERSION}.zip"
