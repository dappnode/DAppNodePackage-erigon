#!/bin/sh -c

#####################
# Datadir migration #
#####################
# UPSTREAM: 2021.08.03
# DAPPNODE: v0.1.7 to v0.1.8
# Datadir migration must be done manually according to https://github.com/ledgerwatch/erigon/releases/tag/v2021.08.03

DATADIR="/home/erigon/.local/share"

if [ ! -d "$DATADIR/erigon/chaindata" ]; then
    mv "$DATADIR/erigon/chaindata" "$DATADIR"
fi

##########
# Erigon #
##########

exec erigon --datadir=${DATADIR} \
    --metrics \
    --metrics.addr=\"0.0.0.0\" \
    --metrics.port=\"6060\" \
    --private.api.addr=\"0.0.0.0:9090\" \
    --pprof \
    --pprof.addr=0.0.0.0 \
    --pprof.port=6061 \
    ${ERIGON_EXTRA_OPTS}