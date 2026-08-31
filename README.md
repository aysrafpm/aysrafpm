# 🖥️ AYSRAF PM — Windows di HP Android

Jalankan sistem operasi **Windows** di HP Android kamu menggunakan **QEMU** (via Termux). 
Dirancang untuk **ramah pemula**: pilih disk, atur RAM/CPU, dan boot — tanpa perlu ribet dengan folder Termux yang tersembunyi.

---

## ✨ Fitur

- ☑️ **Menu interaktif** (berbahasa Indonesia) — tidak perlu hafal perintah QEMU
- ☑️ **Import disk dari Download** — taruh file `.qcow2` / `.iso` di folder Download HP, menu menyalin otomatis
- ☑️ **Pengaturan Machine** — atur RAM & CPU sesuai kekuatan HP kamu
- ☑️ **Boot Windows** (juga bisa untuk **Linux**) dengan sekali tekan
- ☑️ **Preset Windows & Preset Linux** — pilih sistem operasi dengan sekali klik (RAM/CPU otomatis diatur)
- ☑️ **Shutdown** yang aman
- ☑️ **Tools** — screenshot + OCR, analisis warna layar
- ☑️ Folder otomatis dibuat — tidak bingung mencari lokasi
- 📖 Panduan pengguna lengkap: [docs/PANDUAN.md](docs/PANDUAN.md)

---

## 📋 Syarat (Requirements)

- HP **Android ARM64** (hampir semua HP modern)
- **Termux** terpasang (dari [F-Droid](https://f-droid.org/packages/com.termux/) — versi Play Store sudah usang)
- **Termux:X11** (untuk menampilkan layar Windows — dari F-Droid)
- RAM minimal **4GB** (disarankan 6GB+)
- File **disk Windows** (`.qcow2`) atau **ISO Windows** untuk install

---

## 🚀 Cara Install

Buka Termux, izinkan akses penyimpanan dulu (sekali saja):

```bash
termux-setup-storage
```
*(Klik "Izinkan/Allow" saat muncul popup)*

Kemudian:

```bash
pkg update -y && pkg upgrade -y
pkg install -y git
git clone https://github.com/aysrafpm/aysrafpm
cd aysrafpm
bash install.sh
```

Install selesai. Sekarang buka menu:

```bash
winqemu
```

---

## 🎮 Cara Pakai

1. **Buka app Termux:X11** terlebih dulu (agar layar Windows tampil).
2. Di menu, pilih **2 (Import dari Download)** untuk menyalin file disk dari Download.
3. Pilih **4 (Machine)** untuk mengatur RAM & CPU sesuai HP kamu.
4. Pilih **1 (Start Windows)** → pilih disk → tunggu boot → layar muncul di Termux:X11.
5. Selesai memakai, pilih **3 (Shutdown)**.

---

## 💿 Di Mana Menaruh Disk Windows?

Kamu **tidak perlu** membuka folder Termux.

1. Buka folder **Download** di HP kamu (Internal Storage → Download).
2. Taruh file **`.qcow2`** (hasil Windows siap pakai) atau **`.iso`** (installer Windows) di sana.
3. Buka menu AYSRAF PM → **2 (Import dari Download)** → pilih file → disalin otomatis.

> 💡 **Butuh disk Windows?** Kamu bisa membuatnya sendiri dengan menginstal Windows dari ISO di dalam emulator ini, atau memperoleh file `.qcow2` dari sumber yang kamu percayai. **Hormati lisensi Windows** — miliki lisensi yang sah sesuai ketentuan Microsoft.

---

## ⚙️ Pengaturan Machine

- **RAM Windows**: pilih sesuai HP-mu (HP 4GB → 2GB; HP 8GB → 3GB; HP 12GB+ → 4GB). Sisakan ±2GB RAM untuk HP.
- **CPU Cores**: lebih banyak core = Windows lebih lancar, tapi HP cepat panas. Disarankan **4**.
- Jika HP terasa lambat, **turunkan RAM & core** sedikit.

---

## ❓ FAQ

**Kenapa boot Windows lambat?**
Karena QEMU tidak memakai akselerasi hardware di Android. Emulasi butuh waktu. Boot pertama ±5-10 menit itu normal. Ini juga tergantung spesifikasi HP.

**Layar tidak muncul di Termux:X11?**
Pastikan app **Termux:X11** terbuka sebelum Start. Setelah boot, viewer otomatis menyambung.

**Apakah bisa main game berat / TikTok di dalamnya?**
Tidak disarankan. Emulasi lambat, game/streaming akan terasa berat (audio dan video patah-patah). Cocok untuk aplikasi ringan / tugas PC-only.

**HP-ku panas?**
Emulasi memang berat. Kurangi core & RAM di menu **Machine**, dan beri jeda jika terlalu panas.

---

## 📁 Struktur Proyek

```
aysrafpm/
├── README.md            ← dokumen ini
├── install.sh           ← installer otomatis
├── menu                 ← menu interaktif AYSRAF PM
└── scripts/
    ├── boot-fast.sh     ← script boot QEMU (config-driven)
    ├── scr.py / scr.sh  ← screenshot + OCR
    └── analyze.py       ← analisis warna layar
```

---

## 🧾 Catatan Penggunaan

Proyek ini menyediakan **antarmuka dan skrip** untuk menjalankan QEMU di Termux. 
**QEMU** berlisensi GPL. Sistem **Windows** adalah properti Microsoft — pastikan kamu menggunakan dengan lisensi yang sah. 
Proyek ini **tidak** menyertakan file sistem Windows.

---

© 2026 AYSRAF PM. Berbagi dan memodifikasi dibolehkan.
