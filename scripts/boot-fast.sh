#!/bin/bash
# AYSRAF PM - boot script
# Usage: boot-fast.sh [path-to-file]
#   - path bisa .qcow2 (disk) atau .iso (installer/live)
#   - tanpa argumen: gunakan DISK dari config (harus ada di ~/win-qemu/disks/)

CONFIG="$HOME/.winqemu.conf"
. "$CONFIG" 2>/dev/null || { RAM=2560; CPU_CORES=4; DISK="win10-auto.qcow2"; }

VM_DIR="$HOME/win-qemu"
DISKS_DIR="$VM_DIR/disks"

# Tentukan file yang mau di-boot
BOOT_FILE="$1"
if [ -z "$BOOT_FILE" ]; then
    BOOT_FILE="$DISKS_DIR/$DISK"
fi

[ ! -f "$BOOT_FILE" ] && echo "File tidak ditemukan: $BOOT_FILE" && exit 1

# Deteksi tipe: ISO (installer/live) vs qcow2 (disk)
EXT="${BOOT_FILE##*.}"
IS_ISO=0
[ "$EXT" = "iso" ] && IS_ISO=1

for s in monitor.sock qmp.sock; do rm -f "$VM_DIR/$s"; done

# --- Argumen dasar QEMU (gabung jadi satu string, tanpa array bash) ---
ARGS="-accel tcg,thread=multi,tb-size=4096"
ARGS="$ARGS -machine q35,hpet=off,smm=off"
ARGS="$ARGS -cpu Nehalem"
ARGS="$ARGS -smp cpus=$CPU_CORES,sockets=1,cores=$CPU_CORES,threads=1"
ARGS="$ARGS -m $RAM"
ARGS="$ARGS -device ich9-ahci,id=ahci"
ARGS="$ARGS -device ich9-ahci,id=ahci2"
ARGS="$ARGS -drive file=fat:rw:$VM_DIR/transfer,format=raw,if=none,id=unis"
ARGS="$ARGS -device ide-hd,bus=ahci2.0,drive=unis"
ARGS="$ARGS -device virtio-net-pci,netdev=net0"
ARGS="$ARGS -netdev user,id=net0,ipv6=off"
ARGS="$ARGS -vga std"
ARGS="$ARGS -display vnc=127.0.0.1:1"
ARGS="$ARGS -monitor unix:$VM_DIR/monitor.sock,server=on,wait=off"
ARGS="$ARGS -qmp unix:$VM_DIR/qmp.sock,server=on,wait=off"
ARGS="$ARGS -rtc base=localtime,clock=host"
ARGS="$ARGS -device usb-ehci,id=usb"
ARGS="$ARGS -device usb-tablet"

if [ "$IS_ISO" = "1" ]; then
    # Boot dari ISO (installer / live). Mount sebagai CD-ROM.
    ARGS="$ARGS -drive file=$BOOT_FILE,if=none,id=cd0,format=raw,media=cdrom,readonly=on"
    ARGS="$ARGS -device ide-cd,bus=ahci.0,drive=cd0"
    # Jika argumen ke-2 diberikan = disk target kosong untuk install OS.
    # Pasang sebagai drive kedua biar installer bisa menulis ke sana.
    TARGET="$2"
    if [ -n "$TARGET" ] && [ -f "$TARGET" ]; then
        ARGS="$ARGS -drive file=$TARGET,if=none,id=disk0,format=qcow2,cache=writeback,discard=unmap"
        ARGS="$ARGS -device ide-hd,bus=ahci.2,drive=disk0"
    fi
else
    # Boot dari disk .qcow2
    ARGS="$ARGS -drive file=$BOOT_FILE,if=none,id=disk0,format=qcow2,cache=writeback,discard=unmap"
    ARGS="$ARGS -device ide-hd,bus=ahci.0,drive=disk0"
fi

# Jalankan QEMU di background
qemu-system-x86_64 $ARGS -pidfile "$VM_DIR/qemu.pid" &
