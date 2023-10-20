#! /bin/bash

# get the users :3

etcPasswd='/etc/passwd'
echo "starting..."
# Starts the array for usernames and stuffs and the removal list
users=()
fusers=()
# fusers means full name of the users
# The list of normal users (based on my system)
sysUsers=("root","daemon","bin","sys","sync","games","man","lp","mail","news","uucp","proxy","www-data","backup","list","irc","_apt","nobody","systemd-network","tss","systemd-timesync","messagebus","avahi-autoipd","usbmux","dnsmasq","avahi","speech-dispatcher","fwupd-refresh","saned","geoclue","polkitd","rtkit","colord","gnome-initial-setup","Debian-gdm")

# Older code that does something?
# while read p; do
#     # usr=p | awk -F ':'
#     echo "Found $p" | awk -F ':'
# done < $etcPasswd
# Still older code...
# Gets just the user as defined in the id (lowercase, may not be the username)
# while IFS=':' read -r line || [[ -n $line ]]; do
#     echo $line | awk -F: '{print $1}'
# done < $etcPasswd

# Exists in list STOLEN
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
# Doesn't work for some reason...
# function existsInList() {
#     LIST=$1
#     VALUE=$2
#     echo "looking for \"$VALUE\" in the list \"$LIST\""
#     for x in $LIST; do
#         echo "looking for $x"
#         if [ "$x" = "$VALUE" ]; then
#         echo "has been finded"
#             return 0
#         fi
#     done
#     echo "has not been finded"
#     return 1
# }

# This will ALSO read the username AND the full name
# cut -d: -f1 /etc/passwd
# cut -d: -f5 /etc/passwd

# Gets username and full name
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

# purge list... welcome to not fun stuff...
# formatted with comas to seperate
# EX: var,usr,stuff,aaa
removalList=$1
echo "Removal list: $removalList"

# Full users list len
usersLen=${#users[@]}

echo "Pulling removal list from users list..."
echo

# This is also broken code qwp
# for value in "${users[@]}"; do
# for x in {0..$usrLen}; do
#     tmpUsr=`echo ${users[x]}`
#     echo "$tmpUsr"
# done

# Users after purge
finalUsers=()
finalFusers=()
for (( i=0; i<$usersLen; i++ )); do 
    # echo "${users[$i]}"
    # The following is a really weird bit of code, and the removal code is intresting. The url to the original is the following:
    # https://stackoverflow.com/questions/23462869/remove-element-from-bash-array-by-content-stored-in-variable-without-leaving-a
    # if exists_in_list "$removalList" "," "${users[i]}"; then
    #     users=( "${users[@]:0:$i}" "${users[@]:$((i + 1))}" )
    #     i=$((i - 1))
    # fi
    # above code doesn't do what I want it to, so going onto using a second list...
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