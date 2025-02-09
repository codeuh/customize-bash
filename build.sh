#! /bin/bash

CURRENT_DIR=$(pwd)

EXISTING_CONTAINER_ID=$(podman ps --filter "label=devcontainer.local_folder=${CURRENT_DIR}" --format "{{.ID}}")
EXISTING_IMAGE_ID=$(podman inspect --format "{{.Image}}" $EXISTING_CONTAINER_ID)

echo "Existing Container ID: $EXISTING_CONTAINER_ID"

echo "Existing Image ID: $EXISTING_IMAGE_ID"

CONTAINER_ID=$(devcontainer --docker-path podman \
  --workspace-folder "$(pwd)" \
  --remove-existing-container true \
  --id-label "devcontainer.local_folder=$CURRENT_DIR" \
  up \
  | grep -o '{.*}' | jq -r '.containerId')

echo "Container ID: $CONTAINER_ID"

NEW_IMAGE_ID=$(podman inspect --format "{{.Image}}" $CONTAINER_ID)

echo "New Image ID: $NEW_IMAGE_ID"

if [[ -n "$EXISTING_IMAGE_ID" && "$EXISTING_IMAGE_ID" != "$NEW_IMAGE_ID" ]]; then
  echo "Deleting old image: $EXISTING_IMAGE_ID"
  podman rmi -f "$EXISTING_IMAGE_ID"
fi

podman exec -it -u "root" $CONTAINER_ID /bin/bash -i
