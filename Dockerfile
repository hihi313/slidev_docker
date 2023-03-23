FROM node:18.15.0-slim

ENV WORKDIR=/app
ARG NPM_DPDS=npm_packages.txt

USER root

WORKDIR /tmp

# COPY ${NPM_DPDS} .
# RUN xargs npm install < ${NPM_DPDS}
RUN npm install @slidev/cli @slidev/theme-default @slidev/theme-seriph


WORKDIR /app

COPY entrypoint.sh /
ENTRYPOINT /entrypoint.sh

CMD bash
