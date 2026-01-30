import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/agenda_model.dart';

class AgendaService {
  static const String baseUrl =
      'https://695be5ba1d8041d5eeb8e3ae.mockapi.io/agenda';

  Future<List<Agenda>> fetchAgenda() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((e) => Agenda.fromJson(e)).toList();
    } else {
      throw Exception('Gagal load agenda');
    }
  }

  Future<void> updateAgenda(
    String id,
    String judul,
    String tanggal,
    String deskripsi,
    {String? dokumentasiText, String? status}
  ) async {
    // Untuk Web dan Native, kirim sebagai JSON
    final body = {
      'judul': judul,
      'tanggal': tanggal,
      'deskripsi': deskripsi,
      'dokumentasi': dokumentasiText ?? '',
    };
    
    // Add status if provided
    if (status != null) {
      body['status'] = status;
    }
    
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal update agenda');
    }
  }

  Future<void> deleteAgenda(String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal hapus agenda');
    }
  }
}
