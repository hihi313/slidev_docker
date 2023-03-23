#!/bin/bash

echo "Sart time=$(date +"%T")"
IMG_NAME="slidev"
IMG_TAG="latest"
CTNR_NAME="${IMG_NAME}_ctnr"
WORKDIR="/app"
PORT=3030

VOLUME=""
while getopts "f:b:ei:t:v:r:" opt
do
  case $opt in
    f)
        DOCKERFILE="$OPTARG"
        ;;
    b) 
        if [ "$OPTARG" == "n" ]; then
            CACHE="--no-cache"
        else
            CACHE=""
        fi

        START="$(TZ=UTC0 printf '%(%s)T\n' '-1')" # `-1`  is the current time
        
        docker rmi $IMG_NAME
        if [ -z ${DOCKERFILE+x} ]; then
            docker build $CACHE -t $IMG_NAME .
        else
            docker build $CACHE -t $IMG_NAME -f ${DOCKERFILE} .
        fi

        # Pring elapsed time
        ELAPSED=$(( $(TZ=UTC0 printf '%(%s)T\n' '-1') - START ))
        TZ=UTC0 printf 'Build duration=%(%H:%M:%S)T\n' "$ELAPSED"
        ;;
    e)
        docker exec -it $CTNR_NAME  bash
        ;;
    i)
        IMG_NAME="$OPTARG"
        ;;
    t)
        IMG_TAG="$OPTARG"
        ;;
    v)
        VOLUME="-v $OPTARG"
        ;;
    r)
        RM=""
        if [[ $OPTARG == *"m"* ]]; then
            RM="--rm"
        fi
        # Enable tracing
        # --user node \
        set -x
        docker run --rm -it \
            -v ${PWD}:${WORKDIR} \
            -p ${PORT}:${PORT} \
            --name ${CTNR_NAME} \
            ${IMG_NAME} bash
        # Disable tracing
        set +x
        ;;
    \?) 
        echo "Invalid option -$OPTARG" >&2
        exit 1
        ;;
    :)
        echo "Option -$OPTARG requires an argument." >&2
        exit 1
        ;;
    *)
        echo "*"
        ;;
  esac
done