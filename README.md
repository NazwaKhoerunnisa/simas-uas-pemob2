# 📱 SIMAS - Sistem Informasi Masjid

**SIMAS** adalah aplikasi mobile berbasis Flutter untuk mengelola data dan kegiatan masjid secara terintegrasi. Aplikasi ini dirancang untuk memudahkan pengelolaan agenda, keuangan, qurban, donasi, ramadhan, dan jadwal shalat dengan fitur autentikasi Firebase.

## 👤 Developer

- **Nama**: Nazwa Khoerunnisa
- **NIM**: 23552011093
- **Kelas**: TIF RP 23 CNS A
- **Mata Kuliah**: Pemrograman Mobile 2
- **Tahun**: 2025

---

## 📱 Tentang Aplikasi

### ✨ Fitur Utama

- **🗓️ Manajemen Agenda**: Buat, edit, dan kelola agenda kegiatan masjid
- **💰 Manajemen Keuangan**: Kelola pemasukan dan pengeluaran masjid
- **🐑 Manajemen Qurban**: Kelola data dan proses qurban
- **🤝 Manajemen Donasi**: Terima dan kelola donasi dari jemaah
- **📅 Manajemen Ramadhan**: Kelola agenda khusus bulan Ramadhan
- **⏰ Jadwal Shalat**: Tampilkan jadwal shalat terintegrasi
- **🔐 Autentikasi Firebase**: Sistem login aman menggunakan Firebase Authentication
- **📱 Responsive Design**: Aplikasi yang beradaptasi dengan berbagai ukuran layar

---

## 🛠️ Tech Stack

- **Frontend**: Flutter 3.9.2
- **Backend**: Firebase (Authentication, Firestore Database)
- **State Management**: Provider + Riverpod
- **UI Framework**: Material Design
- **Additional Libraries**:
  - `google_fonts`: Custom fonts untuk UI yang modern
  - `intl`: Internationalization & Localization
  - `image_picker`: Image selection dari device
  - `http`: HTTP requests ke backend
  - `shared_preferences`: Local storage untuk data lokal
  - `url_launcher`: Open URLs & emails
  - `path_provider`: File system access

---

## 📋 Persyaratan Sistem

- **Flutter SDK**: `^3.9.2`
- **Dart SDK**: Included with Flutter
- **Android API Level**: 21+
- **iOS**: 11.0+

---

## 🔐 Autentikasi

Aplikasi menggunakan **Firebase Authentication** untuk keamanan user:
- ✅ Login dengan email/password
- ✅ Registrasi user baru
- ✅ Manajemen session
- ✅ Logout
- ✅ Password reset

---

## 💾 Database

Menggunakan **Firebase Firestore** untuk penyimpanan data:
- 📊 Menyimpan data agenda
- 💵 Menyimpan data keuangan
- 🐑 Menyimpan data qurban
- 💝 Menyimpan data donasi
- 📅 Menyimpan data ramadhan
- 🕌 Menyimpan profil masjid

---

## 🎨 Tema & Desain

Aplikasi menggunakan **Material Design** dengan tema yang disesuaikan untuk suasana masjid yang profesional dan elegan:

- **Font**: Google Fonts untuk UI yang modern
- **Color Scheme**: Kombinasi warna yang mencerminkan spiritual namun profesional
- **Animasi**: Smooth transitions & animated widgets untuk UX yang baik

---

## � Dokumentasi Lengkap

Berikut adalah tampilan dari aplikasi SIMAS:

### Authentication Pages

| Splash Screen | Login | Register |
|:---:|:---:|:---:|
| ![Splash](docs/screenshots/splashscreen.jpg) | ![Login](docs/screenshots/login.jpg) | ![Register](docs/screenshots/register.jpg) |

### Dashboard

| Dashboard |
|:---:|
| ![Dashboard](docs/screenshots/dashboard.jpg) |

### Manajemen Agenda

| List Agenda | Detail Agenda | Add Agenda | Update Agenda |
|:---:|:---:|:---:|:---:|
| ![List Agenda](docs/screenshots/list%20agenda.jpg) | ![Detail Agenda](docs/screenshots/detail%20agenda.jpg) | ![Add Agenda](docs/screenshots/add%20agenda.jpg) | ![Update Agenda](docs/screenshots/updte%20agenda.jpg) |

### Manajemen Keuangan

| Keuangan Masjid | Add Keuangan | Update Keuangan | Download Laporan |
|:---:|:---:|:---:|:---:|
| ![Keuangan](docs/screenshots/keuangan%20masjid.jpg) | ![Add Keuangan](docs/screenshots/add%20keuangan.jpg) | ![Update Keuangan](docs/screenshots/update%20keuangan.jpg) | ![Download Laporan](docs/screenshots/unduh%20laoran%20keuangan.jpg) |

### Manajemen Qurban

| Program Qurban | Detail Qurban | Add Qurban | Fitur Zakat Mal |
|:---:|:---:|:---:|:---:|
| ![Program Qurban](docs/screenshots/program%20qurban.jpg) | ![Detail Qurban](docs/screenshots/detail%20qurban.jpg) | ![Add Qurban](docs/screenshots/add%20qurban.jpg) | ![Fitur Zakat Mal](docs/screenshots/fitur%20zakat%20mal.jpg) |

### Manajemen Donasi & Zakat

| Program Donasi | Detail Donasi | Add Donasi | Edit/Delete Donasi |
|:---:|:---:|:---:|:---:|
| ![Program Donasi](docs/screenshots/proramdonasi.jpg) | ![Detail Donasi](docs/screenshots/detail%20donasi.jpg) | ![Add Donasi](docs/screenshots/add%20donasi.jpg) | ![Edit Donasi](docs/screenshots/edit%20delete%20donasi.jpg) |

| Add Zakat Fitrah | Add Zakat Mal |
|:---:|:---:|
| ![Add Zakat Fitrah](docs/screenshots/Add%20zakat%20fitrah.jpg) | ![Add Zakat Mal](docs/screenshots/add%20zakat%20mal.jpg) |

### Manajemen Ramadhan & Jadwal

| Program Ramadhan | List Imsak & Buka | Add Jadwal Imsak/Buka | Jadwal Takjil |
|:---:|:---:|:---:|:---:|
| ![Program Ramadhan](docs/screenshots/proramdonasi.jpg) | ![List Imsak](docs/screenshots/list%20imsak&buka.jpg) | ![Add Imsak](docs/screenshots/add%20jadwal%20imsak&buka.jpg) | ![Jadwal Takjil](docs/screenshots/jadwal%20takjil.jpg) |

| Add Jadwal Takjil | Jadwal Shalat | Edit Profil |
|:---:|:---:|:---:|
| ![Add Takjil](docs/screenshots/add%20jadwal%20takjil.jpg) | ![Jadwal Shalat](docs/screenshots/jadwal%20shalat.jpg) | ![Edit Profil](docs/screenshots/edit%20profil.jpg) |

---

## 🎥 Video Demo

Tonton demo walkthrough aplikasi SIMAS di YouTube:

[![SIMAS Demo Video](https://img.youtube.com/vi/fSj1RshMoY8/maxresdefault.jpg)](https://youtu.be/fSj1RshMoY8)

**[▶️ Tonton Video Demo di YouTube](https://youtu.be/fSj1RshMoY8)**

---

## 🌐 Akses Aplikasi

**Aplikasi Live**: https://simas16.netlify.app/

---

**Status**: ✅ Development Complete | 🎯 Ready for Production | 📱 Multi-Platform Support

