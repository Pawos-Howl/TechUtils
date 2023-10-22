#! /bin/bash
etcPasswd='/etc/passwd'
echo "starting..."
users=()
fusers=()
sysUsers=("root","daemon","bin","sys","sync","games","man","lp","mail","news","uucp","proxy","www-data","backup","list","irc","_apt","nobody","systemd-network","tss","systemd-timesync","messagebus","avahi-autoipd","usbmux","dnsmasq","avahi","speech-dispatcher","fwupd-refresh","saned","geoclue","polkitd","rtkit","colord","gnome-initial-setup","Debian-gdm")
# Comment the following out if NOT on Ubuntu
UbuntuSysUsers=("gnats","systemd-resolve","syslog","uuidd","tcpdump","cups-pk-helper","kernoops","hplip","whoopsie","pulse","gmd","systemd-coredump","sshd")
sysUsers=(${sysUsers[@]} ${UbuntuSysUsers[@]})

function exists_in_list() {
    LIST=$1
    DELIMITER=$2
    VALUE=$3
    LIST_WHITESPACES=`echo $LIST | tr "$DELIMITER" " "`
    for x in $LIST_WHITESPACES; do
        if [ "$x" = "$VALUE" ]; then
            return 0
        fi
    done
    return 1
}
while read p; do
    uname=`echo $p | cut -d: -f1`
    fname=`echo $p | cut -d: -f5`
    if exists_in_list "$sysUsers" "," "$uname"; then
        echo "IGNORING $uname as $fname"
    else
        echo "FOUND $uname as $fname"
        users+=("$uname")
        fusers+=("$fname")
    fi
done < $etcPasswd
echo "-------------"
echo "LIST COMPILED"
echo "-------------"
echo
echo "final list: $users"
echo "final list (full names): $fname"
echo "starting removals..."
removalList=$1
echo "Removal list: $removalList"
usersLen=${#users[@]}

echo "Pulling removal list from users list..."
echo

finalUsers=()
finalFusers=()
for (( i=0; i<$usersLen; i++ )); do 
    if exists_in_list "$removalList" "," "${users[i]}"; then
        echo "IGNORING ${users[i]} as ${fusers[i]} fromm final list"
    else
        echo "ADDING ${users[i]} as ${fusers[i]} to final list"
        finalUsers+=("${users[i]}")
        finalFusers+=("${fusers[i]}")
    fi
done

echo "-------------"
echo "LIST COMPILED"
echo "-------------"
echo
if [ -z "$finalUsers" ]; then
    echo "No one that is not supposed to be on the system is present. You are safe ;3"
else
    echo "Final list:"
    for (( i=0; i<${#finalUsers[@]}; i++ )); do
        echo "USER \"${finalUsers[i]}\" as \"${finalFusers[i]}\""
    done
fi