#!/bin/bash
set -e

PREFIX_DIR="${PREFIX:-/data/data/com.termux/files/usr}"
SHARE_DIR="$PREFIX_DIR/share/winqemu"
BIN_DIR="$PREFIX_DIR/bin"

echo "[1/8] Mengaktifkan akses penyimpanan..."
termux-setup-storage >/dev/null 2>&1 || true
echo "  (Izinkan akses penyimpanan jika ada popup)"

echo "[2/8] Menambahkan repository yang dibutuhkan..."
# qemu-system-x86_64 & tigervnc ada di repo x11-repo
pkg install -y x11-repo >/dev/null 2>&1 || true
pkg update -y

echo "[3/8] Memasang dependensi..."
pkg install -y qemu-system-x86_64 dialog python tesseract \
  python-pillow tigervnc bc procps

echo "[4/8] Menginstal AYSRAF PM..."
mkdir -p "$SHARE_DIR/scripts" "$SHARE_DIR/docs" \
  ~/win-qemu/disks ~/win-qemu/isos ~/win-qemu/transfer
echo "  Folder disk dibuat: ~/win-qemu/disks/  (letakkan .qcow2 di sini)"

cp scripts/* "$SHARE_DIR/scripts/"
cp docs/* "$SHARE_DIR/docs/" 2>/dev/null || true
cp menu "$SHARE_DIR/menu"
chmod +x "$SHARE_DIR/menu" "$SHARE_DIR/scripts/"*

echo "[5/8] Membuat launcher..."
mkdir -p "$BIN_DIR"
cat > "$BIN_DIR/winqemu" << EOF
#!/bin/bash
cd "$SHARE_DIR"
./menu
EOF
chmod +x "$BIN_DIR/winqemu"

echo "[6/8] Menyiapkan lingkungan..."
# Default config if not exists
CONFIG="$HOME/.winqemu.conf"
if [ ! -f "$CONFIG" ]; then
cat > "$CONFIG" << 'CONF'
RAM=2560
CPU_CORES=4
DISK="win10-auto.qcow2"
CONF
fi

echo "[7/8] Menguji QEMU..."
if qemu-system-x86_64 --version >/dev/null 2>&1; then
    echo "✅ QEMU terpasang: $(qemu-system-x86_64 --version | head -1)"
else
    echo "❌ QEMU tidak ditemukan. Periksa instalasi Termux."
    exit 1
fi

echo "[8/8] Instalasi selesai!"
echo ""
echo "Jalankan 'winqemu' untuk membuka menu."
echo "Letakkan file disk Windows (.qcow2) di ~/win-qemu/disks/ (atau gunakan menu 'Import dari Download')."
