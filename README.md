<<<<<<< HEAD
# SIMAS - Sistem Informasi Masjid (Mobile App)

**SIMAS** adalah aplikasi mobile berbasis Flutter untuk mengelola data dan kegiatan masjid secara terintegrasi. Aplikasi ini dirancang untuk memudahkan pengelolaan agenda, keuangan, qurban, donasi, ramadhan, dan jadwal shalat.

## 📱 Tentang Aplikasi

SIMAS adalah Sistem Informasi Manajemen Masjid yang dibangun menggunakan Flutter dan terintegrasi dengan Firebase. Aplikasi ini menyediakan berbagai fitur untuk meningkatkan efisiensi pengelolaan masjid.

### ✨ Fitur Utama

- **🗓️ Manajemen Agenda**: Buat, edit, dan kelola agenda kegiatan masjid
- **💰 Manajemen Keuangan**: Kelola pemasukan dan pengeluaran masjid
- **🐑 Manajemen Qurban**: Kelola data dan proses qurban
- **🤝 Manajemen Donasi**: Terima dan kelola donasi dari jemaah
- **📅 Manajemen Ramadhan**: Kelola agenda khusus bulan Ramadhan
- **⏰ Jadwal Shalat**: Tampilkan jadwal shalat terintegrasi
- **🔐 Autentikasi Firebase**: Sistem login aman menggunakan Firebase Auth
- **📱 Responsive Design**: Aplikasi yang beradaptasi dengan berbagai ukuran layar

## 🛠️ Tech Stack

- **Frontend**: Flutter
- **Backend**: Firebase (Authentication, Firestore Database)
- **State Management**: Provider + Riverpod
- **UI Framework**: Material Design
- **Additional Libraries**:
  - `google_fonts`: Custom fonts
  - `intl`: Internationalization & Localization
  - `image_picker`: Image selection
  - `http`: HTTP requests
  - `shared_preferences`: Local storage
  - `url_launcher`: Open URLs & emails
  - `path_provider`: File system access

## 📋 Persyaratan Sistem

- Flutter SDK: `^3.9.2`
- Dart SDK: Included with Flutter
- Android API Level: 21+
- iOS: 11.0+

## 🚀 Cara Instalasi & Menjalankan

### 1. Clone Repository
```bash
git clone https://github.com/NazwaKhoerunnisa/simas-uas-pemob2.git
cd simas-uas-pemob2
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Setup Firebase (Optional jika belum dikonfigurasi)
```bash
flutterfire configure
```

### 4. Jalankan Aplikasi

**Di Android Emulator/Device:**
```bash
flutter run
```

**Di iOS Simulator/Device:**
```bash
flutter run -d macos
```

**Di Web:**
```bash
flutter run -d web
```

**Di Windows:**
```bash
flutter run -d windows
```

## 📁 Struktur Project

```
lib/
├── main.dart                 # Entry point aplikasi
├── screens/                  # Halaman aplikasi
│   ├── splash_page.dart
│   ├── login_page.dart
│   ├── register_page.dart
│   ├── dashboard_page.dart
│   ├── agenda_*.dart
│   ├── keuangan_*.dart
│   ├── qurban_*.dart
│   ├── donasi_*.dart
│   ├── ramadhan_*.dart
│   └── jadwal_shalat_page.dart
├── core/
│   ├── constants/            # App constants
│   └── utils/                # Utility functions
├── data/
│   ├── models/               # Data models
│   └── services/             # API & Firebase services
└── presentation/
    ├── pages/                # Complex pages
    ├── providers/            # State providers
    ├── theme/                # Theme configuration
    └── widgets/              # Reusable widgets
