
#!/bin/bash

# Default settings
folder=
output_folder=./output_gpgfe

# Internal variables
prog=${0##*/}

function usage(){
	cat <<END_USAGE
Encrypts all the files in the thunderbird-folder with GnuPG.

Usage: $prog recipient input [options...]

Arguments:
    recipient       The key-ID or mail adress of the one which should encrypt
                    the folder (normally just you)
    input           The input folder which filed should be encrypted

Options:
    -h, --help      Prints this help message
    -o, --output    Specify output folder.
                    Default: ./output_gpgfe/

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
	-o)
		output_folder="$2"
		shift
		;;
	--output=*)
		output_folder="${1#*=}"
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
echo "Output folder:     $output_folder"

#find $thunderbird_folder | while read line; do print_file $line; done
