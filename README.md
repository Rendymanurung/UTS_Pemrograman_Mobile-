# Anime Knowledge Quiz – Aplikasi Kuis Pilihan Ganda

---

## 👤 Identitas Mahasiswa

| | |
|---|---|
| **Nama** | [NAMA KAMU] |
| **NIM** | [NIM KAMU] |
| **Lab** | [NAMA LAB / KELAS KAMU] |

---

## 📱 Informasi Aplikasi

### Nama Aplikasi
**Anime Knowledge Quiz** – Kuis Pilihan Ganda

### Deskripsi Singkat
**Anime Knowledge Quiz** adalah aplikasi kuis pilihan ganda interaktif berbasis Flutter yang dirancang untuk menguji wawasan pengguna mengenai anime. Aplikasi ini dilengkapi dengan indikator *countdown timer* per soal (15 detik), petunjuk gambar (*visual clue*), feedback jawaban reaktif, serta statistik hasil kuis dan tingkat akurasi. Aplikasi mendukung desain adaptif/responsif untuk berbagai ukuran layar (mobile, tablet, dan web/desktop), mengusung bahasa desain *Spotify Design System*, dan mendukung *Dark Mode* & *Light Mode*.

### Fitur-Fitur yang Tersedia

#### Fitur Wajib
- **Input Identitas Peserta** — Pengguna mengisi nama peserta sebelum memulai kuis.
- **Kuis Pilihan Ganda** — Tersedia 5 soal pilihan ganda (A–D) bertema pengetahuan anime.
- **Countdown Timer per Soal** — Setiap soal diberi batas waktu 15 detik; jika waktu habis, soal dihitung otomatis tidak terjawab dan memperingatkan peserta.
- **Petunjuk Gambar (*Visual Clue*)** — Setiap soal dilengkapi petunjuk gambar pendukung.
- **Feedback Jawaban Reaktif** — Jawaban benar/salah langsung ditampilkan secara visual setelah opsi dipilih.
- **Hasil Akhir & Akurasi** — Menampilkan skor akhir, jumlah jawaban benar, salah, persentase akurasi, dan pesan apresiasi peserta.

#### Fitur Tambahan
- **Branding Logo Gotik "L"** — Elemen visual khas ikon Gotik "L" (Death Note) dengan *badge frame* kustom di halaman utama dan hasil kuis.
- **Dark Mode & Light Mode** — Toggle beralih tema terang/gelap yang dapat diakses di bagian *header* semua halaman.
- **Spotify Design System** — Penggunaan palet warna *Spotify Green* (`#1ED760`), latar *Near Black* (`#121212`), geometri *Full Pill*, dan tombol bergaya *system label uppercase*.
- **Responsif Multi-Platform** — Layout adaptif menggunakan `ResponsiveUtil` untuk tampilan smartphone, tablet, dan web/desktop.
- **Animasi Transisi & Feedback** — Animasi *fade* dan *slide* halus saat perpindahan soal dan perpindahan halaman.

---

## 📂 Struktur Proyek

```
lib/
├── models/
│   └── question_model.dart     # Model data soal, opsi jawaban, & path gambar
├── providers/
│   ├── quiz_provider.dart      # State management kuis, skor, & countdown timer (15s)
│   ├── theme_provider.dart     # State management tema (Dark / Light mode)
│   └── user_provider.dart      # State management nama peserta
├── screens/
│   ├── start_screen.dart       # Halaman awal (input nama & tombol mulai)
│   ├── quiz_screen.dart        # Halaman kuis, timer, petunjuk gambar & opsi jawaban
│   └── result_screen.dart      # Halaman hasil kuis, statistik akurasi, & skor
├── theme/
│   └── app_theme.dart          # Kumpulan tema & palet warna Spotify Design System
├── utils/
│   └── responsive_util.dart    # Helper responsivitas layar (mobile, tablet, desktop)
├── widgets/
│   ├── custom_button.dart      # Tombol reusable (Spotify Full Pill Button)
│   ├── custom_text_field.dart  # Field input nama peserta dengan animasi fokus
│   ├── gothic_l_badge.dart     # Badge frame logo Gotik "L"
│   └── option_card.dart        # Kartu pilihan jawaban kuis (A-D)
└── main.dart                   # Entry point aplikasi & MultiProvider setup
```

