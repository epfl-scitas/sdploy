#!/bin/bash -l
# set -euo pipefail

environment=$(echo $NODE_LABELS | cut -d '-' -f 1)
echo "NODE_LABEL: $NODE_LABELS"
echo "ENVIRONMENT: $environment"

# Activating Spack
. $JENKINS/activate_spack.sh

SPACK_SYSTEM_CONFIG_PATH=${SYSTEM_CONFIG_PREFIX}/${environment}
mkdir ${SPACK_SYSTEM_CONFIG_PATH}
echo "Created SPACK_SYSTEM_CONFIG_PATH in ${SPACK_SYSTEM_CONFIG_PATH}"

echo "Creating spack environemnt: ${environment}"
spack env create ${environment}

echo "Deploying manifest"
spack --env ${environment} write-spack-yaml -s ${STACK_RELEASE} -p ${environment}

echo "Installing packages configuration"
spack --env ${environment} write-packages-yaml -s ${STACK_RELEASE} -p ${environment} -d
spack --env ${environment} config blame packages

echo "Installing modules configuration"
spack --env ${environment} write-modules-yaml -s ${STACK_RELEASE} -p ${environment} -d
spack --env ${environment} config blame modules

echo "Installing config.yaml configuration: ${environment}"
spack --env ${environment} write-config-yaml -s ${STACK_RELEASE} -p ${environment} -d
spack --env ${environment} config blame config


