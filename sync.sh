#!/bin/bash

DOCKER_COMPOSE_FILE=./docker-compose.yml
DOCKER_APP_CONTAINER=$(docker-compose -f ${DOCKER_COMPOSE_FILE} ps -q app|awk '{print $1}')

MAGENTO2CE_PATH='../magento2ce/'
MAGENTO2EE_PATH='../magento2ee/'
MAGENTO2_SECURITY_PATH='../security-package'

mutagen terminate --label-selector=magento-docker-compose
mutagen terminate --label-selector=magento-docker-magento2ce
mutagen terminate --label-selector=magento-docker-magento2ce-vendor
mutagen terminate --label-selector=magento-docker-magento2ee
#mutagen terminate --label-selector=magento-docker-security-package

mutagen sync create \
    --label=magento-docker-compose \
    --sync-mode=two-way-resolved \
    --default-file-mode=0664 \
    --default-directory-mode=0775 \
    ~/.composer/ docker://${DOCKER_APP_CONTAINER}/composer

mutagen sync create \
       --label=magento-docker-magento2ce \
       --sync-mode=two-way-resolved \
       --default-file-mode=0664 \
       --default-directory-mode=0775 \
       --symlink-mode=posix-raw \
       --ignore-vcs \
       --ignore=/vendor \
       --ignore=/var/cache \
       --ignore=/var/page_cache \
       --ignore=/var/view_preprocessed \
       --ignore=/var/composer_home \
       --ignore=/var/tmp \
       --ignore=/.idea \
       --ignore=/.magento \
       --ignore=/.docker \
       --ignore=/.github \
       --ignore=*.sql \
       --ignore=*.gz \
       --ignore=*.zip \
       --ignore=*.bz2 \
       ./${MAGENTO2CE_PATH}/ docker://${DOCKER_APP_CONTAINER}/var/www/magento2ce

mutagen sync create \
       --label=magento-docker-magento2ce-vendor \
       --sync-mode=two-way-resolved \
       --default-file-mode=0644 \
       --default-directory-mode=0755 \
       ${MAGENTO2CE_PATH}/vendor docker://${DOCKER_APP_CONTAINER}/var/www/magento2ce/vendor

mutagen sync create \
       --label=magento-docker-magento2ee \
       --sync-mode=one-way-safe \
       --default-file-mode=0664 \
       --default-directory-mode=0775 \
       --ignore=/.idea \
       --ignore=/.github \
       --ignore=*.sql \
       --ignore=*.gz \
       --ignore=*.zip \
       --ignore=*.bz2 \
       --ignore-vcs \
       ./${MAGENTO2EE_PATH}/ docker://${DOCKER_APP_CONTAINER}/var/www/magento2ce

#mutagen sync create \
       #--label=magento-docker-security-package \
       #--sync-mode=one-way-replica \
       #--default-file-mode=0644 \
       #--default-directory-mode=0755 \
       #./${MAGENTO2_SECURITY_PATH} docker://${DOCKER_APP_CONTAINER}/var/www/security-package

