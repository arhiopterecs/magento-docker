#!/bin/bash
source ./.env

TIME=${1}

watch -n ${TIME} "docker-compose ps && mutagen sync list --label-selector=project=${PROJECT_NAME} | grep -E '(Name|Identifier|Connection|Status|Conflicts)'"

