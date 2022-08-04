#!/bin/bash -l
set -euo pipefail

export VERSION=v1
export SPACK_RELEASE=v0.18.1
export SPACK_SDPLOY_PATH=spack-sdploy
export SPACK_SDPLOY_INSTALL_PATH=${STACK_PREFIX}/${SPACK_SDPLOY_PATH}
export SPACK_CONFIG_PATH=spack-config
export SPACK_USER_CONFIG_PATH=${STACK_PREFIX}/${SPACK_CONFIG_PATH}
export SPACK_SDPLOY_INSTALL_PATH=${STACK_PREFIX}/${SPACK_SDPLOY_PATH}
export SPACK_PREFIX=${STACK_PREFIX}/${SPACK_SDPLOY_PATH}
export SPACK_INSTALL_PATH=${STACK_PREFIX}/spack.${VERSION}

echo === Exported variables ===
echo VERSION: ${VERSION}
echo SPACK_RELEASE: ${SPACK_RELEASE}
echo SPACK_SDPLOY_PATH: ${SPACK_SDPLOY_PATH}
echo SPACK_SDPLOY_INSTALL_PATH: ${SPACK_SDPLOY_INSTALL_PATH}
echo SPACK_CONFIG_PATH: ${SPACK_CONFIG_PATH}
echo SPACK_USER_CONFIG_PATH: ${SPACK_USER_CONFIG_PATH}
echo SPACK_SDPLOY_INSTALL_PATH: $SPACK_SDPLOY_INSTALL_PATH
echo SPACK_INSTALL_PATH: $SPACK_INSTALL_PATH
