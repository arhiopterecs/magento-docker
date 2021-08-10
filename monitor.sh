#!/bin/bash
watch -n 5 'mutagen list | grep -E "(Identifier|Connection|Status)"  && docker-compose ps'
