
#!/bin/bash

# Default settings
folder=

# Internal variables
prog=${0##*/}

function usage(){
	cat <<END_USAGE
Encrypts all the files in the thunderbird-folder with GnuPG.

Usage: $prog recipient [options...]

Arguments:
    recipient        The key-ID or mail adress of the one which should encrypt
                     the folder (normally just you)

Options:
    -h, --help       Prints this help message
    -p, --path       The path to the thunderbird profile directory
                     (usually and default: '~/.thunderbird')

For bugs, feature requests or questions: mail@hauke-stieler.de
END_USAGE
}

while (($#))
do
	case "$1" in
	-h|--help)
		usage
		exit 0
		;;
	-p)
		echo "$2"
		shift
		;;
	--path=*)
		folder="${1#*=}"
		shift
		;;
	*)
		shift
		;;
	esac
done

# Check if folder is provided
if [ -z $folder ]
then
	echo "Provide a folder with '-p FOLDER' or '--path=FOLDER'"
	exit 1
fi

echo "Folder to encrypt: $folder"

#find $thunderbird_folder | while read line; do print_file $line; done
