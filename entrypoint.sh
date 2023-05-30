#!/bin/bash

LOG_NAME="minio"

info() {
    [ -t 1 ] && [ -n "$TERM" ] \
        && echo "$(tput setaf 2)[$LOG_NAME]$(tput sgr0) $*" \
        || echo "[$LOG_NAME] $*"
}

err() {
	[ -t 2 ] && [ -n "$TERM" ] \
		&& echo -e "$(tput setaf 1)[$LOG_NAME]$(tput sgr0) $*" 1>&2 \
		|| echo -e "[$LOG_NAME] $*" 1>&2
}

die() {
	err "$@"
	exit 1
}

ok_or_die() {
	if [ $? -ne 0 ]; then
		die $1
	fi
}

if [[ $# -lt 6 ]] ; then
	die "Usage: $0 endpoint bucket access_key secret_key local_path remote_path"
fi

endpoint=$1
bucket=$2
access_key=$3
secret_key=$4
local_path=$5
remote_path=$6

info "Will upload $local_path to $remote_path"

mc alias set s3 $endpoint $access_key $secret_key
ok_or_die "Could not set mc alias"

mc cp -r $local_path s3/$bucket/$remote_path
ok_or_die "Could not upload object"
