#!/bin/sh -c

#####################
# Datadir migration #
#####################
# UPSTREAM: 2021.08.03
# DAPPNODE: v0.1.7 to v0.1.8
# Datadir migration must be done manually according to https://github.com/ledgerwatch/erigon/releases/tag/v2021.08.03

NEW_CHAINDATA_DIR="/home/erigon/.local/share"
OLD_CHAINDATA_DIR="/var/lib/erigon/erigon"

if [ -d "$OLD_CHAINDATA_DIR" ]; then 
    echo "Migrating chaindatadir from ${OLD_CHAINDATA_DIR} to ${NEW_CHAINDATA_DIR}"
    [ ! -d "$OLD_CHAINDATA_DIR/chaindata" ] && { echo "Cannot perform migration, old chaindatadir ${OLD_CHAINDATA_DIR}/chaindata must exist"; exit 1 }
    mkdir -p "$NEW_CHAINDATA_DIR"
    mv "${OLD_CHAINDATA_DIR}/chaindata" "$NEW_CHAINDATA_DIR"
    echo "Migration done"
    rm -rf "$OLD_CHAINDATA_DIR"
done

##########
# Erigon #
##########

exec erigon --datadir=/home/erigon/.local/share \
    --metrics \
    --metrics.addr=\"0.0.0.0\" \
    --metrics.port=\"6060\" \
    --private.api.addr=\"0.0.0.0:9090\" \
    --pprof \
    --pprof.addr=0.0.0.0 \
    --pprof.port=6061 \
    ${ERIGON_EXTRA_OPTS}

