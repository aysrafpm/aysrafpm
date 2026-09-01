#!/bin/bash
# AYSRAF PM - boot script
# Usage: boot-fast.sh [path-to-file]
#   - path bisa .qcow2 (disk) atau .iso (installer/live)
#   - tanpa argumen: gunakan DISK dari config (harus ada di ~/win-qemu/disks/)

CONFIG="$HOME/.winqemu.conf"
source "$CONFIG" 2>/dev/null || { RAM=2560; CPU_CORES=4; DISK="win10-auto.qcow2"; }

VM_DIR="$HOME/win-qemu"
DISKS_DIR="$VM_DIR/disks"
ISOS_DIR="$VM_DIR/isos"

# Tentukan file yang mau di-boot
BOOT_FILE="$1"
if [ -z "$BOOT_FILE" ]; then
    BOOT_FILE="$DISKS_DIR/$DISK"
fi

[ ! -f "$BOOT_FILE" ] && echo "❌ File tidak ditemukan: $BOOT_FILE" && exit 1

# Deteksi tipe: ISO (installer/live) vs qcow2 (disk)
EXT="${BOOT_FILE##*.}"
IS_ISO=0
[ "$EXT" = "iso" ] && IS_ISO=1

for s in monitor.sock qmp.sock; do rm -f "$VM_DIR/$s"; done

QEMU_ARGS=(qemu-system-x86_64 \
  -accel tcg,thread=multi,tb-size=4096 \
  -machine q35,hpet=off,smm=off \
  -cpu Nehalem \
  -smp cpus="$CPU_CORES,sockets=1,cores=$CPU_CORES,threads=1" \
  -m "$RAM" \
  -device ich9-ahci,id=ahci \
  -device ich9-ahci,id=ahci2 \
  -drive file=fat:rw:"$VM_DIR/transfer",format=raw,if=none,id=unis \
  -device ide-hd,bus=ahci2.0,drive=unis \
  -device virtio-net-pci,netdev=net0 \
  -netdev user,id=net0,ipv6=off \
  -vga qxl \
  -display vnc=127.0.0.1:1 \
  -monitor unix:"$VM_DIR/monitor.sock",server=on,wait=off \
  -qmp unix:"$VM_DIR/qmp.sock",server=on,wait=off \
  -rtc base=localtime,clock=host \
  -device usb-ehci,id=usb \
  -device usb-tablet \
  -pidfile "$VM_DIR/qemu.pid")

if [ "$IS_ISO" = "1" ]; then
    # Boot dari ISO (installer / live). Mount ISO sebagai CD-ROM.
    QEMU_ARGS+=(
      -drive file="$BOOT_FILE",if=none,id=cd0,format=raw,media=cdrom,readonly=on
      -device ide-cd,bus=ahci.0,drive=cd0
    )
else
    # Boot dari disk .qcow2
    QEMU_ARGS+=(
      -drive file="$BOOT_FILE",if=none,id=disk0,format=qcow2,cache=writeback,discard=unmap
      -device ide-hd,bus=ahci.0,drive=disk0
    )
fi

exec "${QEMU_ARGS[@]}" &
