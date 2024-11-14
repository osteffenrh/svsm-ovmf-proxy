#!/bin/bash -e


pushd efi-app
cargo build --target x86_64-unknown-uefi
cp target/x86_64-unknown-uefi/debug/efi-app.efi ../
popd

cp ./efi-app.efi edk2/OvmfPkg/AmdSev/Grub/grub.efi 

pushd edk2
git submodule update --init --depth=1 --single-branch
make -C BaseTools -j$(nproc)
. ./edksetup.sh
build -a X64 -b DEBUG -t GCC5 -D DEBUG_ON_SERIAL_PORT -D DEBUG_VERBOSE -DTPM2_ENABLE -p OvmfPkg/OvmfPkgX64.dsc \
  -Y COMPILE_INFO -y BuildReport.log 2>&1 | tee Build.log
cp Build/OvmfX64/DEBUG_GCC5/FV/OVMF.fd ..
popd

pushd svsm
git submodule update --init
FW_FILE=../OVMF.fd make
cp bin/coconut-qemu.igvm ..
popd

#NOTE: AmdSevX64 build pulls in the efi file into the image and launches it on boot.
#      But it currenly does not work under SVSM. Need to check!
