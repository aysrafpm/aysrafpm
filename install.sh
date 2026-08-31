#!/bin/bash
set -e

PREFIX_DIR="${PREFIX:-/data/data/com.termux/files/usr}"
SHARE_DIR="$PREFIX_DIR/share/winqemu"
BIN_DIR="$PREFIX_DIR/bin"

echo "[1/6] Checking dependencies..."
pkg update -y
pkg install -y qemu-system-x86_64 dialog python tesseract

echo "[2/6] Installing AYSRAF PM..."
mkdir -p "$SHARE_DIR/scripts" "$SHARE_DIR/docs" \
  ~/win-qemu/disks ~/win-qemu/isos ~/win-qemu/transfer
echo "  Folder disk dibuat: ~/win-qemu/disks/  (letakkan .qcow2 di sini)"

cp scripts/* "$SHARE_DIR/scripts/"
cp docs/* "$SHARE_DIR/docs/" 2>/dev/null || true
cp menu "$SHARE_DIR/menu"
chmod +x "$SHARE_DIR/menu" "$SHARE_DIR/scripts/"*

echo "[3/6] Creating launcher..."
cat > "$BIN_DIR/winqemu" << EOF
#!/bin/bash
cd "$SHARE_DIR"
./menu
EOF
chmod +x "$BIN_DIR/winqemu"

echo "[4/6] Setting up environment..."
# Default config if not exists
CONFIG="$HOME/.winqemu.conf"
if [ ! -f "$CONFIG" ]; then
cat > "$CONFIG" << 'CONF'
RAM=2560
CPU_CORES=4
DISK="win10-auto.qcow2"
CONF
fi

echo "[5/6] Testing QEMU..."
if qemu-system-x86_64 --version >/dev/null 2>&1; then
    echo "✅ QEMU installed: $(qemu-system-x86_64 --version | head -1)"
else
    echo "❌ QEMU not found. Check your Termux installation."
    exit 1
fi

echo "[6/6] Installation complete!"
echo ""
echo "Run 'winqemu' to start."
echo "Place your Windows disk image in ~/win-qemu/disks/"
