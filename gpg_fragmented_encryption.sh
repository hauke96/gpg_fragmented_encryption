#!/bin/bash

set -e

# Default settings
recipient=
folder=
output_folder=output_gpgfe

# Internal variables
prog=${0##*/}
encrypt_mode=true

function usage(){
	cat <<END_USAGE
Encrypts or decrypts all the files in a folder with GnuPG.

Usage: $prog recipient input [options...]

Arguments:
    recipient       The key-ID or mail adress of the one which should encrypt
                    the folder (normally just you)
    input           Folder with files. This is used for de- and encryption

Options:
    -h, --help      Prints this help message
    -o, --output    Specify output folder
                    default: ./output_gpgfe
    -d, --decrypt   Decrypts the given input folder and puts the decrypted
                    files into the output folder. Not specifying this option
                    will encrypt instead of decrypt

For bugs, feature requests or questions: mail@hauke-stieler.de
END_USAGE
}

# When only the "-h" or "--help" given or it's the first argument, print help
# message
if [ $1 == "-h" ] || [ $1 == "--help" ]
then
	usage
	exit 0
fi

# Arguments:
#    $1 - Filename to encrypt
function encrypt(){
	output_file="$output_folder/${1#*/}.gpg"

	# actually the output-file without the file
	# e.g.: /test/foo/bar.txt if the file, then /test/foo is the sub-folder
	output_sub_folder=${output_file%/*}

	echo $output_file

	mkdir -p $output_sub_folder
	gpg --output $output_file --encrypt --recipient $recipient $1 2>/dev/null 1>/dev/null
}

# Arguments:
#    $1 - Filename to decrypt
function decrypt(){
	file_without_gpg_ending=${1%.*}
	output_file="$output_folder/${file_without_gpg_ending#*/}"

	# actually the output-file without the file
	# e.g.: /test/foo/bar.txt if the file, then /test/foo is the sub-folder
	output_sub_folder=${output_file%/*}

	echo $output_file

	mkdir -p $output_sub_folder
	gpg --batch --output $output_file --decrypt $1 2>/dev/null 1>/dev/null
}

# Check if recipient is provided
recipient=$1
if [ -z $recipient ]
then
	echo "Provide a recipient as first argument"
	exit 1
fi

# Check if folder is provided
folder=${2#*./}
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
		output_folder=${arg_j#*./}
		;;
	--output=*)
		output_folder=${arg_i#*=}
		output_folder=${output_folder#*./}
		;;
	-d|--decrypt)
		encrypt_mode=false
		;;
	*)
		echo "Unknown argument number $i: '$arg_i'"
		;;
	esac
done

echo "Recipient:         $recipient"
if [ $encrypt_mode = true ]
then
	echo "Folder to encrypt: $folder"
else
	echo "Folder to decrypt: $folder"
fi
echo "Output folder:     $output_folder"
echo ""
echo "If the output folder already exists, the application will abort"
echo ""
echo "Do you want to proceed? [y/n]"
read -n 1 -s ok # read just one char and don't echo it on the screen

if [ $ok == "y" ]
then
	mkdir $output_folder

	if [ $encrypt_mode = true ]
	then
		find $folder -type f | while read line; do encrypt $line; done
	else
		find $folder -type f | while read line; do decrypt $line; done
	fi
else
	echo "Nothing as been done so far."
fi
