import 'dart:convert';
import 'package:flutter/foundation.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' if (dart.library.io) 'dart:io' as html;

class DonasiLaporanService {
  static Future<String> exportDonasiCSV(List<dynamic> data) async {
    try {
      final buffer = StringBuffer();

      buffer.writeln('LAPORAN DONASI MASJID SIMAS');
      buffer.writeln('Tanggal Export: ${DateTime.now()}');
      buffer.writeln('');
      buffer.writeln('Tanggal,Tipe,Nama Jamaah,Nominal,Tujuan,Keterangan');

      double totalDonasi = 0;

      for (var item in data) {
        final nominal = double.tryParse(item.nominal.toString()) ?? 0;
        totalDonasi += nominal;

        buffer.writeln(
          '${item.tanggal},${item.tipe},${item.namaJamaah},${item.nominal},${item.tujuan},${item.keterangan ?? ''}',
        );
      }

      buffer.writeln('');
      buffer.writeln('TOTAL DONASI,,,,$totalDonasi');

      final csvContent = buffer.toString();
      final fileName =
          'laporan_donasi_${DateTime.now().millisecondsSinceEpoch}.csv';

      if (kIsWeb) {
        _downloadFileWeb(csvContent, fileName);
        return 'Laporan berhasil diunduh: $fileName';
      } else {
        return 'Laporan donasi siap diunduh';
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

      _createAndClickDownloadLink(dataUrl, fileName);
    } catch (e) {
      // ignore: avoid_print
      print('Download error: $e');
    }
  }

  static void _createAndClickDownloadLink(String dataUrl, String fileName) {
    try {
      // ignore: avoid_web_libraries_in_flutter
      // ignore: undefined_variable
      final anchorElement = html.document.createElement('a');
      // ignore: avoid_web_libraries_in_flutter
      // ignore: undefined_variable
      anchorElement.setAttribute('href', dataUrl);
      // ignore: avoid_web_libraries_in_flutter
      // ignore: undefined_variable
      anchorElement.setAttribute('download', fileName);
      // ignore: avoid_web_libraries_in_flutter
      // ignore: undefined_variable
      html.document.body?.append(anchorElement);
      // ignore: avoid_web_libraries_in_flutter
      // ignore: undefined_variable
      anchorElement.click();
      // ignore: avoid_web_libraries_in_flutter
      // ignore: undefined_variable
      anchorElement.remove();
    } catch (e) {
      // ignore: avoid_print
      print('Create download link error: $e');
    }
  }
}
