FROM registry.access.redhat.com/ubi9/python-312:latest

USER 0

COPY .devcontainer/pimped-terminal.sh .
RUN source ./pimped-terminal.sh
ENV POSH_THEME="${HOME}/.posh-themes/kushal.omp.json"
