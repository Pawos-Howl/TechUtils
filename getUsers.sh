#! /bin/bash

EXCLUSIONLIST=("root" "git") # exclude users
notusrpaths=("/usr/bin/nologin" "/bin/false") # shell paths for not loginable users
usrpaths=("/bin/bash" "/usr/bin/bash") # shell paths for users that can login

#TODO: make it all one loop and have only the final list be posted to.

users=()
fulluser=()
usershell=()
removalList=()

function help() {
    echo "#### getUsers Helper ####"
    echo "-h to print this menu"
    echo "-v to print verbose"
    echo "for the main arguments, use ONE list seperated by commas (ex: user,usr1,usr4)"
    exit 0
}
# print if verbose is on
function printV() {
    if [[ $verbose == "t" ]]; then
        echo $1
    fi
}
# arg parser
while [[ $# -gt 0 ]]; do
  case $1 in
    -v)
      verbose="t"
      shift # past argument
      ;;
    -h)
      help
      ;;
    *)
      IFS=',' read -a removalList <<< "$1"
      shift
      ;;
  esac
done

printV "Removal list: $removalList"

function exists_in_list() {
    VALUE=$1
    shift # go past the first input
    LIST=$@
    
    LIST_WHITESPACES=`echo $LIST | tr " " " "`
    for x in $LIST_WHITESPACES; do
        if [ "$x" = "$VALUE" ]; then
            return 0
        fi
    done
    return 1
}

# effectively, are they a system user or a loginable user
# 0 is login, 1 is what i know is no login, 2 is i have no clue
function canlogin() {
    SHELL=$1
    if exists_in_list "$SHELL" "${usrpaths[@]}"; then # "${array[@]}"
        return 0
    elif exists_in_list "$SHELL" "${notusrpaths[@]}"; then
        return 1
    else
        return 2
    fi
}

while read p; do
    uname=`echo $p | cut -d: -f1`
    fname=`echo $p | cut -d: -f5`
    shell=`echo $p | cut -d: -f7`
    if exists_in_list "$uname" "${EXCLUSIONLIST[@]}"; then
        printV "IGNORING $uname as $fname (in the exclusion list)"
    else
        printV "FOUND $uname as $fname"
        users+=("$uname")
        fulluser+=("$fname")
        usershell+=("$shell")
    fi
done < '/etc/passwd'

usersLen=${#users[@]}

# Users after purge
finalUsers=()
finalfulluser=()
finalushell=()
for (( i=0; i<$usersLen; i++ )); do 
    if exists_in_list "${users[i]}" "${removalList[@]}"; then
        printV "IGNORING ${users[i]} as ${fulluser[i]} from final list (excluded user)"
    else
        # do one more check on the shell
        # echo `canlogin "${usershell[i]}"`
        # echo "${usershell[i]}"
        if canlogin "${usershell[i]}"; then
            printV "ADDING ${users[i]} as ${fulluser[i]} to final list"
            finalUsers+=("${users[i]}")
            finalfulluser+=("${fulluser[i]}")
        else
            printV "IGNORING ${users[i]} as ${fulluser[i]} from final list (not loginable shell/not recognized)"
        fi
    fi

done

echo "-------------"
echo "LIST COMPILED"
echo "-------------"
echo
if [ -z "$finalUsers" ]; then
    echo "No one that is not supposed to be on the system is present. You are fine"
else
    echo "Final list:"
    for (( i=0; i<${#finalUsers[@]}; i++ )); do
        echo "USER \"${finalUsers[i]}\" as \"${finalfulluser[i]}\""
    done
fi