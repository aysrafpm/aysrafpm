#!/bin/bash
set -e

PREFIX_DIR="${PREFIX:-/data/data/com.termux/files/usr}"
SHARE_DIR="$PREFIX_DIR/share/winqemu"
BIN_DIR="$PREFIX_DIR/bin"

echo "[1/7] Mengaktifkan akses penyimpanan..."
termux-setup-storage >/dev/null 2>&1 || true
echo "  (Izinkan akses penyimpanan jika ada popup)"

echo "[2/7] Memasang dependensi..."
pkg update -y
pkg install -y qemu-system-x86_64 dialog python tesseract \
  python-pillow tigervnc bc procps

echo "[3/7] Menginstal AYSRAF PM..."
mkdir -p "$SHARE_DIR/scripts" "$SHARE_DIR/docs" \
  ~/win-qemu/disks ~/win-qemu/isos ~/win-qemu/transfer
echo "  Folder disk dibuat: ~/win-qemu/disks/  (letakkan .qcow2 di sini)"

cp scripts/* "$SHARE_DIR/scripts/"
cp docs/* "$SHARE_DIR/docs/" 2>/dev/null || true
cp menu "$SHARE_DIR/menu"
chmod +x "$SHARE_DIR/menu" "$SHARE_DIR/scripts/"*

echo "[4/7] Membuat launcher..."
mkdir -p "$BIN_DIR"
cat > "$BIN_DIR/winqemu" << EOF
#!/bin/bash
cd "$SHARE_DIR"
./menu
EOF
chmod +x "$BIN_DIR/winqemu"

echo "[5/7] Menyiapkan lingkungan..."
# Default config if not exists
CONFIG="$HOME/.winqemu.conf"
if [ ! -f "$CONFIG" ]; then
cat > "$CONFIG" << 'CONF'
RAM=2560
CPU_CORES=4
DISK="win10-auto.qcow2"
CONF
fi

echo "[6/7] Menguji QEMU..."
if qemu-system-x86_64 --version >/dev/null 2>&1; then
    echo "✅ QEMU terpasang: $(qemu-system-x86_64 --version | head -1)"
else
    echo "❌ QEMU tidak ditemukan. Periksa instalasi Termux."
    exit 1
fi

echo "[7/7] Instalasi selesai!"
echo ""
echo "Jalankan 'winqemu' untuk membuka menu."
echo "Letakkan file disk Windows (.qcow2) di ~/win-qemu/disks/ (atau gunakan menu 'Import dari Download')."
