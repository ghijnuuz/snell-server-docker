#!/bin/ash

set -e

BIN="/usr/bin/snell-server"
CONF="/etc/snell-server.conf"

# reuse existing config when the container restarts

run_bin() {
    echo "Running snell-server with config:"
    echo ""
    cat ${CONF}

    ${BIN} --version
    ${BIN} -c ${CONF}
}

if [ -f ${CONF} ]; then
    echo "Found existing config, rm it."
    rm ${CONF}
fi

if [ -z ${PSK} ]; then
    PSK=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 16)
    echo "Using generated PSK: ${PSK}"
else
    echo "Using predefined PSK: ${PSK}"
fi

if [ -z ${PORT} ]; then
    PORT="9102"
fi

echo "Generating new config..."
echo "[snell-server]" >> ${CONF}
echo "listen = :::${PORT}" >> ${CONF}
echo "psk = ${PSK}" >> ${CONF}
if [ -n ${IPV6} ]; then
    echo "ipv6 = ${IPV6}" >> ${CONF}
fi
if [ -n ${OBFS} ]; then
    echo "obfs = ${OBFS}" >> ${CONF}
fi
if [ -n ${OBFS_HOST} ]; then
    echo "obfs-host = ${OBFS_HOST}" >> ${CONF}
fi
if [ -n ${OBFS_URI} ]; then
    echo "obfs-uri = ${OBFS_URI}" >> ${CONF}
fi

run_bin
