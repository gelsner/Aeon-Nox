#!/bin/bash

pushd $(dirname $0) > /dev/null
SKIN_DIR=$(pwd)
popd > /dev/null
SKIN_PARENT_DIR=$(dirname "${SKIN_DIR}")
SKIN_NAME=$(basename "${SKIN_DIR}")
SKIN_VERSION=$(awk '/version=/{i++}i==2' "${SKIN_DIR}/addon.xml")
SKIN_VERSION=$(echo ${SKIN_VERSION} | awk -F 'version="' '{print $2}' | cut -d ' ' -f 1 | sed s'/"//'g)

pushd "${SKIN_PARENT_DIR}"
if [[ -e "${SKIN_DIR}/${SKIN_NAME}-${SKIN_VERSION}.zip" ]]; then
	rm "${SKIN_DIR}/${SKIN_NAME}-${SKIN_VERSION}.zip"
fi	
zip -r "./${SKIN_NAME}-${SKIN_VERSION}.zip" "./${SKIN_NAME}/" -x *.git* *.DS_Store* *create_addon-zip.sh
mv "./${SKIN_NAME}-${SKIN_VERSION}.zip" "./${SKIN_NAME}"
popd

echo "${SKIN_DIR}/${SKIN_NAME}-${SKIN_VERSION}.zip"
