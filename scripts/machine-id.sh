#!/bin/sh
#
# prepares a valid machine-id until it can be written to disk (maybe never)
#

export PATH=/sbin:/bin:/usr/sbin:/usr/bin

umask 022

gen_machineid() {
    if command -v dbus-uuidgen > /dev/null 2>&1; then
        dbus-uuidgen
    else
        od -An -N16 -tx /dev/urandom | tr -d ' '
    fi
}

# first boot or empty machine-id; generate something we can use
if [ -e /run/dinit/first-boot -o ! -s /etc/machine-id ]; then
    gen_machineid > /run/dinit/machine-id
fi

# missing machine-id and writable fs; set to uninitialized
if [ ! -e /etc/machine-id ] && touch /etc/machine-id > /dev/null 2>&1; then
    echo uninitialized > /etc/machine-id
fi

# if we generated one, bind-mount it over the real file
if [ -e /run/dinit/machine-id -a -e /etc/machine-id ]; then
    mount --bind /run/dinit/machine-id /etc/machine-id
fi

exit 0
