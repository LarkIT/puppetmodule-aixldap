#!/bin/sh
# This will get a list of local users, that are not a common system user, that
# need to have default registry and SYSTEM attributes set.
PATH='/bin:/sbin:/usr/bin:/usr/sbin'
export PATH
if [ `uname` == 'AIX' ]; then
    sysusers="bin daemon sys adm uucp nobody lpd lp invscout snapp nuucp ipsec pconsole esaadmin sshd srvproxy"
    tmpstring=""
    for i in $sysusers; do
        idstring="^$i\$"
        tmpstring="$tmpstring|$idstring"
    done
    exclude=$(echo "$tmpstring" | cut -c 2-)

    ## 'users' are non-standard users discovered, could be appuser/realuser
    users=$(lsuser -C -R files -a registry SYSTEM ALL | egrep -v '^#|files:compat$' | awk -F: '{print $1}' | egrep -v "$exclude" | xargs echo)
    echo "aix_local_users=${users}"
fi
