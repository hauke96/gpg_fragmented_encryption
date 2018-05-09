# gpg_fragmented_encryption
A script encryption a folders content without packing it into one gpg-file.

# Usage
## Encrypt
This script turns the folder
```
./test/
├── a.txt
├── folder
│   ├── b.txt
│   └── c.txt
└── another_folder
    └── d.txt
```
by using the command `sh gpg_fragmented_encryption.sh --encrypt --recipient=foo@bar.org --input=./test` into this fragmented encrypted folder:
```
./output_gpgfe/
├── a.txt
├── folder
│   ├── b.txt.gpg
│   └── c.txt.gpg
└── another_folder
    └── d.txt.gpg
```
(The name `output_gpgfe` is the default name for the output folder.)

## Decrypt
By using the command `sh gpg_fragmented_encryption.sh --decrypt --input=./output_gpgfe --output=test` the content will be decrypted into the folder `.test` and looks like the original above.

## All options

`sh gpg_fragmented_encryption.sh [options...]`

Options:

|option|description|
|-|-|
| -h<br>--help | Prints a useful help message |
| -e<br>--encrypt | Encrypt the given input folder and puts the encrypted files into the output folder. This command requires a specified `recipient` (s. below). |
| -d<br>--decrypt | Decrypts the given input folder and puts the decrypted files into the output folder |
| -r<br>--recipient | The key-ID or mail adress of the one which should encrypt the folder (normally just you) |
| -i<br>--input    | Folder with files. This is used for de- and encryption |
| -o<br>--output | Specify output folder. The default is `./output_gpgfe/` |

# For developer
## Understand the code
The code uses basic bash and unix commands.

Understanding all the string operations an parsing, the [tldp page about string manipulation](https://www.tldp.org/LDP/abs/html/string-manipulation.html) helped me a lot.

## Contribute
For bugs, feature requests or questions: [mail( )hauke-stieler.de](mailto:mail@hauke-stieler.de)

