#! /bin/bash

# lists of program names and things to look for as "malicious"
programNames=("openvpn" "ophcrack")
programContains=("backdoor" "vpn" "crack")

# put all of dpkg into a file named "PROGRAMS.txt" and uses current one if found
if test -f PROGRAMS.txt; then
    echo "File \"PROGRAMS.txt\" found, using that file"
    echo "to use the current dpkg list, delete this file"
else
    echo "putting dpkg list into \"PROGRAMS.txt\"..."
    dpkg -l > PROGRAMS.txt
    echo "dpkg thrown into file"
fi

# Issue programs and full descriptions
issuePrograms=()
issueProgramFull=()

# parse line by line of the file checking for program names and things that could indicate an issue or backdoor
while read -r p; do
    echo "Reading line \"$p\""
    echo "This is the double 'i' check, and the value is \"${p:0:2}\""
    program=`echo $p | cut -d " " -f2` # that is the program name... i spent way too long thinking it was the double i qwp
    echo "The program name should be \"$program\""
    if [ "${p:0:2}" = "ii" ]; then
        echo "inner checks on \"$program\""
        badProgram=false # this is just a small thing as i did before to figure out if the program isn't good
        for x in $programNames; do
            # I am doing the program names check on the ENTIRE line, because it might be a lib package of the program, which we also want deleted ;3
            echo "Looking for \"$x\" in line \"$p\""
            if [[ $p == *$x* ]]; then
                badProgram=true
            fi
        done
        # This checks the whole line for stuff in the list of bad
        for x in programContains; do
            echo "Looking for \"$x\" in line \"$p\""
            if [[ $p == *$x* ]]; then
                badProgram=true
            fi
        done
        
        # Check if the line was marked as bad
        echo "Status of badProgram var: $badProgram"
        if [ badProgram = true ]; then
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

# return all the things that are marked as SUS
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