```

## 🔐 Autentikasi

Aplikasi menggunakan Firebase Authentication untuk:
- Login dengan email/password
- Registrasi user baru
- Manajemen session
- Logout

## 💾 Database

Menggunakan Firebase Firestore untuk:
# SIMAS - Sistem Informasi Masjid (Mobile App)

**SIMAS** adalah aplikasi mobile berbasis Flutter untuk mengelola data dan kegiatan masjid secara terintegrasi. Aplikasi ini dirancang untuk memudahkan pengelolaan agenda, keuangan, qurban, donasi, ramadhan, dan jadwal shalat.

## 📱 Tentang Aplikasi

SIMAS adalah Sistem Informasi Manajemen Masjid yang dibangun menggunakan Flutter dan terintegrasi dengan Firebase. Aplikasi ini menyediakan berbagai fitur untuk meningkatkan efisiensi pengelolaan masjid.

### ✨ Fitur Utama

- **🗓️ Manajemen Agenda**: Buat, edit, dan kelola agenda kegiatan masjid
- **💰 Manajemen Keuangan**: Kelola pemasukan dan pengeluaran masjid
- **🐑 Manajemen Qurban**: Kelola data dan proses qurban
- **🤝 Manajemen Donasi**: Terima dan kelola donasi dari jemaah
- **📅 Manajemen Ramadhan**: Kelola agenda khusus bulan Ramadhan
- **⏰ Jadwal Shalat**: Tampilkan jadwal shalat terintegrasi
- **🔐 Autentikasi Firebase**: Sistem login aman menggunakan Firebase Auth
- **📱 Responsive Design**: Aplikasi yang beradaptasi dengan berbagai ukuran layar

## 🛠️ Tech Stack

- **Frontend**: Flutter
- **Backend**: Firebase (Authentication, Firestore Database)
- **State Management**: Provider + Riverpod
- **UI Framework**: Material Design
- **Additional Libraries**:
  - `google_fonts`: Custom fonts
  - `intl`: Internationalization & Localization
  - `image_picker`: Image selection
  - `http`: HTTP requests
  - `shared_preferences`: Local storage
  - `url_launcher`: Open URLs & emails
  - `path_provider`: File system access

## 📋 Persyaratan Sistem

- Flutter SDK: `^3.9.2`
- Dart SDK: Included with Flutter
- Android API Level: 21+
- iOS: 11.0+

## 🚀 Cara Instalasi & Menjalankan

### 1. Clone Repository
```bash
git clone https://github.com/NazwaKhoerunnisa/simas-uas-pemob2.git
cd simas-uas-pemob2
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Setup Firebase (Optional jika belum dikonfigurasi)
```bash
flutterfire configure
```

### 4. Jalankan Aplikasi

**Di Android Emulator/Device:**
```bash
flutter run
```

**Di iOS Simulator/Device:**
```bash
flutter run -d macos
```

**Di Web:**
```bash
flutter run -d web
```

**Di Windows:**
```bash
flutter run -d windows
```

## 📁 Struktur Project

```
lib/
├── main.dart                 # Entry point aplikasi
├── screens/                  # Halaman aplikasi
│   ├── splash_page.dart
│   ├── login_page.dart
│   ├── register_page.dart
│   ├── dashboard_page.dart
│   ├── agenda_*.dart
│   ├── keuangan_*.dart
│   ├── qurban_*.dart
│   ├── donasi_*.dart
│   ├── ramadhan_*.dart
│   └── jadwal_shalat_page.dart
├── core/
│   ├── constants/            # App constants
│   └── utils/                # Utility functions
├── data/
│   ├── models/               # Data models
│   └── services/             # API & Firebase services
└── presentation/
    ├── pages/                # Complex pages
    ├── providers/            # State providers
    ├── theme/                # Theme configuration
    └── widgets/              # Reusable widgets
```

## 🔐 Autentikasi

Aplikasi menggunakan Firebase Authentication untuk:
- Login dengan email/password
- Registrasi user baru
- Manajemen session
- Logout

## 💾 Database

Menggunakan Firebase Firestore untuk:
- Menyimpan data agenda
- Menyimpan data keuangan
- Menyimpan data qurban
- Menyimpan data donasi
- Menyimpan data ramadhan

## 🎨 Tema & Desain

Aplikasi menggunakan Material Design dengan tema yang disesuaikan untuk suasana masjid yang profesional dan elegan.

- **Font**: Google Fonts untuk UI yang modern
- **Color Scheme**: Kombinasi warna yang mencerminkan spiritual namun profesional

## 📝 Lisensi

Project ini adalah bagian dari UAS Pemrograman Mobile II.

## 👨‍💻 Tentang Developer

- **Nama**: Nazwa Khoerunnisa
- **NIM** : 23552011093
- **Kelas** : TIF RP 23 CNS C
- **Mata Kuliah**: Pemrograman Mobile 2
- **Tahun**: 2025

## 📞 Hubungi Kami

Untuk pertanyaan atau saran, silakan hubungi melalui:
- GitHub Issues
- Email

## 📚 Dokumentasi Lengkap

Dokumentasi lengkap termasuk video tutorial dan screenshot akan ditambahkan di folder `docs/`.

### Struktur Dokumentasi:
```
docs/
├── videos/          # Video tutorial penggunaan
├── screenshots/     # Screenshot aplikasi
└── guides/          # Panduan penggunaan
```

---

## 📌 Catatan Pengembangan

* Proyek ini dikembangkan secara **individual**
* Data API menggunakan **MockAPI** untuk kebutuhan pembelajaran
* Aplikasi difokuskan pada fungsi manajemen internal, bukan aplikasi publik

---

## 📎 Repository GitHub

Repository ini dibuat sebagai pemenuhan tugas progres UAS Pemrograman Mobile 2.

