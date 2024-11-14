# PoC of running the attestation proxy in the VM

This is a PoC of running the attestation proxy inside the SEV-SNP VM under Coconut SVSM.

The idea is to include an EFI app written in Rust (=the proxy) inside the OVMF build that
gets bundled into the coconut igvm file. The app is launched as the default boot option.

## How to build and run

Clone the repo, then update the submodules...

```
git clone https://github.com/osteffenrh/svsm-ovmf-proxy.git
cd svsm-ovmf-proxy
git submodule update --init
```

Ensure you have all build dependencies installed for Coconut SVSM and EDK2.
See the [Coconut SVSM documentation](https://github.com/coconut-svsm/svsm/blob/main/Documentation/docs/installation/INSTALL.md) for that too.

The EFI app uses the uefi-rs crate and the `x86_64-unknown-uefi` target.
That should get pulled in by cargo automatically.

Then simply run the build script `./build.sh` and wait.

It will produce
- `efi-app.efi`: The EFI app to launch when OVMF boots
- `OVMF.fd`: The OVMF build, including `efi-app.efi`
- `coconut-qemu.igvm`: Coconut SVSM including the above images

Launch the `coconut-qemu.igvm` as usual (see Coconut SVSM documentation for details).

You should see the EFI app start after SVSM has handed over to OVMF.

## Testing things

You can launch the OVMF build in a regular (no SNP) VM using the `runner-qemu-x86_64.sh` script:
```
./run-ovmf.sh OVMF.fd
```

To test the EFI app on its own, use `run-app.sh`:
```
./run-app.sh efi-app.efi
```

## ToDo

- [ ] Implement the attestation proxy inside the EFI app (and possibly rename it ;-)
- [ ] Add a communication channel between SVSM and the EFI app
- [ ] Find a way to return to SVSM after the app has finished. SVSM probably needs to clean up
-     page tables etc to allow OVMF to be launched a second time.
- [ ] Find a way to set the BootOrder on the second launch of OVMF in order to jump into the actual guest OS.
      (Maybe fw_cfg or something?)
- [ ] Maybe we need to avoid that the guest can launch the EFI app (by setting BootNext or launching
-     it directly from Grub for example).
