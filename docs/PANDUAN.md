# 📖 Panduan Pengguna AYSRAF PM

Panduan lengkap memakai **AYSRAF PM** untuk menjalankan Windows / Linux di Android lewat qemu (Termux).

---

## Daftar Isi
1. [Persiapan](#-persiapan)
2. [Cara Install](#-cara-install)
3. [Cara Pakai Menu](#-cara-pakai-menu)
4. [Menaruh Disk Windows](#-menaruh-disk-windows)
5. [Mengatur Machine (RAM & CPU)](#-mengatur-machine)
6. [Memasang Linux](#-memasang-linux)
7. [Memecahkan Masalah (Troubleshooting)](#-memecahkan-masalah)
8. [Tips Agar Lancar](#-tips-agar-lancar)

---

## 📱 Persiapan

Pastikan HP kamu memenuhi ini:

| Kebutuhan | Keterangan |
|---|---|
| **HP Android ARM64** | Hampir semua HP modern (tahun 2018 ke atas) |
| **RAM minimal** | 4 GB (disarankan 6 GB+) |
| **Penyimpanan** | Sisakan minimal 5 GB untuk Windows |
| **Termux** | Pasang dari **F-Droid** (*bukan* Play Store — versi Play Store sudah usang) |
| **Termux:X11** | Untuk menampilkan layar Windows (dari F-Droid) |

> 🔎 **Kenapa F-Droid?** Versi Termux di Play Store sudah tidak diperbarui dan bermasalah. Gunakan [F-Droid](https://f-droid.org) untuk Termux & Termux:X11.

---

## 🚀 Cara Install

Buka **Termux**, lalu ketik perintah berikut satu per satu:

```bash
# 1. Beri izin akses penyimpanan (sekali saja)
termux-setup-storage
```
*(Klik "Izinkan/Allow" saat muncul popup)*

```bash
# 2. Perbarui Termux & pasang git
pkg update -y && pkg upgrade -y
pkg install -y git
```

```bash
# 3. Ambil proyek AYSRAF PM
git clone https://github.com/aysrafpm/aysrafpm
cd aysrafpm
```

```bash
# 4. Jalankan installer (otomatis pasang semua kebutuhan)
bash install.sh
```

```bash
# 5. Buka menu
winqemu
```

---

## 🎮 Cara Pakai Menu

Setelah mengetik `winqemu`, muncul menu:

```
AYSRAF PM v1.0
```

1. **1 - Start Windows** → menjalankan Windows (pilih disk, tunggu boot).
2. **2 - Import dari Download** → menyalin file disk dari folder Download.
3. **3 - Shutdown VM** → mematikan Windows dengan aman.
4. **4 - Machine (RAM & CPU)** → mengatur kekuatan yang dipakai Windows.
5. **5 - Tools** → screenshot + OCR & analisis warna.
6. **6 - Exit** → keluar dari menu (VM tetap berjalan).

> 💡 **Sebelum Start**, buka dulu app **Termux:X11** agar layar Windows muncul.

---

## 💿 Menaruh Disk Windows

Kamu **tidak perlu** membuka folder Termux. Cukup:

1. Buka folder **Download** di HP (Internal Storage → Download).
2. Taruh file **`.qcow2`** (Windows siap pakai) atau **`.iso`** (installer Windows).
3. Buka menu → **2 (Import dari Download)** → pilih filenya → tersalin otomatis.
4. Pilih **1 (Start Windows)** → pilih disk → boot.

> ⚠️ **Lisensi:** Pastikan kamu menggunakan Windows dengan lisensi yang sah sesuai ketentuan Microsoft. Proyek ini tidak menyertakan file sistem Windows.

---

## ⚙️ Mengatur Machine

Pilih **4 (Machine)** di menu — di sini kamu **memilih sistem operasi** yang mau dijalankan:

- **1 - 🪟 Preset Windows** — otomatis set RAM sesuai HP & 4 core. Cocok untuk Windows.
- **2 - 🐧 Preset Linux** — set RAM 1.5GB & 2 core (hemat, ringan). Cocok untuk Linux.
- **3 - Atur RAM manual** / **4 - Atur CPU manual** — sesuaikan sendiri sesuai kebutuhan.
- **5 - Ganti Disk** — pilih disk `.qcow2` yang mau dipakai (Windows **atau** Linux).

> 💡 Aturan mudah: **Windows** pakai RAM lebih besar; **Linux** cukup sedikit (pakai Preset Linux).

**Panduan RAM Windows** (bila atur manual):
- HP **4 GB** → 2 GB
- HP **6 GB** → 2,5 GB
- HP **8 GB** → 3 GB
- HP **12 GB+** → 3,5 – 4 GB

*Sisakan minimal ±2 GB RAM untuk HP itu sendiri.*

**CPU Cores** — makin banyak core, makin cepat tapi HP cepat panas:
- HP 8-core → 4–6 core
- HP 4-core → 2–4 core
- Disarankan **4**.

> Jika HP terasa lambat, kurangi RAM & core sedikit.

---

## 🐧 Memasang Linux

Selain Windows, AYSRAF PM juga bisa menjalankan **Linux** — dan Linux **jauh lebih ringan** daripada Windows, jadi lebih cocok untuk emulator di HP.

### Distro Linux yang disarankan
| Distro | RAM | Keterangan |
|---|---|---|
| **Lubuntu / Xubuntu** | 1–2 GB | Desktop ringan, mudah dipakai |
| **Debian (netinst)** | 512 MB | Stabil, fleksibel |
| **Alpine / AntiX / Puppy** | 256–512 MB | Ultra ringan, CLI/desktop minimal |

**Lubuntu** paling disarankan untuk pemula (ada desktop, ringan, gampang).

### Cara memasang
1. **Download ISO Linux** (mis. Lubuntu) → taruh di folder **Download** HP.
2. Buka menu → **2 (Import dari Download)** → pilih file `.iso` → menyalin otomatis.
3. Buka menu → **4 (Machine) → Preset Linux (hemat RAM)** — otomatis set RAM 1.5GB & 2 core (ringan untuk HP).
4. Buka menu → **1 (Start Windows)** → pilih ISO → boot installer Linux.
5. Ikuti instalasi Linux seperti biasa (butuh beberapa menit di emulator).
6. Setelah terinstal, hasilnya adalah disk `.qcow2` Linux yang bisa dipakai lewat menu seperti Windows.

> 💡 Untuk Linux, RAM yang besar tidak perlu — di menu Machine pilih **Preset Linux** supaya HP tidak panas dan emulator tetap halus.

---

## 🔧 Memecahkan Masalah

**Q: Boot Windows sangat lambat?**
A: Normal. Tanpa akselerasi hardware, qemu harus menerjemahkan semua instruksi. Boot pertama bisa 5–10 menit tergantung HP.

**Q: Layar tidak muncul di Termux:X11?**
A: Pastikan app **Termux:X11** sudah dibuka sebelum **Start**. Setelah boot, viewer tersambung otomatis.

**Q: Muncul "VM is already running"?**
A: Sudah ada Windows yang berjalan. Matikan dulu (menu → Shutdown, atau `pkill -9 qemu-system-x86_64`).

**Q: Bisa main game / TikTok / YouTube?**
A: Tidak disarankan. Emulasi lambat; streaming & game akan patah-patah. Cocok untuk aplikasi ringan / tugas PC-only.

**Q: HP cepat panas / boros baterai?**
A: Emulasi memang berat. Turunkan RAM & core di **Machine**, dan beri jeda.

---

## 💡 Tips Agar Lancar

- Tutup aplikasi lain sebelum menjalankan Windows (biar RAM kosong).
- Aktifkan **"Do Not Disturb"** biar tidak diganggu notifikasi.
- Colok charger saat boot panjang.
- Simpan disk di penyimpanan internal (bukan kartu SD) biar lebih cepat.

---

© 2026 AYSRAF PM. Berbagi dan memodifikasi dibolehkan.
