#!/bin/bash
set -eo pipefail
option=$1
set -u
#
#
#
#
#
# ascii art generated by https://www.coolgenerator.com/ascii-text-generator
# font: graffiti

# CONFIGURATION
# Variables needed to run this script
export STACK=syrah
export ENVIRONMENT=izar
export IN_PR=1

# Variables read from commons.yaml using cat, grep and cut.
export WORK_DIR=`cat stacks/${STACK}/common.yaml |grep work_directory: | cut -n -d " " -f 2`
echo "WORK_DIR: $WORK_DIR"

# Because this script is adapted from the Jenkins Pipeline, the environment
# names must be pulled from a variable called NODE_LABELS. This variable only
# exists in Jenkins environment and therefor we must create it artificially
# here. If the name of the environment is called "abc", then the value in the
# variable NODE_LABELS must be "abc-abc"
export NODE_LABELS=${ENVIRONMENT}-${ENVIRONMENT}
export JENKINS=jenkins/deploy/scripts

if [[ $option = "setupenv" ]]; then
    echo "program stopped after exporting all variables to environment"
    exit
fi

LOGS=${WORK_DIR}/logs
mkdir -p ${LOGS}

execution_timestamp=`date +%y%m%d.%H%M%S`
echo "Execution timestamp: ${execution_timestamp}"
echo
echo '  _________________________________________   ____ '
echo ' /   _____/\__    ___/\_   _____/\______   \ /_   |'
echo ' \_____  \   |    |    |    __)_  |     ___/  |   |'
echo ' /        \  |    |    |        \ |    |      |   |'
echo '/_______  /  |____|   /_______  / |____|      |___|'
echo '        \/                    \/                   '
echo
echo '> update_production_configuration.sh'
echo

# Create the python environment. If already created, it will just
# that all the necessary files are there. It does not remove the
# existing environment. Upgrades PIP and installs additional python
# packages.
${JENKINS}/update_production_configuration.sh 2>&1 | tee ${LOGS}/01_update_production_configuration.${execution_timestamp}.log

echo '  _________________________________________  ________  '
echo ' /   _____/\__    ___/\_   _____/\______   \ \_____  \ '
echo ' \_____  \   |    |    |    __)_  |     ___/  /  ____/ '
echo ' /        \  |    |    |        \ |    |     /       \ '
echo '/_______  /  |____|   /_______  / |____|     \_______ \'
echo '        \/                    \/                     \/'
echo
echo '> install_spack.sh'
echo

# If spack already installed, just do a fetch. Add system compiler.
${JENKINS}/install_spack.sh 2>&1 | tee ${LOGS}/02_install_spack.${execution_timestamp}.log

echo '  _________________________________________  ________  '
echo ' /   _____/\__    ___/\_   _____/\______   \ \_____  \ '
echo ' \_____  \   |    |    |    __)_  |     ___/   _(__  < '
echo ' /        \  |    |    |        \ |    |      /       \'
echo '/_______  /  |____|   /_______  / |____|     /______  /'
echo '        \/                    \/                    \/ '
echo
echo '> install_spack_sdploy.sh'
echo

# Installs a new spack-sdploy extension using rsync to THIS locaion.
# Configures the extension in spack.
${JENKINS}/install_spack_sdploy.sh 2>&1 | tee ${LOGS}/03_install_spack_sdploy.${execution_timestamp}.log


echo '  _________________________________________     _____  '
echo ' /   _____/\__    ___/\_   _____/\______   \   /  |  | '
echo ' \_____  \   |    |    |    __)_  |     ___/  /   |  |_'
echo ' /        \  |    |    |        \ |    |     /    ^   /'
echo '/_______  /  |____|   /_______  / |____|     \____   | '
echo '        \/                    \/                  |__| '
echo
echo '> clone_external_repos.sh'
echo

# Issues spack clone-external-repos
${JENKINS}/clone_external_repos.sh 2>&1 | tee ${LOGS}/04_clone_external_repos.${execution_timestamp}.log

echo '  _________________________________________   .________'
echo ' /   _____/\__    ___/\_   _____/\______   \  |   ____/'
echo ' \_____  \   |    |    |    __)_  |     ___/  |____  \ '
echo ' /        \  |    |    |        \ |    |      /       \'
echo '/_______  /  |____|   /_______  / |____|     /______  /'
echo '        \/                    \/                    \/ '
echo
echo '> init_environment.sh'
echo

