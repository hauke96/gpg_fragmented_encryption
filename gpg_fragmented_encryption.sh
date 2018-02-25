#!/bin/bash

set -e

# Default settings
recipient=
folder=
output_folder=output_gpgfe

# Internal variables
prog=${0##*/}
encrypt_mode=

function usage(){
	cat <<END_USAGE
Encrypts or decrypts all the files in a folder with GnuPG.

Usage: $prog [options...]

Options:
    -h, --help       Prints this help message
    -e, --encrypt    Encrypt the given input folder and puts the encrypted
                     files into the output folder. This command requires a
                     specified recipient (s. below).
    -d, --decrypt    Decrypts the given input folder and puts the decrypted
                     files into the output folder.
    -r, --recipient  The key-ID or mail adress of the one which should encrypt
                     the folder (normally just you)
    -i, --input      Folder with files. This is used for de- and encryption
    -o, --output     Specify output folder. The default is ./output_gpgfe

Usage of short Options: '-o value'
Usage of long Options : '--option=value'

For bugs, feature requests or questions: mail@hauke-stieler.de
END_USAGE
}

# Arguments:
#    $1 - Filename to encrypt
function encrypt(){
	input_file="$@"
	output_file="$output_folder/${input_file#*$folder}.gpg"

	# actually the output-file without the file
	# e.g.: /test/foo/bar.txt if the file, then /test/foo is the sub-folder
	output_sub_folder="${output_file%/*}"

	echo $output_file
	echo $input_file

	mkdir -p "$output_sub_folder"
	gpg --output "$output_file" --encrypt --recipient $recipient "$input_file" >/dev/null
}

# Arguments:
#    $1 - Filename to decrypt
function decrypt(){
	input_file="$@"
	file_without_gpg_ending=${input_file%.*}
	output_file="$output_folder/${file_without_gpg_ending#*/}"

	# actually the output-file without the file
	# e.g.: /test/foo/bar.txt if the file, then /test/foo is the sub-folder
	output_sub_folder=${output_file%/*}

	echo $output_file

	mkdir -p "$output_sub_folder"
	gpg --batch --output "$output_file" --decrypt "$input_file" >/dev/null
}

for (( i=1; i<=$#; i++ ))
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
		shift
		;;
	--output=*)
		output_folder=${output_folder#*./}
		output_folder=${arg_i#*=}
		;;
	-r)
		recipient=${arg_j#*./}
		shift
		;;
	--recipient=*)
		recipient=${recipient#*./}
		recipient=${arg_i#*=}
		;;
	-i)
		folder=${arg_j#*./}
		shift
		;;
	--input=*)
		folder=${folder#*./}
		folder=${arg_i#*=}
		;;
	-d|--decrypt)
		encrypt_mode=decrypt
		;;
	-e|--encrypt)
		encrypt_mode=encrypt
		;;
	*)
		echo "Unknown argument number $i: '$arg_i'"
		;;
	esac
done

if [ -z $encrypt_mode ]
then
	cat <<END_USAGE
Please specify endryption mode:

	-e, --encrypt    Encrypt the given input folder and puts the encrypted
					 files into the output folder. This command requires a
					 specified recipient (s. below).
	-d, --decrypt    Decrypts the given input folder and puts the decrypted
					 files into the output folder.

Use '-h' or '--help' for more information.
END_USAGE
exit 1
fi

echo "Recipient:         $recipient"
if [ $encrypt_mode == "encrypt" ]
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

	if [ $encrypt_mode == "encrypt" ]
	then
		find $folder -type f | while read line; do encrypt $line; done
	else
		find $folder -type f | while read line; do decrypt $line; done
	fi
else
	echo "Nothing as been done so far."
fi
