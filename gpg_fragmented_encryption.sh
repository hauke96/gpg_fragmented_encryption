#!/bin/bash

set -e

# Default settings
recipient=
input_folder=
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

	file_with_gpg_ending="${input_file#*$input_folder}.gpg"
	# remove leading / from path
	file_with_gpg_ending=${file_with_gpg_ending#/}

	output_file="$output_folder/$file_with_gpg_ending"

	# gets the path to the output_file
	# e.g.: /test/foo/bar.txt is the file, then /test/foo is the sub-folder
	output_sub_folder="${output_file%/*}"

	echo "in : $input_file"
	echo "out: $output_file"

	mkdir -p "$output_sub_folder"
	gpg --output "$output_file" --encrypt --recipient $recipient "$input_file" >/dev/null
}

# Arguments:
#    $1 - Filename to decrypt
function decrypt(){
	input_file="$@"
	prefix=${output_folder%/*}
	# remove .gpg ending
	file_without_gpg_ending=${input_file%.*}
	# remove input-folder name which is the prefix
	file_without_gpg_ending=${file_without_gpg_ending#$input_folder}
	# remove / from beginning
	file_without_gpg_ending=${file_without_gpg_ending#/}
	
	output_file="$output_folder/$file_without_gpg_ending"

	# actually the output-file without the file
	# e.g.: /test/foo/bar.txt if the file, then /test/foo is the sub-folder
	output_sub_folder=${output_file%/*}
	
	echo "in : $input_file"
	echo "out: $output_file"

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
		# split at = char and remove the shortest match from beginning
		output_folder=${arg_i#*=}
		# remove / at end (if none exists, nothing happens)
		output_folder=${output_folder%/}
		;;
	-r)
		recipient=${arg_j#*./}
		shift
		;;
	--recipient=*)
		recipient=${arg_i#*=}
		;;
	-i)
		input_folder=${arg_j#*./}
		# remove / at end (if none exists, nothing happens)
		input_folder=${input_folder%/}
		shift
		;;
	--input=*)
		input_folder=${arg_i#*=}
		# remove / at end (if none exists, nothing happens)
		input_folder=${input_folder%/}
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
	echo "Folder to encrypt: $input_folder"
else
	echo "Folder to decrypt: $input_folder"
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
		find $input_folder -type f | while read line; do encrypt $line; done
	else
		find $input_folder -type f | while read line; do decrypt $line; done
	fi
else
	echo "Nothing as been done so far."
fi
