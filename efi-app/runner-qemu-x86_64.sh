#!/bin/bash -u

EXE="${1}"

FW_CODE=/usr/share/edk2/ovmf/OVMF_CODE.cc.fd
FW_VARS=/usr/share/edk2/ovmf/OVMF_VARS.fd

/usr/bin/qemu-system-x86_64 \
    -machine q35,accel=kvm:tcg \
    -cpu max \
    -smp 1 \
    -m 512 -boot menu=off \
    -blockdev node-name=code,driver=file,filename="${FW_CODE}",read-only=on \
    -blockdev node-name=vars,driver=file,filename="${FW_VARS}",read-only=on \
    -machine pflash0=code \
    -machine pflash1=vars \
    -chardev file,id=fw,path="firmware.log" \
    -device isa-debugcon,iobase=0x402,chardev=fw \
    -nic user,model=virtio-net-pci \
    -serial stdio \
    -monitor none \
    -nographic \
    -no-reboot \
    -kernel "${EXE}"
