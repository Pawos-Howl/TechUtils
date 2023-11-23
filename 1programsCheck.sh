#! /bin/bash
programNames=("openvpn" "ophcrack")
programContains=("backdoor" "vpn" "crack")
if test -f PROGRAMS.txt; then
    echo "File \"PROGRAMS.txt\" found, using that file"
    echo "to use the current dpkg list, delete this file"
else
    echo "putting dpkg list into \"PROGRAMS.txt\"..."
    dpkg -l > PROGRAMS.txt
fi
issuePrograms=()
issueProgramFull=()
while read -r p; do
    program=`echo $p | cut -d " " -f2`
    if [ "${p:0:2}" = "ii" ]; then
        badProgram=false
        for x in $programNames; do
            if [[ *$p* == *$x* ]]; then
                badProgram=true
            fi
        done
        for x in $programContains; do
            if [[ *$p* == *$x* ]]; then
                badProgram=true
            fi
        done
        if [ $badProgram = true ]; then
            issuePrograms+=$program
            issueProgramFull+=$p
        fi
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