FROM registry.access.redhat.com/ubi9/ubi-minimal:latest
USER root
COPY customize-bash.sh .
RUN ./customize-bash.sh
ENV POSH_THEME="/root/.posh-themes/tokyo.omp.json"
