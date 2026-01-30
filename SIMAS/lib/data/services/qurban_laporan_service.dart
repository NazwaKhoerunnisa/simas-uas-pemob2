import 'dart:convert';
import 'package:flutter/foundation.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' if (dart.library.io) 'dart:io' as html;

class QurbanLaporanService {
  static Future<String> exportQurbanCSV(List<dynamic> data) async {
    try {
      final buffer = StringBuffer();

      buffer.writeln('LAPORAN QURBAN MASJID SIMAS');
      buffer.writeln('Tanggal Export: ${DateTime.now()}');
      buffer.writeln('');
      buffer.writeln('Tanggal,Jenis Hewan,Nama Jamaah,Jumlah,Kondisi,Status,Keterangan');

      int totalHewan = 0;

      for (var item in data) {
        final jumlah = (item.jumlah ?? 1) as int;
        totalHewan += jumlah;

        buffer.writeln(
          '${item.tanggalPendaftaran},${item.jenisHewan},${item.namaJamaah},${item.jumlah},${item.kondisi},${item.status},${item.keterangan ?? ''}',
        );
      }

      buffer.writeln('');
      buffer.writeln('TOTAL HEWAN,,,,$totalHewan');

      final csvContent = buffer.toString();
      final fileName =
          'laporan_qurban_${DateTime.now().millisecondsSinceEpoch}.csv';

      if (kIsWeb) {
        _downloadFileWeb(csvContent, fileName);
        return 'Laporan berhasil diunduh: $fileName';
      } else {
        return 'Laporan qurban siap diunduh';
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
