ARG UPSTREAM_VERSION

FROM thorax/erigon:${UPSTREAM_VERSION}

USER root

ENTRYPOINT [ "sh", "-c", "exec rpcdaemon \
    --private.api.addr=\"erigon:9090\" \
    --http.addr=\"0.0.0.0\" \
    --http.vhosts=\"*\" \
    --http.corsdomain=\"*\" \
    --ws \
    --metrics \
    --metrics.addr=\"0.0.0.0\" \
    --metrics.port=\"6060\" \
    $RPCDAEMON_EXTRA_OPTS \
    " ]