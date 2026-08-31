#!/data/data/com.termux/files/usr/bin/sh
# scr.sh — tangkap layar jernih + OCR canggih
#   ./scr.sh            → ambil gambar dari VM + OCR penuh
#   ./scr.sh center     → fokus tengah (dialog/UAC)
#   ./scr.sh top        → fokus area judul jendela
#   ./scr.sh bottom     → fokus area bawah/taskbar
#   ./scr.sh -f FILE    → proses tangkapan yang sudah ada
cd /data/data/com.termux/files/home/win-emulator || exit 1
exec python3 scr.py "$@"