# Create environments if they do not exist; Set SPACK_SYSTEM_CONFIG_PATH;
# Create spack.yaml, packages.yaml, modules.yaml. config.yaml, repos.yaml,
# mirrors.yaml, concretizer.yaml, upstreams.yaml and copies template files.
${JENKINS}/init_environment.sh 2>&1 | tee ${LOGS}/05_init_environment.${execution_timestamp}.log

echo '  _________________________________________    ________'
echo ' /   _____/\__    ___/\_   _____/\______   \  /  _____/'
echo ' \_____  \   |    |    |    __)_  |     ___/ /   __  \ '
echo ' /        \  |    |    |        \ |    |     \  |__\  \'
echo '/_______  /  |____|   /_______  / |____|      \_____  /'
echo '        \/                    \/                    \/ '
echo
echo '> install_compilers_parallel.sh'
echo

#echo 'skipping compilers'
${JENKINS}/install_compilers_parallel.sh 2>&1 | tee ${LOGS}/06_install_compilers_parallel.${execution_timestamp}.log

echo '  _________________________________________  _________ '
echo ' /   _____/\__    ___/\_   _____/\______   \ \______  \'
echo ' \_____  \   |    |    |    __)_  |     ___/     /    /'
echo ' /        \  |    |    |        \ |    |        /    / '
echo '/_______  /  |____|   /_______  / |____|       /____/  '
echo '        \/                    \/                       '
echo
echo '> concretize.sh'
echo
${JENKINS}/concretize.sh 2>&1 | tee ${LOGS}/07_concretize.${execution_timestamp}.log

if [[ $option = "concretize" ]]; then
    echo "program stopped at concretization step"
    exit
fi

echo '  _________________________________________    ______  '
echo ' /   _____/\__    ___/\_   _____/\______   \  /  __  \ '
echo ' \_____  \   |    |    |    __)_  |     ___/  >      < '
echo ' /        \  |    |    |        \ |    |     /   --   \'
echo '/_______  /  |____|   /_______  / |____|     \______  /'
echo '        \/                    \/                    \/ '
echo
echo '> add_mirror.sh'
echo

echo "skip create mirror"
# ${JENKINS}/add_mirror.sh 2>&1 | tee ${LOGS}/08_add_mirror.${execution_timestamp}.log

echo '  _________________________________________   ________ '
echo ' /   _____/\__    ___/\_   _____/\______   \ /   __   \'
echo ' \_____  \   |    |    |    __)_  |     ___/ \____    /'
echo ' /        \  |    |    |        \ |    |        /    / '
echo '/_______  /  |____|   /_______  / |____|       /____/  '
echo '        \/                    \/                       '
echo
echo '> install_stack.sh'
echo
${JENKINS}/install_stack.sh 2>&1 | tee ${LOGS}/09_install_stack.${execution_timestamp}.log

echo '  _________________________________________   ___________   '
echo ' /   _____/\__    ___/\_   _____/\______   \ /_   \   _  \  '
echo ' \_____  \   |    |    |    __)_  |     ___/  |   /  /_\  \ '
echo ' /        \  |    |    |        \ |    |      |   \  \_/   \'
echo '/_______  /  |____|   /_______  / |____|      |___|\_____  /'
echo '        \/                    \/                         \/ '
echo
echo '> create_modules.sh'
echo

echo "skip create modules"
# ${JENKINS}/create_modules.sh 2>&1 | tee ${LOGS}/10_create_modules.${execution_timestamp}.log

echo '  _________________________________________   ____ ____ '
echo ' /   _____/\__    ___/\_   _____/\______   \ /_   /_   |'
echo ' \_____  \   |    |    |    __)_  |     ___/  |   ||   |'
echo ' /        \  |    |    |        \ |    |      |   ||   |'
echo '/_______  /  |____|   /_______  / |____|      |___||___|'
echo '        \/                    \/                        '
echo
echo '> activate_packages.sh'
echo

echo "skip final steps"
# ${JENKINS}/activate_packages.sh 2>&1 | tee ${LOGS}/11_activate_packages.${execution_timestamp}.log
# ${JENKINS}/create_buildcache.sh 2>&1 | tee ${LOGS}/11_create_buildcache.${execution_timestamp}.log
# ${JENKINS}/push_buildcache.sh 2>&1 | tee ${LOGS}/12_push_buildcache.${execution_timestamp}.log
