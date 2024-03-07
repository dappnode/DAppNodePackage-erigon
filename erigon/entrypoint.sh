#!/bin/sh

case "$_DAPPNODE_GLOBAL_CONSENSUS_CLIENT_MAINNET" in
"prysm.dnp.dappnode.eth")
    echo "Using prysm.dnp.dappnode.eth"
    JWT_PATH="/security/prysm/jwtsecret.hex"
    ;;
"lodestar.dnp.dappnode.eth")
    echo "Using lodestar.dnp.dappnode.eth"
    JWT_PATH="/security/lodestar/jwtsecret.hex"
    ;;
"lighthouse.dnp.dappnode.eth")
    echo "Using lighthouse.dnp.dappnode.eth"
    JWT_PATH="/security/lighthouse/jwtsecret.hex"
    ;;
"teku.dnp.dappnode.eth")
    echo "Using teku.dnp.dappnode.eth"
    JWT_PATH="/security/teku/jwtsecret.hex"
    ;;
"nimbus.dnp.dappnode.eth")
    echo "Using nimbus.dnp.dappnode.eth"
    JWT_PATH="/security/nimbus/jwtsecret.hex"
    ;;
*)
    echo "Using default"
    JWT_PATH="/security/default/jwtsecret.hex"
    ;;
esac

# Print the jwt to the dappmanager
JWT=$(cat $JWT_PATH)
curl -X POST "http://my.dappnode/data-send?key=jwt&data=${JWT}"

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
## We need to re-sync

timeout -s 9 5 erigon --datadir=/home/erigon/.local/share ${EXTRA_OPTs} 2>/tmp/initlog.txt
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
    --authrpc.jwtsecret=${JWT_PATH} \
    --authrpc.addr 0.0.0.0 \
    --authrpc.vhosts=* \
    --db.size.limit=8TB \
    ${EXTRA_OPTs}
