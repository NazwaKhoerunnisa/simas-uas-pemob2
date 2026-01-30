import 'dart:io' as io;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart' as share_plus;
import '../models/keuangan_model.dart';

// ignore: avoid_web_libraries_in_flutter
import 'dart:html' if (dart.library.io) 'dart:io' as html;

class LaporanService {
  static Future<String> exportKeuanganCSV(List<Keuangan> data) async {
    try {
      double totalMasuk = 0;
      double totalKeluar = 0;

      final buffer = StringBuffer();

      buffer.writeln('LAPORAN KEUANGAN MASJID SIMAS');
      buffer.writeln('Tanggal Export: ${DateTime.now()}');
      buffer.writeln('');
      buffer.writeln('Tanggal,Tipe,Kategori,Nominal,Keterangan');

      for (var item in data) {
        final nominal = double.tryParse(item.nominal.toString()) ?? 0;

        if (item.tipe.toLowerCase() == 'pemasukan') {
          totalMasuk += nominal;
        } else {
          totalKeluar += nominal;
        }

        buffer.writeln(
          '${item.tanggal},${item.tipe},${item.kategori},${item.nominal},${item.keterangan}',
        );
      }

      final saldo = totalMasuk - totalKeluar;

      buffer.writeln('');
      buffer.writeln('TOTAL PEMASUKAN,,$totalMasuk');
      buffer.writeln('TOTAL PENGELUARAN,,$totalKeluar');
      buffer.writeln('SALDO,,$saldo');

      final csvContent = buffer.toString();
      final fileName =
          'laporan_keuangan_${DateTime.now().millisecondsSinceEpoch}.csv';

      if (kIsWeb) {
        // Untuk Web: Gunakan data URL
        _downloadFileWeb(csvContent, fileName);
        return 'Laporan berhasil diunduh: $fileName';
      } else {
        // Untuk Mobile/Desktop: Gunakan path_provider dan share
        final dir = await getApplicationDocumentsDirectory();
        final file = io.File('${dir.path}/$fileName');

        // Tulis file
        await file.writeAsString(csvContent);

        // Cek apakah file berhasil dibuat
        if (await file.exists()) {
          // Share file
          await share_plus.Share.shareXFiles(
            [share_plus.XFile(file.path)],
            text: 'Laporan Keuangan Masjid SIMAS',
            subject: 'Laporan Keuangan',
          );
          return 'Laporan berhasil dibuat: $fileName';
        } else {
          return 'Error: File tidak berhasil disimpan';
        }
      }
    } catch (e) {
      return 'Error: ${e.toString()}';
    }
  }

  static void _downloadFileWeb(String csvContent, String fileName) {
    try {
      final bytes = utf8.encode(csvContent);
      final base64Csv = base64Encode(bytes);
      final dataUrl = 'data:text/csv;charset=utf-8;base64,$base64Csv';

      // Gunakan pendekatan langsung dengan protokol data URL
      _createAndClickDownloadLink(dataUrl, fileName);
    } catch (e) {
      // ignore: avoid_print
      print('Download error: $e');
    }
  }

  static void _createAndClickDownloadLink(String dataUrl, String fileName) {
    // ignore: avoid_web_libraries_in_flutter
    // Menggunakan dart:html untuk web download
    try {
      // ignore: undefined_variable
      final anchorElement = html.document.createElement('a');
      // ignore: undefined_variable
      anchorElement.setAttribute('href', dataUrl);
      // ignore: undefined_variable
      anchorElement.setAttribute('download', fileName);
      // ignore: undefined_variable
      html.document.body?.append(anchorElement);
      // ignore: undefined_variable
      anchorElement.click();
      // ignore: undefined_variable
      anchorElement.remove();
    } catch (e) {
      // ignore: avoid_print
      print('Create download link error: $e');
    }
  }
}
