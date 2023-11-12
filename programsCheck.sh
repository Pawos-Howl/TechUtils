#! /bin/bash

# lists of program names and things to look for as "malicious"
programNames=("openvpn" "ophcrack")
programContains=("backdoor" "vpn" "crack")

# put all of dpkg into a file named "PROGRAMS.txt" and uses current one if fou d
if test -f PROGRAMS.txt; then
    echo "File \"PROGRAMS.txt\" found, using that file"
    echo "to use the current dpkg list, delete this file"
else
    echo "putting dpkg list into \"PROGRAMS.txt\"..."
    dpkg -l > PROGRAMS.txt
    echo "dpkg thrown into file"
fi

# parse line by line of the file checking for program names and things that could indicate an issue or backdoor
