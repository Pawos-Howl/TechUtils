#! /bin/bash

echo "starting..."

unauthFiles=()
unauthExtensions=()
# Media files to catch, and their lists
# This is by no means all of them, but it should catch a lot of them
audioExtensions=("m4a" "flac" "mp3" "pcm" "wav" "ogg")
videoExtensions=("mp4" "mov" "avi" "mkv")
imageExtensions=("jpg" "png" "tiff" "webp" "pdf" "gif" "eps" "raw")

directory=""
files=""

# TODO: steal better boilerplate code for this
# -v for verbose to say other things so you know it is running
# -V for even more verbose
# -s for a short check of just mp3/png
# have a check for "all" or "audio" or "video" or "image"
# last check should be if it is a directory
# failing all of them makes it exit 1

# Param count checks
if [ "$#" -eq 0 ]; then
    # NO arguments at all
    echo "No args supplied"
    echo "setting to defaults..."
    # Lets call the defaults...
    directory="/home"
    files="all"
elif [ "$#" -eq 1 ]; then
    # Only one argument
    directory=$1
    echo "setting \"files\" to default"
    files="all"
elif [ "$#" -eq 2 ]; then
    # Both arguments
    echo "found both args, setting"
    directory=$1
    files=$2
else
    # too many arguments
    echo "Too many parameters..."
    exit 1
fi

if ! [ -d  $directory ]; then
    echo "the directory does not exist!"
    echo "setting to \"/home\""
    directory="/home"
fi

if test -f PATHS.txt; then
    echo "File \"PATHS.txt\" exists, using that file"
    echo "to use a DIFFERENT path, delete this file and rerun this script"
else
    echo "finding all files and putting them into \"PATHS.txt\"..."
    find $directory > PATHS.txt
    echo "files in location parsed"
fi

# Setting up the lists for files to look at
# below sets it to empty
echo "Files param: $files"
files=`echo "$files" | tr '[:upper:]' '[:lower:]'`

FilesToCheck=`echo $files | tr "," " "`
echo "FILES TO CHECK: $FilesToCheck"
for x in $FilesToCheck; do
    echo "FILES CHECK PASSING: \"$x\""
    if [ "$x" = "all" ]; then
        echo "adding \"all\" to the list to check"
        unauthExtensions=(${unauthExtensions[@]} ${audioExtensions[@]})
        unauthExtensions=(${unauthExtensions[@]} ${videoExtensions[@]})
        unauthExtensions=(${unauthExtensions[@]} ${imageExtensions[@]})
    elif [ "$x" = "audio" ]; then
        echo "adding \"audio\" to the list to check"
        unauthExtensions=(${unauthExtensions[@]} ${audioExtensions[@]})
    elif [ "$x" = "video" ]; then
        echo "adding \"video\" to the list to check"
        unauthExtensions=(${unauthExtensions[@]} ${videoExtensions[@]})
    elif [ "$x" = "image" ]; then
        echo "adding \"image\" to the list to check"
        unauthExtensions=(${unauthExtensions[@]} ${imageExtensions[@]})
    else
        echo "unknown \"$x\""
    fi
done
echo "UNAUTH EXTENSIONS: ${unauthExtensions[@]}"

while read -r p; do
    echo "reading path \"$p\""
    tmpExtension="${p##*.}"
    echo "looking at extension \"$tmpExtension\""
    echo "Passing ext:\"$tmpExtension\" in the list of \"${unauthExtensions[@]}\""
    # below is the variable responsible for the status of finding a thing and it acts as a reset
    finds=false

    # the thing responsible for finding the thing
    for ext in "${unauthExtensions[@]}"; do
        echo "passing: \"$ext\" to check \"$tmpExtension\""
        if [ "$tmpExtension" = "$ext" ]; then
            echo "FIND ext: \"$ext\" from part: \"$tmpExtension\""
            finds=true  # Extension found in the list
        fi
    done
    
    if [ "$finds" = true ]; then
        echo "FILE AT PATH \"$p\" CAUGHT"
        unauthFiles+=("$p")
    else
        echo "FILE AT PATH \"$p\" OK"
    fi
done < "PATHS.txt"

echo "-------------"
echo "LIST COMPILED"
echo "-------------"
echo
# Final prints
if [ -z "$unauthFiles" ]; then
    echo "No unauthorized files were found on the system. You can sleep easy knowing your system has no distractions"
else
    echo "Final list:"
    for (( i=0; i<${#unauthFiles[@]}; i++ )); do
        echo "FILE AT PATH \"${unauthFiles[i]}\" FOUND"
    done
fi