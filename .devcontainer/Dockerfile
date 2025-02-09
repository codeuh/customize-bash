FROM registry.access.redhat.com/ubi9/python-312:latest

USER 0

COPY customize-bash.sh .
RUN source ./customize-bash.sh
ENV POSH_THEME="${HOME}/.posh-themes/kushal.omp.json"
WORKDIR /workspaces/dev-container

RUN  git config --global user.email "codeuh@gmail.com" \
     && git config --global user.name "codeuh"
