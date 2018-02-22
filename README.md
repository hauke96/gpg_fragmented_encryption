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
by using the command `sh gpg_fragmented_encryption.sh foo@bar.org ./test` into this fragmented encrypted folder:
```
./test_gpgfe/
├── a.txt
├── folder
│   ├── b.txt.gpg
│   └── c.txt.gpg
└── another_folder
    └── d.txt.gpg
```

## Decrypt
By using the command `sh gpg_fragmented_encryption.sh foo@bar.org ./test_gpgfe --decrypt --output=test` the content will be decrypted into the folder `.test` and looks like the original above.

## All options

`sh gpg_fragmented_encryption.sh recipient input [options...]`

Arguments:

|argument|description|
|-|-|
|recipient | The key-ID or mail adress of the one which should encrypt the folder (normally just you) |
| input    | Folder with files. This is used for de- and encryption |

Options:

|option|description|
|-|-|
| -h<br>--help | Prints a useful help message |
| -o<br>--output | Specify output folder. Default: `./output_gpgfe/` |
| -d<br>--decrypt | Decrypts the given input folder and puts the decrypted files into the output folder. Not specifying this option will encrypt instead of decrypt |

For bugs, feature requests or questions: [mail( )hauke-stieler.de](mailto:mail@hauke-stieler.de)
