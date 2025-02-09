#! /bin/bash

CONTAINER_ID=$(devcontainer --docker-path podman \
  --workspace-folder "$(pwd)" \
  --remove-existing-container true \
  --mount "type=bind,source=/home/codeuh/.gitconfig,target=/root/.gitconfig" \
  up \
  | grep -o '{.*}' | jq -r '.containerId')

podman exec -it $CONTAINER_ID bash
