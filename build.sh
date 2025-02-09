#! /bin/bash

devcontainer --docker-path podman --workspace-folder "$(pwd)" --remove-existing-container true up
