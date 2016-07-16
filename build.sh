#!/bin/bash
rm .version
# Bash Color
green='\033[01;32m'
red='\033[01;31m'
cyan='\033[01;36m'
blue='\033[01;34m'
blink_red='\033[05;31m'
restore='\033[0m'

clear

# Resources
THREAD="-j$(grep -c ^processor /proc/cpuinfo)"
DEFCONFIG="cyanogenmod_corsica_defconfig"
KERNEL="Image"

#Hyper Kernel Details
BASE_VER="Hyper"
VER="-aio-$(date +"%Y-%m-%d"-%H%M)-"
Hyper_VER="$BASE_VER$VER$TC"

# Vars
export ARCH=arm
export SUBARCH=arm
export KBUILD_BUILD_USER=Karthick111
export KBUILD_BUILD_HOST=server1
export LOCALVERSION="-Hyper™-v1"

# Paths
KERNEL_DIR=`pwd`
RESOURCE_DIR="/home/android/kernel/corsica"
ANYKERNEL_DIR="$RESOURCE_DIR/hyper"
TOOLCHAIN_DIR="/home/android/kernel/tc"
REPACK_DIR="$ANYKERNEL_DIR"
PATCH_DIR="$ANYKERNEL_DIR/patch"
WLAN_DIR="$KERNEL_DIR/drivers/net/wireless/bcmdhd"
MODULES_DIR="$ANYKERNEL_DIR/modules"
ZIP_MOVE="$RESOURCE_DIR/kernel_out"
ZIMAGE_DIR="$KERNEL_DIR/arch/arm/boot"

# Functions
function make_kernel {
		make $DEFCONFIG $THREAD
		make $KERNEL $THREAD
		cp -vr $ZIMAGE_DIR/$KERNEL $REPACK_DIR/zImage
}

function make_modules {
		cd $KERNEL_DIR
		make modules $THREAD
                cd $WLAN_DIR
                cp -vr dhd.ko $MODULES_DIR
                cd $KERNEL_DIR
}

function make_zip {
		cd $REPACK_DIR
                zip -r `echo $Hyper_VER$TC`.zip *
		mv  `echo $Hyper_VER$TC`.zip $ZIP_MOVE
		cd $KERNEL_DIR
}

DATE_START=$(date +"%s")


echo -e "${green}"
echo "--------------------------------------------------------"
echo "Wellcome !!!   Initiatig To Compile $Hyper_VER    "
echo "--------------------------------------------------------"
echo -e "${restore}"

echo -e "${cyan}"
while read -p "Plese Select Desired Toolchain for compiling Hyper Kernel

SABERMOD-4.7---->(1)

LINARO-4.7---->(2)


" echoice
do
case "$echoice" in
	1 )
		export CROSS_COMPILE=$TOOLCHAIN_DIR/saber-4.7/bin/arm-eabi-
		export LD_LIBRARY_PATH=$TOOLCHAIN_DIR/saber-4.7/lib/
		TC="SM"
		rm -rf $MODULES_DIR/*
		rm -rf $ZIP_MOVE/*
		cd $ANYKERNEL_DIR
		rm -rf zImage
                cd $KERNEL_DIR
		make clean && make mrproper
		echo "cleaned directory"
		echo "Compiling Hyper Kernel Using SABERMOD-4.7 Toolchain"
		break
		;;
	2 )
		export CROSS_COMPILE=$TOOLCHAIN_DIR/linaro-4.7/bin/arm-eabi-
		export LD_LIBRARY_PATH=$TOOLCHAIN_DIR/linaro-4.7/lib/
		TC="LN"
		rm -rf $MODULES_DIR/*
		rm -rf $ZIP_MOVE/*
		cd $ANYKERNEL_DIR
		rm -rf zImage
		cd $KERNEL_DIR
		make clean && make mrproper
		echo "cleaned directory"
		echo "Compiling Hyper Kernel Using UBERTC-4.9 Toolchain"
		break
		;;

	* )
		echo
		echo "Invalid Selection try again !!"
		echo
		;;
esac
done
echo -e "${restore}"

echo
while read -p "Do you want to start Building Hyper Kernel ?

Yes Or No ?

Enter Y for Yes Or N for No
" dchoice
do
case "$dchoice" in
	y|Y )
		make_kernel
		make_modules
		make_zip
		break
		;;
	n|N )
		break
		;;
	* )
		echo
		echo "Invalid Selection try again !!"
		echo
		;;
esac
done
echo -e "${green}"
echo $Hyper_VER$TC.zip
echo "------------------------------------------"
echo -e "${restore}"

DATE_END=$(date +"%s")
DIFF=$(($DATE_END - $DATE_START))
echo "Time: $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
echo " "
cd $ZIP_MOVE
ls
ftp uploads.androidfilehost.com
