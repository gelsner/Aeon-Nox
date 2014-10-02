#!/bin/bash

pushd $(dirname $0) > /dev/null
ADDON_DIR=$(pwd)
popd > /dev/null
ADDON_PARENT_DIR=$(dirname "${ADDON_DIR}")
ADDON_NAME=$(grep 'id="' addon.xml | cut -d '"' -f 2)
ADDON_VERSION=$(awk '/version=/{i++}i==2' "${ADDON_DIR}/addon.xml")
ADDON_VERSION=$(echo ${ADDON_VERSION} | awk -F 'version="' '{print $2}' | cut -d ' ' -f 1 | sed s'/"//'g)

pushd "${ADDON_PARENT_DIR}"
if [[ -e "${ADDON_DIR}/${ADDON_NAME}-${ADDON_VERSION}.zip" ]]; then
	rm "${ADDON_DIR}/${ADDON_NAME}-${ADDON_VERSION}.zip"
fi	
zip -r "./${ADDON_NAME}-${ADDON_VERSION}.zip" "./${ADDON_NAME}/" -x *.git* *.DS_Store* *create_addon-zip.sh
mv "./${ADDON_NAME}-${ADDON_VERSION}.zip" "./${ADDON_NAME}"
popd

echo "${ADDON_DIR}/${ADDON_NAME}-${ADDON_VERSION}.zip"
