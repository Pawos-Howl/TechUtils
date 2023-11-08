#! /bin/bash
unauthFiles=()
unauthExtensions=()
audioExtensions=("m4a" "flac" "mp3" "pcm" "wav" "ogg")
videoExtensions=("mp4" "mov" "avi" "mkv")
imageExtensions=("jpg" "png" "tiff" "webp" "pdf" "gif" "eps" "raw")
directory=""
files=""
if [ "$#" -eq 0 ]; then
    echo "No args supplied"
    echo "setting to defaults..."
    directory="/home"
    files="all"
elif [ "$#" -eq 1 ]; then
    directory=$1
    echo "setting \"files\" to default"
    files="all"
elif [ "$#" -eq 2 ]; then
    echo "found both args, setting"
    directory=$1
    files=$2
else
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
files=`echo "$files" | tr '[:upper:]' '[:lower:]'`
FilesToCheck=`echo $files | tr "," " "`
for x in $FilesToCheck; do
    echo "FILES CHECK PASSING: \"$x\""
    if [ "$x" = "all" ]; then
        unauthExtensions=(${unauthExtensions[@]} ${audioExtensions[@]})
        unauthExtensions=(${unauthExtensions[@]} ${videoExtensions[@]})
        unauthExtensions=(${unauthExtensions[@]} ${imageExtensions[@]})
    elif [ "$x" = "audio" ]; then
        unauthExtensions=(${unauthExtensions[@]} ${audioExtensions[@]})
    elif [ "$x" = "video" ]; then
        unauthExtensions=(${unauthExtensions[@]} ${videoExtensions[@]})
    elif [ "$x" = "image" ]; then
        unauthExtensions=(${unauthExtensions[@]} ${imageExtensions[@]})
    fi
done
while read -r p; do
    tmpExtension="${p##*.}"
    finds=false
    for ext in "${unauthExtensions[@]}"; do
        if [ "$tmpExtension" = "$ext" ]; then
            finds=true
        fi
    done
    if [ "$finds" = true ]; then
        unauthFiles+=("$p")
    fi
done < "PATHS.txt"
echo "-------------"
echo "LIST COMPILED"
echo "-------------"
echo
if [ -z "$unauthFiles" ]; then
    echo "No unauthorized files were found on the system. You can sleep easy knowing your system has no distractions ;3"
else
    echo "Final list:"
    for (( i=0; i<${#unauthFiles[@]}; i++ )); do
        echo "FILE AT PATH \"${unauthFiles[i]}\" FOUND"
    done
fi