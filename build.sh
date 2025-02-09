#! /bin/bash

CONTAINER_ID=$(devcontainer --docker-path podman \
  --workspace-folder "$(pwd)" \
  --remove-existing-container true \
  up \
  | grep -o '{.*}' | jq -r '.containerId')

podman exec -it $CONTAINER_ID bash
