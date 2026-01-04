# 📱 SIMAS

### Sistem Informasi Manajemen Masjid

## 📌 Deskripsi Proyek

Aplikasi **SIMAS (Sistem Informasi Manajemen Masjid)** merupakan aplikasi mobile dan web berbasis **Flutter** yang bertujuan untuk membantu pengurus masjid dalam mengelola kegiatan, data donatur, dan informasi internal masjid secara digital. Aplikasi ini dikembangkan sebagai **Tugas Besar Individu UAS Pemrograman Mobile 2**.

Aplikasi bersifat **hybrid**, yaitu satu basis kode Flutter yang dapat dijalankan pada **Android (APK)** dan **Web (PWA)**. Sistem menggunakan **REST API (MockAPI)** sebagai backend data dan **Firebase Authentication** untuk manajemen pengguna.

Studi kasus diambil dari kondisi nyata pengelolaan kegiatan masjid yang masih dilakukan secara manual sehingga kurang efisien.

---

## 🎯 Tujuan Proyek

* Menerapkan konsep **Mobile Hybrid Development** menggunakan Flutter
* Mengimplementasikan **REST API** untuk pengelolaan data
* Menggunakan **Firebase Authentication** untuk login dan registrasi
* Mendeploy aplikasi ke **Web (PWA) menggunakan Netlify**
* Menghasilkan file **APK Android** yang dapat diinstal
* Menerapkan **animasi dan transisi halaman** pada aplikasi

---

## 🛠️ Teknologi yang Digunakan

* **Flutter** (Framework utama)
* **Dart** (Bahasa pemrograman)
* **Firebase Authentication** (Login & Register)
* **MockAPI** (REST API Backend)
* **HTTP Package** (Koneksi API)
* **Netlify** (Deploy PWA)
* **Android SDK** (Build APK)

---

## 🔐 Fitur Aplikasi

### 🔑 Autentikasi

* Login pengguna
* Registrasi pengguna
* Logout

### 📊 Manajemen Data (CRUD)

* Kelola Agenda Kegiatan Masjid
* Tambah, edit, hapus, dan lihat detail agenda

### 📱 Halaman Aplikasi (Dinamis)

1. Halaman Login
2. Halaman Register
3. Dashboard
4. Daftar Agenda Kegiatan
5. Detail Agenda
6. Tambah Agenda
7. Edit Agenda

> Catatan: Halaman statis seperti *Tentang Aplikasi* tidak dihitung sebagai halaman dinamis.

---

## 🌐 Arsitektur Sistem

* **Frontend**: Flutter (Mobile & Web)
* **Backend**: REST API (MockAPI)
* **Authentication**: Firebase Auth

---

## 🎨 Animasi & Transisi

Aplikasi menerapkan animasi dan transisi antar halaman menggunakan:

* AnimatedContainer
* PageRouteBuilder
* Hero Animation (opsional)

---

## 🚀 Deployment

* **Web (PWA)**: Netlify
* **Mobile**: Android APK

---

## 📂 Struktur Folder (Gambaran Umum)

```
lib/
├── main.dart
├── screens/
│   ├── login_page.dart
│   ├── register_page.dart
│   ├── dashboard_page.dart
│   ├── agenda_list_page.dart
│   ├── agenda_detail_page.dart
│   ├── agenda_add_page.dart
│   └── agenda_edit_page.dart
├── models/
├── services/
├── widgets/
```

---

## 📌 Catatan Pengembangan

* Proyek ini dikembangkan secara **individual**
* Data API menggunakan **MockAPI** untuk kebutuhan pembelajaran
* Aplikasi difokuskan pada fungsi manajemen internal, bukan aplikasi publik

---

## 👤 Pengembang

**Nama**: Nazwa Khoerunnisa

**NIM** : 23552011093

**Kelas** : TIF RP 23 CNS C

**Mata Kuliah**: Pemrograman Mobile 2

**Tahun**: 2025

---

## 📎 Repository GitHub

> Repository ini dibuat sebagai pemenuhan tugas progres UAS Pemrograman Mobile 2.
