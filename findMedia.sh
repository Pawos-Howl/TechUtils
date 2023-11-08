#! /bin/bash

echo "starting..."

# echo "Searching /home (because it is safer lol and no system files)"
# Set up the list to catch all media
# Trying a string, hoping new lines get caught
unauthFiles=()
unauthExtensions=()
# Media files to catch, and their lists
# This is by no means all of them, but it should catch a lot of them
audioExtensions=("m4a" "flac" "mp3" "pcm" "wav" "ogg")
videoExtensions=("mp4" "mov" "avi" "mkv")
imageExtensions=("jpg" "png" "tiff" "webp" "pdf" "gif" "eps" "raw")

# The """CONFIG"""
# Just comment out unwanted things (for now ;3)
# This goes in later, now that I am going to have a param for it
# unauthExtensions=(${unauthExtensions[@]} ${audioExtensions[@]})
# unauthExtensions=(${unauthExtensions[@]} ${videoExtensions[@]})
# unauthExtensions=(${unauthExtensions[@]} ${imageExtensions[@]})

# Not using functions for this :3
# Exists in list STOLEN
# function exists_in_list() {
#     LIST=$1
#     DELIMITER=$2
#     VALUE=$3
#     LIST_WHITESPACES=`echo $LIST | tr "$DELIMITER" " "`
#     for x in $LIST_WHITESPACES; do
#         if [ "$x" = "$VALUE" ]; then
#             return 0
#         fi
#     done
#     return 1
# }
# This was also kinda just taken lol
# This also isn't working, but not due to the funciton itself
# function check_extension() {
#     local extension_to_check="$1"
#     echo "Var:\"$extension_to_check\""
#     local extension_list=("$2")
#     echo "List:\"$extension_list\""

#     for ext in "${extension_list[@]}"; do
#         echo "passing: \"$ext\" to check \"$extension_to_check\""
#         if [ "$extension_to_check" = "$ext" ]; then
#             echo "FINDS master ext: \"$ext\" from part: \"$extension_to_check\""
#             return 0  # Extension found in the list
#         fi
#     done
#     echo "NOT FINDS"
#     return 1  # Extension not found in the list
# }

directory=""
files=""

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

# This does not work...
# IFS=',' read -ra FilesToCheck <<< "$files"

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
# echo $unauthExtensions
# if exists_in_list "$files" "," "all"; then
#     unauthExtensions=(${unauthExtensions[@]} ${audioExtensions[@]})
#     unauthExtensions=(${unauthExtensions[@]} ${videoExtensions[@]})
#     unauthExtensions=(${unauthExtensions[@]} ${imageExtensions[@]})
# elif exists_in_list "$files" "," "audio"; then
#     unauthExtensions=(${unauthExtensions[@]} ${audioExtensions[@]})
# elif exists_in_list "$files" "," "video"; then
#     unauthExtensions=(${unauthExtensions[@]} ${videoExtensions[@]})
# elif exists_in_list "$files" "," "image"; then
#     unauthExtensions=(${unauthExtensions[@]} ${imageExtensions[@]})
# fi
# echo $unauthExtensions

# Because something isn't workin...
echo "UNAUTH EXTENSIONS: ${unauthExtensions[@]}"

# Goes though every file in "PATHS.txt"
# while read -r p; do
#     echo "reading path \"$p\""
#     tmpExtension="${p##*.}"
#     echo "looking at extension \"$tmpExtension\""
#     echo "Passing ext:\"$tmpExtension\" in the list of \"${unauthExtensions[@]}\""
#     if check_extension "$tmpExtension" "$unauthExtensions"; then
#         echo "EXTENSION \"$tmpExtension\" CAUGHT"
#         unauthFiles+=("$p")
#     else
#         echo "extension ok"
#     fi
# done < "PATHS.txt"
# the calling a function method isn't working due to how this list is... the function will not take the value correctly
# trying embedding the function's job in the only place it is called
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
            echo "FINDS master ext: \"$ext\" from part: \"$tmpExtension\""
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
    echo "No unauthorized files were found on the system. You can sleep easy knowing your system has no distractions ;3"
else
    echo "Final list:"
    for (( i=0; i<${#unauthFiles[@]}; i++ )); do
        echo "FILE AT PATH \"${unauthFiles[i]}\" FOUND"
    done
fi