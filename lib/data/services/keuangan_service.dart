import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/keuangan_model.dart';

class KeuanganService {
  static const String baseUrl = 'https://695d0f2c79f2f34749d6d76c.mockapi.io/keuangan';

  // GET semua data
  Future<List<Keuangan>> fetchAll() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        
        final result = data.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          
          // Jika tidak ada ID, gunakan index sebagai ID
          if (item['id'] == null || item['id'].toString().isEmpty) {
            item['id'] = (index + 1).toString();
          }
          
          return Keuangan.fromJson(item);
        }).toList();
        
        return result;
      } else {
        throw Exception('Gagal load data keuangan: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching keuangan: $e');
    }
  }

  // POST tambah
  Future<void> create(Keuangan keuangan) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(keuangan.toJson()),
      );
      
      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Exception('Gagal tambah keuangan: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating keuangan: $e');
    }
  }

  // PUT/PATCH edit
  Future<void> update(Keuangan keuangan) async {
    try {
      print('===== UPDATING KEUANGAN =====');
      print('ID: ${keuangan.id}');
      print('URL: $baseUrl/${keuangan.id}');
      
      final body = {
        'tanggal': keuangan.tanggal.trim(),
        'tipe': keuangan.tipe.trim(),
        'kategori': keuangan.kategori.trim(),
        'nominal': keuangan.nominal.trim(),
        'keterangan': keuangan.keterangan.trim(),
      };
      
      print('Request body: $body');
      
      // Gunakan PUT (PATCH tidak di-support CORS di MockAPI)
      final response = await http.put(
        Uri.parse('$baseUrl/${keuangan.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        // Verify dengan fetch ulang data
        print('Update successful, fetching data to verify...');
        final updatedData = await fetchAll();
        print('Total items after update: ${updatedData.length}');
        if (updatedData.isNotEmpty) {
          final updated = updatedData.firstWhere(
            (item) => item.id == keuangan.id,
            orElse: () => updatedData.first,
          );
          print('Updated item: ID=${updated.id}, Kategori=${updated.kategori}');
        }
      }
      
      print('===========================');
      
      if (response.statusCode != 200) {
        throw Exception('Gagal update keuangan: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Exception: $e');
      throw Exception('Error updating keuangan: $e');
    }
  }

  // DELETE hapus
  Future<void> delete(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      
      if (response.statusCode != 200) {
        throw Exception('Gagal delete keuangan: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error deleting keuangan: $e');
    }
  }
}
