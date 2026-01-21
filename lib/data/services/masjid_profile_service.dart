import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/masjid_profile_model.dart';

class MasjidProfileService {
  static const String _key = 'masjid_profile';

  Future<MasjidProfile> getMasjidProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_key);

      if (jsonString != null) {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        return MasjidProfile.fromJson(json);
      }

      // Return default profile
      return MasjidProfile(
        nama: 'Masjid Jami Baitul Anshor',
        deskripsi: 'Sistem Informasi Manajemen Aset Masjid',
        alamat: 'Jl. Gading Tutuka 2, Jakarta',
        mapsUrl: 'https://maps.app.goo.gl/7gKdnbmiUNkNBdh18',
        fotoAssetPath: 'assets/images/masjid.jpg',
      );
    } catch (e) {
      // Return default on error
      return MasjidProfile(
        nama: 'Masjid Jami Baitul Anshor',
        deskripsi: 'Sistem Informasi Manajemen Aset Masjid',
        alamat: 'Jl. Gading Tutuka 2, Jakarta',
        mapsUrl: 'https://maps.app.goo.gl/7gKdnbmiUNkNBdh18',
        fotoAssetPath: 'assets/images/masjid.jpg',
      );
    }
  }

  Future<void> updateMasjidProfile(MasjidProfile profile) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = jsonEncode(profile.toJson());
      await prefs.setString(_key, json);
    } catch (e) {
      throw Exception('Gagal update profil masjid: $e');
    }
  }

  Future<void> resetToDefault() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_key);
    } catch (e) {
      throw Exception('Gagal reset profil: $e');
    }
  }
}
