#!/bin/bash

set -e

# Default settings
recipient=
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
                    Default: ./output_gpgfe

For bugs, feature requests or questions: mail@hauke-stieler.de
END_USAGE
}

# Check if recipient is provided
recipient=$1
if [ -z $recipient ]
then
	echo "Provide a recipient as first argument"
	exit 1
fi

# Check if folder is provided
folder=$2
if [ -z $folder ]
then
	echo "Provide an input folder as second argument"
	exit 1
fi

for (( i=3; i<=$#; i++ ))
do
	arg_i=${@:$i:1}   # get argument i
	arg_j=${@:$i+1:1} # get argument i+1
	case $arg_i in
	-h|--help)
		usage
		exit 0
		;;
	-o)
		output_folder="$arg_j"
		;;
	--output=*)
		output_folder="${arg_i#*=}"
		;;
	*)
		echo "Unknown argument number $i: '$arg_i'"
		;;
	esac
done

echo "Recipient:         $recipient"
echo "Folder to encrypt: $folder"
echo "Output folder:     $output_folder"

#find $thunderbird_folder | while read line; do print_file $line; done
