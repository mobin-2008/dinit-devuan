#!/bin/sh
#
# tries to commit machine-id to disk to mark boot done
#

export PATH=/sbin:/bin:/usr/sbin:/usr/bin

# was never bind-mounted, so just exit
mountpoint -q /etc/machine-id || exit 0
# no generated machine-id
test -e /run/dinit/machine-id || exit 0

umount /etc/machine-id

if touch /etc/machine-id > /dev/null 2>&1; then
    cat /run/dinit/machine-id > /etc/machine-id
else
    # failed to write, bind it again
    mount --bind /run/dinit/machine-id /etc/machine-id
fi

exit 0
