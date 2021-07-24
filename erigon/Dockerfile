ARG UPSTREAM_VERSION

FROM thorax/erigon:${UPSTREAM_VERSION}

USER root

ENTRYPOINT [ "sh", "-c", "exec erigon \ 
    --datadir=/var/lib/erigon \
    --metrics \
    --metrics.addr=\"0.0.0.0\" \
    --metrics.port=\"6060\" \
    --private.api.addr=\"0.0.0.0:9090\" \
    --pprof \
    --pprof.addr=0.0.0.0 \
    --pprof.port=6061 \
    ${ERIGON_EXTRA_OPTS}" ]

