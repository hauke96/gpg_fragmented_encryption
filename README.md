# gpg_fragmented_encryption
A script encryption a folders content without packing it into one gpg-file.

This script turn this folder
```
./test/
├── a.txt
├── folder
│   ├── b.txt
│   └── c.txt
├── another_folder
    └── d.txt
```
by using the command `sh gpg_fragmented_encryption.sh foo@bar.org ./test` into this fragmented encrypted folder:
```
./test_gpgfe/
├── a.txt
├── folder
│   ├── b.txt.gpg
│   └── c.txt.gpg
├── another_folder
    └── d.txt.gpg
```

# Usage

`sh gpg_fragmented_encryption.sh recipient input [options...]`

Arguments:

|argument|description|
|:-|-|
|recipient | The key-ID or mail adress of the one which should encrypt the folder (normally just you) |
| input    | The input folder which filed should be encrypted |

Options:

|option|description|
|:-|-|
| -h, --help | Prints a useful help message |
| -o, --output | Specify output folder. Default: `./output_gpgfe/` |

For bugs, feature requests or questions: [mail( )hauke-stieler.de](mailto:mail@hauke-stieler.de)