---

## 🚀 Cara Menjalankan Aplikasi

### Prasyarat
- Flutter SDK `^3.0.0` (atau versi terbaru)
- Dart SDK yang sesuai
- Emulator Android / iOS, browser Chrome, atau Windows desktop

### Langkah-Langkah

```bash
# 1. Clone repository
git clone [LINK_REPOSITORY_GITHUB_KAMU]
cd uts_rendy

# 2. Install dependencies
flutter pub get

# 3. Jalankan di emulator mobile
flutter run

# 4. Jalankan di browser (web)
flutter run -d chrome

# 5. Jalankan di Windows desktop
flutter run -d windows
```

---

## 🖼️ Screenshot Aplikasi

### Halaman Awal (Start Screen)
<img src="[LINK_SCREENSHOT_START_SCREEN]" width="300" alt="Start Screen"/>

### Halaman Kuis (Quiz Screen)
<img src="[LINK_SCREENSHOT_QUIZ_SCREEN]" width="300" alt="Quiz Screen"/>

### Halaman Hasil Kuis (Result Screen)
<img src="[LINK_SCREENSHOT_RESULT_SCREEN]" width="300" alt="Result Screen"/>

### Mode Gelap (Dark Mode)
<img src="[LINK_SCREENSHOT_DARK_MODE]" width="300" alt="Dark Mode"/>

---

## 🎨 Dokumentasi

### Credit Aset
| Aset | Sumber |
|---|---|
| Ikon & Logo Gotik "L" (`l_logo.png`) | Logo Gotik "L" (Death Note) |
| Font **Poppins** | [Google Fonts](https://fonts.google.com/specimen/Poppins) – SIL Open Font License |
| Material Symbols / Icons | [Material Symbols](https://fonts.google.com/icons) – Apache License 2.0 |
| Framework & Library | [Flutter](https://flutter.dev) & [Provider](https://pub.dev/packages/provider) |

### Link Prototype / Demo
> [[LINK CANVA PROTOTYPE APLIKASI (OPSIONAL)]](https://canva.com)

### Link Video Presentasi
> [[LINK GDRIVE VIDEO PRESENTASI]](https://drive.google.com)

---

## 🔄 Alur Kerja Aplikasi

```
Halaman Awal (Start Screen)
    ├── Isi Nama Peserta
    ├── Pilih Tema (Dark / Light Mode)
    └── Tap "Mulai Kuis Sekarang"
            └──► Halaman Kuis (Quiz Screen)
                    ├── Countdown Timer 15 Detik per Soal
                    ├── Petunjuk Gambar Visual
                    ├── Pilih Jawaban (A, B, C, D) ──► Feedback Langsung
                    └── Tap "Lanjut Soal Berikutnya"
                            └──► Halaman Hasil (Result Screen)
                                    ├── Lihat Total Skor & Persentase Akurasi
                                    └── Tap "Main Lagi" ──► Kembali ke Halaman Awal
```

---

## 🧰 Teknologi yang Digunakan

| Teknologi | Keterangan |
|---|---|
| **Flutter** | Framework UI cross-platform |
| **Dart** | Bahasa pemrograman utama |
| **Provider** | State management untuk kuis, pengguna, dan tema |
| **Spotify Design System** | Bahasa desain UI (Spotify Green `#1ED760` & Near Black `#121212`) |
| **MediaQuery / ResponsiveUtil** | Deteksi ukuran layar untuk responsivitas adaptif |

---

*UTS Pemrograman Mobile – Fasilkom-TI USU*
