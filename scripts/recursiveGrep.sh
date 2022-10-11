#!/bin/bash

#Usage is sh recursiveGrep "path" | grep whatIwant

checkIfDirectoryOrFile()
{
    if [[ -f "$1" ]]; then
        checkIfFileOrArchive "$1"
    else
        echo DIRECTORY "$1"
    fi
}

checkIfFileOrArchive()
{
    archiveTypes=( "war" "jar" "zip" )
    for fileType in "${archiveTypes[@]}"
    do
        if [[ $1 =~ \.$fileType ]]; then
            echo ARCHIVE "$1"
            unzipAndSearch "$1"
            return
        fi
    done

    echo FILE $1
}

unzipAndSearch()
{
    TEMP_DIRECTORY=$(mktemp -d)
    unzip "$1" -d "$TEMP_DIRECTORY"
    echo "Unzipped $1 to $TEMP_DIRECTORY"
    searchDirectory "$TEMP_DIRECTORY"
    rm -Rf $TEMP_DIRECTORY
}

searchDirectory()
{
    find "$1" -exec bash -c 'checkIfDirectoryOrFile "$0"' {} \;
}

export -f checkIfDirectoryOrFile
export -f checkIfFileOrArchive
export -f unzipAndSearch
export -f searchDirectory

searchDirectory "$1"