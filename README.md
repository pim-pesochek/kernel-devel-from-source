# kernel-devel-from-source
Script install-kernel-devel.sh is used to make minimal installation required to compile linux kernel module out of tree.

To run this script you need first to compile linux kernel from sources, for example like this
```bash
make all
```
After this you can install minimal required files
```bash
./install-kernel-devel.sh path-to-kernel-source base-path-to-install-dir
```
This script takes two parameters
1. Path to kernel source code
2. Destination path where minimal required files will be placed

Example
```bash
./install-kernel-devel.sh ../kernel-5.10.15 /usr/src
```
This line will create directory linux-headers-5.10.15 under /usr/src and copy required files from kernel-5.10.15 directory
After that it will be possible to compile external module like this
```bash
make -C /lib/modules/5.10/build modules
```