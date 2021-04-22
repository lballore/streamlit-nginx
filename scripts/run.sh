#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $SCRIPT_DIR/../

TAG=""
PORT="80"  # default port

while getopts ":t:p:" opt; do
    case $opt in
    t)
        TAG="$OPTARG"
        if [ -z "${TAG}" ]; then
            echo "ERROR: Missing image tag"
            exit 1
        fi
        ;;
    p)
        PORT="$OPTARG"
        ;;
    \?)
        echo "Invalid option -$OPTARG" >&2
        exit 1
        ;;
    esac
done

docker run --rm -it -p ${PORT}:8080 streamlit-nginx:${TAG}
