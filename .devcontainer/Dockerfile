FROM registry.access.redhat.com/ubi9/python-312:latest

USER root

COPY customize-bash.sh .
RUN source ./customize-bash.sh
ENV POSH_THEME="${HOME}/.posh-themes/powerlevel10k_lean.omp.json"
WORKDIR /workspaces/dev-container
