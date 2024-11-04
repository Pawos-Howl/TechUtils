#! /bin/bash

# lists of program names and things to look for as "malicious"
programNames=("openvpn" "ophcrack")
programContains=("backdoor" "vpn" "crack")

function help() {
    echo "#### programsCheck Helper ####"
    echo "-h to print this menu"
    echo "-v to print verbose"
    echo "-V to print even more verbose"
    echo "-p to remake the programs file (in case of error) or program changes"
    echo "you provide... uh... um... hmm... atm nothing"
    exit 0
}
function printV() {
    if [[ $verbose == "t" ]] || [[ $verbose == "T" ]]; then
        echo $1
    fi
}
function printVV() {
    if [[ $verbose == "T" ]]; then
        echo $1
    fi
}
while [[ $# -gt 0 ]]; do
  case $1 in
    -v)
      verbose="t"
      shift # past argument
      ;;
    -V)
      verbose="T"
      shift
      ;;
    -h)
      help
      ;;
    -p)
      fetchPrograms="t"
      shift
      ;;
    *)
      echo "nah. -h for help lol"
      exit 1
      ;;
  esac
done

if [ -f PROGRAMS.txt ] && [[ $fetchPrograms != "t" ]]; then
    printV "File \"PROGRAMS.txt\" found, using that file"
    printV "to use the current dpkg list, delete this file"
else
    printV "putting dpkg list into \"PROGRAMS.txt\"..."
    dpkg -l > PROGRAMS.txt
    printV "dpkg thrown into file"
fi

issuePrograms=()
issueProgramFull=()

while read -r p; do
    printV "Reading line \"$p\""
    printVV "This is the double 'i' check, and the value is \"${p:0:2}\""
    program=`echo $p | cut -d " " -f2`
    printVV "The program name should be \"$program\""
    if [ "${p:0:2}" = "ii" ]; then
        printVV "inner checks on \"$program\""
        badProgram=false
        for x in $programNames; do
            printVV "Looking for \"$x\" in line \"$p\""
            if [[ *$p* == *$x* ]]; then
                badProgram=true
            fi
        done
        for x in $programContains; do
            printVV "Looking for \"$x\" in line \"$p\""
            if [[ *$p* == *$x* ]]; then
                badProgram=true
            fi
        done
        
        printVV "Status of badProgram var: $badProgram"
        if [ $badProgram = true ]; then
            printVV "program \"$program\" found as bad, adding to lists"
            issuePrograms+=$program
            issueProgramFull+=$p
        else
            printVV "Prowogram looks ok"
        fi

    else
        printV "not double \"i\""
    fi
done < "PROGRAMS.txt"

echo "-------------"
echo "LIST COMPILED"
echo "-------------"
echo
if [ -z "$issuePrograms" ]; then
    echo "No sus programs detected. You are fine"
else
    echo "Final list:"
    for (( i=0; i<${#issuePrograms[@]}; i++ )); do
        echo "Program \"${issuePrograms[i]}\" with the full line \"${issueProgramFull[i]}\" was marked as an issue program"
    done
fi