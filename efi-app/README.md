# SVSM EFI App

Rust uefi doc: https://docs.rs/uefi/latest/uefi/index.html

uefi-rs Book: https://rust-osdev.github.io/uefi-rs/introduction.html

On using std: https://rust-osdev.github.io/uefi-rs/how_to/rust-std.html

## Building
```
cargo build --target x86_64-unknown-uefi
```

## Testing

Run the app in Qemu using the system-provided OVMF build:

```
../run-app.sh target/x86_64-unknown-uefi/debug/efi-app.efi
```
