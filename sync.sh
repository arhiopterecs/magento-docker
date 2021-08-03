#!/bin/bash
mutagen terminate --label-selector=magento-docker-compose
mutagen terminate --label-selector=magento-docker-magento2ce
mutagen terminate --label-selector=magento-docker-magento2ee
mutagen terminate --label-selector=magento-docker-magento2ce-vendor

mutagen sync create \
    --label=magento-docker-compose \
    --sync-mode=two-way-resolved \
    --default-file-mode=0664 \
    --default-directory-mode=0775 \
    --symlink-mode=posix-raw \
    ~/.composer/ docker://$(docker-compose -f ./magento-docker/docker-compose.yml ps -q app|awk '{print $1}')/composer

mutagen sync create \
       --label=magento-docker-magento2ce \
       --sync-mode=two-way-resolved \
       --default-file-mode=0664 \
       --default-directory-mode=0775 \
       --symlink-mode=posix-raw \
       --ignore=/vendor \
       --ignore=/var/cache \
       --ignore=/var/page_cache \
       --ignore=/var/view_preprocessed \
       --ignore=/.idea \
       --ignore=/.magento \
       --ignore=/.docker \
       --ignore=/.github \
       --ignore=*.sql \
       --ignore=*.gz \
       --ignore=*.zip \
       --ignore=*.bz2 \
       --ignore-vcs \
       ./magento2ce/ docker://$(docker-compose -f ./magento-docker/docker-compose.yml ps -q app|awk '{print $1}')/var/www/magento2ce

       #--ignore=/var/composer_home \
       #--ignore=/var/tmp \

mutagen create \
       --label=magento-docker-magento2ee \
       --sync-mode=two-way-resolved \
       --default-file-mode=0664 \
       --default-directory-mode=0775 \
       --ignore=/.idea \
       --ignore=/.github \
       --ignore=*.sql \
       --ignore=*.gz \
       --ignore=*.zip \
       --ignore=*.bz2 \
       --ignore-vcs \
       --symlink-mode=posix-raw \
       ./magento2ee/ docker://$(docker-compose -f ./magento-docker/docker-compose.yml ps -q app|awk '{print $1}')/var/www/magento2ee

mutagen create \
       --label=magento-docker-magento2ce-vendor \
       --sync-mode=two-way-resolved \
       --default-file-mode=0644 \
       --default-directory-mode=0755 \
       --symlink-mode=posix-raw \
       ./magento2ce/vendor docker://$(docker-compose -f ./magento-docker/docker-compose.yml ps -q app|awk '{print $1}')/var/www/magento2ce/vendor

watch -n 1 'mutagen list'
