#!/usr/bin/env bash

if DDS=$(/opt/core/bin/dds); then
    zfs create "${DDS}/pgsql" || true

    zfs set compression=lz4 "${DDS}/pgsql"
    zfs set mountpoint=/var/pgsql "${DDS}/pgsql"
fi
