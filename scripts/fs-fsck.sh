#!/bin/sh

[ -x /usr/bin/fsck ] || exit 0

export PATH=/usr/bin

FORCEARG=
FIXARG="-a"

if [ -r /proc/cmdline ]; then
    for x in $(cat /proc/cmdline); do
        case "$x" in
            fastboot|fsck.mode=skip)
                echo "Skipping filesystem checks (fastboot)."
                exit 0
                ;;
            forcefsck|fsck.mode=force)
                FORCEARG="-f"
                ;;
            fsckfix|fsck.repair=yes)
                FIXARG="-y"
                ;;
            fsck.repair=no)
                FIXARG="-n"
                ;;
        esac
    done
fi

fsck -A -R -C -t noopts=_netdev $FORCEARG $FIXARG
FSCKRET=$?

if [ $(($FSCKRET & 4)) -eq 4 ]; then
    echo "ERROR: at least one fstab filesystem has unrecoverable errors."
    exit 1
fi

# we don't care about the other conditions much; the
# filesystems were either repaired or nothing has happened
exit 0
