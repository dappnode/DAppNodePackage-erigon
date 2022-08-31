#!/bin/sh

#####################
# Datadir migration #
#####################
# UPSTREAM: 2021.08.03
# DAPPNODE: v0.1.7 to v0.1.8
# Datadir migration must be done manually according to https://github.com/ledgerwatch/erigon/releases/tag/v2021.08.03

PORT="${P2P_PORT:=30303}"

DATADIR="/home/erigon/.local/share"

if [ -d "$DATADIR/erigon/chaindata" ]; then
    mv "$DATADIR/erigon/chaindata" "$DATADIR"
fi

############################
# Check database migration #
############################
# UPSTREAM: v2022.04.01
# DAPPNODE: v0.1.22 to v0.1.23

## Run for 5 secs to check the logs if we found:
## [EROR] [06-27|17:36:39.664] Erigon startup err="migrator.VerifyVersion: cannot upgrade major DB version for more than 1 version from 3 to 6, use integration tool if you know what you are doing"
## We need to re-sync

timeout 5 erigon --datadir=/home/erigon/.local/share 2>/tmp/initlog.txt
if grep -e "migrator.VerifyVersion: cannot upgrade major DB version for more than 1 version from 3 to 6, use integration tool if you know what you are doing" /tmp/initlog.txt; then
    echo "Cannot upgrade major DB version for more than 1 version from 3 to 6"
    echo "The database will be deleted as it needs to be resynchronized..."
    rm /home/erigon/.local/share/chaindata/*
fi

##########
# Erigon #
##########

exec erigon --datadir=${DATADIR} \
    --http.addr=0.0.0.0 \
    --http.vhosts=* \
    --http.corsdomain=* \
    --ws \
    --private.api.addr=0.0.0.0:9090 \
    --metrics \
    --metrics.addr=0.0.0.0 \
    --metrics.port=6060 \
    --pprof \
    --pprof.addr=0.0.0.0 \
    --pprof.port=6061 \
    --port=${P2P_PORT} \
    --authrpc.jwtsecret=/jwtsecret \
    --authrpc.addr 0.0.0.0 \
    --authrpc.vhosts=* \
    ${EXTRA_OPTs}

#    --engine.port=8551 \