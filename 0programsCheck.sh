#! /bin/bash
programNames=("openvpn" "ophcrack")
programContains=("backdoor" "vpn" "crack")
if test -f PROGRAMS.txt; then
    echo "File \"PROGRAMS.txt\" found, using that file"
    echo "to use the current dpkg list, delete this file"
else
    echo "putting dpkg list into \"PROGRAMS.txt\"..."
    dpkg -l > PROGRAMS.txt
    echo "dpkg thrown into file"
fi
issuePrograms=()
issueProgramFull=()
while read -r p; do
    echo "Reading line \"$p\""
    echo "This is the double 'i' check, and the value is \"${p:0:2}\""
    program=`echo $p | cut -d " " -f2`
    echo "The program name should be \"$program\""
    if [ "${p:0:2}" = "ii" ]; then
        echo "inner checks on \"$program\""
        badProgram=false
        for x in $programNames; do
            echo "Looking for \"$x\" in line \"$p\""
            if [[ *$p* == *$x* ]]; then
                badProgram=true
            fi
        done
        for x in $programContains; do
            echo "Looking for \"$x\" in line \"$p\""
            if [[ *$p* == *$x* ]]; then
                badProgram=true
            fi
        done
        echo "Status of badProgram var: $badProgram"
        if [ $badProgram = true ]; then
            echo "program \"$program\" found as bad, adding to lists"
            issuePrograms+=$program
            issueProgramFull+=$p
        else
            echo "Prowogram looks ok"
        fi
    else
        echo "not double \"i\""
    fi
done < "PROGRAMS.txt"
echo "-------------"
echo "LIST COMPILED"
echo "-------------"
echo
if [ -z "$issuePrograms" ]; then
    echo "No sus programs detected. You are safe ;3"
else
    echo "Final list:"
    for (( i=0; i<${#issuePrograms[@]}; i++ )); do
        echo "Program \"${issuePrograms[i]}\" with the full line \"${issueProgramFull[i]}\" was marked as an issue program"
    done
fi