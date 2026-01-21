import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_spacing.dart';
import '../data/models/masjid_profile_model.dart';
import '../data/services/masjid_profile_service.dart';

class EditMasjidProfilePage extends StatefulWidget {
  final MasjidProfile profile;
  final VoidCallback? onSuccess;

  const EditMasjidProfilePage({
    super.key,
    required this.profile,
    this.onSuccess,
  });

  @override
  State<EditMasjidProfilePage> createState() => _EditMasjidProfilePageState();
}

class _EditMasjidProfilePageState extends State<EditMasjidProfilePage> {
  late TextEditingController _namaController;
  late TextEditingController _deskripsiController;
  late TextEditingController _alamatController;
  late TextEditingController _mapsController;

  final _service = MasjidProfileService();
  final _imagePicker = ImagePicker();
  String? _selectedImagePath;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _namaController = TextEditingController(text: widget.profile.nama);
    _deskripsiController = TextEditingController(text: widget.profile.deskripsi);
    _alamatController = TextEditingController(text: widget.profile.alamat);
    _mapsController = TextEditingController(text: widget.profile.mapsUrl);
  }

  @override
  void dispose() {
    _namaController.dispose();
    _deskripsiController.dispose();
    _alamatController.dispose();
    _mapsController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImagePath = pickedFile.path;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (_namaController.text.isEmpty || _alamatController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama dan alamat harus diisi')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final updatedProfile = MasjidProfile(
        nama: _namaController.text,
        deskripsi: _deskripsiController.text,
        alamat: _alamatController.text,
        fotoUrl: _selectedImagePath ?? widget.profile.fotoUrl,
        fotoAssetPath: widget.profile.fotoAssetPath,
        mapsUrl: _mapsController.text,
      );

      await _service.updateMasjidProfile(updatedProfile);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil masjid berhasil diperbarui')),
      );

      widget.onSuccess?.call();
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil Masjid'),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photo Section
              const Text(
                'Foto Masjid',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    border: Border.all(
                      color: Colors.grey[300]!,
                      width: 2,
                    ),
                  ),
                  child: widget.profile.fotoAssetPath != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                          child: Image.asset(
                            widget.profile.fotoAssetPath!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                _buildPhotoPlaceholder(),
                          ),
                        )
                      : widget.profile.fotoUrl != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                              child: Image.network(
                                widget.profile.fotoUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    _buildPhotoPlaceholder(),
                              ),
                            )
                          : _buildPhotoPlaceholder(),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Nama Masjid
              const Text(
                'Nama Masjid',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: _namaController,
                decoration: InputDecoration(
                  hintText: 'Masukkan nama masjid',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Deskripsi
              const Text(
                'Deskripsi',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: _deskripsiController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'Masukkan deskripsi masjid',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Alamat
              const Text(
                'Alamat',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: _alamatController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'Masukkan alamat lengkap',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              // Google Maps URL
              const Text(
                'Google Maps URL',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextField(
                controller: _mapsController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'https://maps.app.goo.gl/...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Simpan Perubahan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoPlaceholder() {
    return Container(
      color: Colors.grey[100],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_outlined,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Tap untuk pilih foto',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
