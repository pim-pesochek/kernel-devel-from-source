#!/usr/bin/bash

set -x;

KERNEL_SOURCE=$1
INSTALL_BASE_PATH=$2
ARCH=$(uname -m | cut -d"_" -f1)
VERSION=$(cut -d" " -f3 $KERNEL_SOURCE/include/generated/utsrelease.h | tr -d '"')
INSTALL_DIR="$INSTALL_BASE_PATH/linux-headers-$VERSION"
LIB_DIR="/lib/modules/$VERSION"

echo "parsed linux kernel version: $VERSION"

recursive_copy() {
	set +x;
	pattern=$1
	base=$2
	search_dir=$3
	echo "Copy all $pattern files from $base/$search_dir"
	files=$(find $base/$search_dir -name $pattern)

	for f in $files
	do
		dir=$(dirname $f)
		rel_path=${dir#"$base/"}
		if [[ $rel_path == arch* ]]; then
			if ! [[ $rel_path == arch/$ARCH/* ]]; then
				continue
			fi
		fi

		mkdir -p $INSTALL_DIR/$rel_path
		cp $f $INSTALL_DIR/$rel_path/$(basename $f)
	done
	set -x;
}

mkdir -p $INSTALL_DIR
make -C $KERNEL_SOURCE modules_install
unlink $LIB_DIR/build
ln -s $INSTALL_DIR $LIB_DIR/build

cp $KERNEL_SOURCE/Makefile $INSTALL_DIR
cp -r $KERNEL_SOURCE/scripts $INSTALL_DIR
cp -r $KERNEL_SOURCE/tools $INSTALL_DIR
mkdir -p $INSTALL_DIR/arch/$ARCH
cp $KERNEL_SOURCE/arch/$ARCH/Makefile $INSTALL_DIR/arch/$ARCH/Makefile
cp $KERNEL_SOURCE/Module.symvers $INSTALL_DIR/Module.symvers
recursive_copy "*.h" $KERNEL_SOURCE "include"
recursive_copy "*.conf" $KERNEL_SOURCE "include/config"
recursive_copy "*.h" $KERNEL_SOURCE "arch/$ARCH/include"

set +x;
