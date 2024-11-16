ARG UPSTREAM_VERSION

FROM erigontech/erigon:${UPSTREAM_VERSION}

USER root

COPY /security /security
COPY /erigon/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod u+x /usr/local/bin/entrypoint.sh

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]
