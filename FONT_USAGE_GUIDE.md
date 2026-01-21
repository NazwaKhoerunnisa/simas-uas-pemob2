# Panduan Penggunaan Font Custom

## Konfigurasi Font yang Tersedia

Berikut adalah font-font yang telah dikonfigurasi di aplikasi:

| Elemen UI        | Font                             | Berat         |
| ---------------- | -------------------------------- | ------------- |
| App Title / Logo | **Cairo**                        | Bold (700)    |
| Section Heading  | **Poppins**                      | SemiBold (600)|
| Body Text        | **Poppins** / Nunito             | Regular (400) |
| Buttons          | **Poppins**                      | Medium (500)  |
| Cards / Labels   | **Nunito**                       | Medium (500)  |

---

## Cara Menggunakan

### 1. Menggunakan AppTextStyles (Recommended)

Import di file Dart:
```dart
import 'package:uas_pemob2_simas/presentation/theme/app_text_styles.dart';
```

Contoh penggunaan:

```dart
// App Title
Text('Masjid SIMAS', style: AppTextStyles.appTitle)

// Section Heading
Text('Keuangan', style: AppTextStyles.sectionHeading)

// Body Text
Text('Detail laporan keuangan', style: AppTextStyles.bodyTextMedium)

// Button Text
Text('Unduh', style: AppTextStyles.buttonTextMedium)

// Card Label
Text('Total Pemasukan', style: AppTextStyles.cardLabel)
Text('Rp 5.000.000', style: AppTextStyles.cardValue)
```

### 2. Menggunakan Theme Text Styles

Flutter Theme juga sudah dikonfigurasi otomatis:

```dart
Text('Heading', style: Theme.of(context).textTheme.headlineSmall)
Text('Body', style: Theme.of(context).textTheme.bodyMedium)
```

### 3. Custom Font Families Langsung

Jika ingin menggunakan font secara langsung:

```dart
TextStyle(
  fontFamily: 'Cairo',
  fontSize: 24,
  fontWeight: FontWeight.bold,
)

TextStyle(
  fontFamily: 'Poppins',
  fontSize: 16,
  fontWeight: FontWeight.w600,
)

TextStyle(
  fontFamily: 'Nunito',
  fontSize: 14,
  fontWeight: FontWeight.w500,
)
```

---

## Font File yang Diperlukan

Pastikan file font berikut ada di folder `assets/fonts/`:

### Cairo
- `Cairo-Bold.ttf` (weight: 700)
- `Cairo-Regular.ttf` (weight: 400)

### Poppins
- `Poppins-Regular.ttf` (weight: 400)
- `Poppins-Medium.ttf` (weight: 500)
- `Poppins-SemiBold.ttf` (weight: 600)
- `Poppins-Bold.ttf` (weight: 700)

### Nunito
- `Nunito-Regular.ttf` (weight: 400)
- `Nunito-Medium.ttf` (weight: 500)

---

## Catatan Penting

1. **Font Files**: Pastikan semua file TTF sudah di-download dan ditempatkan di `assets/fonts/`
2. **Hot Reload**: Setelah menambah font file baru, restart app (bukan hot reload)
3. **Case Sensitive**: Nama font file harus sesuai dengan konfigurasi di `pubspec.yaml`
4. **Performance**: Gunakan font yang tepat sesuai kebutuhan untuk performa optimal

---

## Contoh Implementasi Lengkap

```dart
import 'package:flutter/material.dart';
import 'package:uas_pemob2_simas/presentation/theme/app_text_styles.dart';

class ExamplePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Laporan', style: AppTextStyles.appTitle),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading
            Text('Ringkasan Keuangan', style: AppTextStyles.sectionHeading),
            SizedBox(height: 16),
            
            // Card dengan label dan value
            Card(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  children: [
                    Text('Total Pemasukan', style: AppTextStyles.cardLabel),
                    SizedBox(height: 4),
                    Text('Rp 10.000.000', style: AppTextStyles.cardValue),
                  ],
                ),
              ),
            ),
            
            // Body text
            SizedBox(height: 16),
            Text(
              'Ini adalah teks deskripsi yang menggunakan Poppins Regular.',
              style: AppTextStyles.bodyTextMedium,
            ),
            
            // Button
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              child: Text('Unduh Laporan', style: AppTextStyles.buttonTextMedium),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## Dukungan Perubahan Font

Jika ingin mengubah font atau size, edit file:
- `lib/presentation/theme/app_text_styles.dart` - untuk custom styles
- `lib/presentation/theme/app_theme.dart` - untuk theme defaults
