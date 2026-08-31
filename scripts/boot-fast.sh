#!/bin/bash
CONFIG="$HOME/.winqemu.conf"
source "$CONFIG" 2>/dev/null || { RAM=2560; CPU_CORES=4; DISK="win10-auto.qcow2"; }

VM_DIR="$HOME/win-qemu"
DISK_PATH="$VM_DIR/disks/$DISK"

[ ! -f "$DISK_PATH" ] && echo "❌ Disk not found: $DISK_PATH" && exit 1

for s in monitor.sock qmp.sock; do rm -f "$VM_DIR/$s"; done

qemu-system-x86_64 \
  -accel tcg,thread=multi,tb-size=4096 \
  -machine q35,hpet=off,smm=off \
  -cpu Nehalem,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time,hv_stimer,hv_vpindex,hv_synic,hv_reset \
  -smp cpus=$CPU_CORES,sockets=1,cores=$CPU_CORES,threads=1 \
  -m $RAM \
  -drive file="$DISK_PATH",if=none,id=disk0,format=qcow2,cache=writeback,discard=unmap \
  -device ich9-ahci,id=ahci \
  -device ide-hd,bus=ahci.0,drive=disk0 \
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
  -pidfile "$VM_DIR/qemu.pid" &
