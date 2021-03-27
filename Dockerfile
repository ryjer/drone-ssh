FROM alpine

RUN apk add --no-cache openssh-client sshpass \
    && mkdir /ssh \
    && mkdir -p /root/.ssh

COPY ./docker-entrypoint.sh /bin/docker-entrypoint.sh

ENTRYPOINT ["timeout", "$PLUGIN_TIMEOUT", "/bin/docker-entrypoint.sh"]
