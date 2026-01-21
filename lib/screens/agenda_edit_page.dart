import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import '../data/models/agenda_model.dart';
import '../data/services/agenda_service.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_spacing.dart';

class AgendaEditPage extends StatefulWidget {
  final Agenda agenda;

  const AgendaEditPage({super.key, required this.agenda});

  @override
  State<AgendaEditPage> createState() => _AgendaEditPageState();
}

class _AgendaEditPageState extends State<AgendaEditPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController judulController;
  late TextEditingController tanggalController;
  late TextEditingController deskripsiController;
  late TextEditingController dokumentasiController;

  late String _status;
  bool isLoading = false;
  XFile? _pickedDokumentasi;
  final ImagePicker _imagePicker = ImagePicker();
  
  // Auto-save variables
  bool _hasChanges = false;
  bool _isAutoSaving = false;
  late Agenda _lastSavedAgenda;

  @override
  void initState() {
    super.initState();
    judulController = TextEditingController(text: widget.agenda.judul);
    tanggalController = TextEditingController(text: widget.agenda.tanggal);
    deskripsiController = TextEditingController(text: widget.agenda.deskripsi);
    dokumentasiController = TextEditingController(text: widget.agenda.dokumentasi ?? '');
    _status = widget.agenda.status;
    
    // Store last saved agenda
    _lastSavedAgenda = widget.agenda;
    
    // Add listeners for changes
    judulController.addListener(_onContentChanged);
    tanggalController.addListener(_onContentChanged);
    deskripsiController.addListener(_onContentChanged);
    dokumentasiController.addListener(_onContentChanged);
  }

  void _onContentChanged() {
    if (mounted) {
      setState(() {
        _hasChanges = true;
      });
      // Auto-save after 1.5 seconds of last edit
      _autoSaveWithDelay();
    }
  }

  Timer? _autoSaveTimer;

  // Iteratif compress image untuk reduce ukuran base64 hingga acceptable
  Future<String?> _compressImageIteratively(XFile imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      
      // Decode image
      final image = img.decodeImage(bytes);
      if (image == null) {
        throw Exception('Gagal decode image');
      }

      // Iteratif compress dengan quality berkurang sampai ukuran acceptable
      List<int> compressedBytes = bytes;
      double quality = 85.0;
      int width = image.width;
      int height = image.height;

      // Max size: 90KB untuk base64
      final maxSize = 90000;

      while (quality > 30.0) {
        // Resize agresif saat quality sudah turun
        img.Image resized = image;
        if (width > 600 || height > 600) {
          // Scale down proportionally
          double scale = 600.0 / (width > height ? width : height);
          resized = img.copyResize(
            image,
            width: (width * scale).toInt(),
            height: (height * scale).toInt(),
          );
        }

        compressedBytes = img.encodeJpg(resized, quality: quality.toInt());
        final base64Size = (compressedBytes.length * 4 / 3).toInt(); // base64 adds ~33% overhead

        print('Compress attempt: quality=$quality, size=${compressedBytes.length}B, base64~=${base64Size}B');

        if (base64Size < maxSize) {
          final result = base64Encode(compressedBytes);
          print('✓ Compressed successfully: ${compressedBytes.length}B -> base64 ${result.length}B');
          return result;
        }

        quality -= 15.0;
      }

      // Jika masih terlalu besar, return null
      print('❌ Image terlalu besar bahkan dengan compression minimum');
      return null;
    } catch (e) {
      print('Error compress image: $e');
      return null;
    }
  }

  void _autoSaveWithDelay() {
    _autoSaveTimer?.cancel();
    _autoSaveTimer = Timer(const Duration(milliseconds: 1500), () {
      if (_hasChanges && mounted && !isLoading && !_isAutoSaving) {
        _autoSaveAgenda();
      }
    });
  }

  Future<void> _autoSaveAgenda() async {
    if (!mounted || !_hasChanges || isLoading || _isAutoSaving) return;

    // Don't save if required fields are empty
    if (judulController.text.isEmpty || tanggalController.text.isEmpty) {
      return;
    }

    setState(() => _isAutoSaving = true);

    try {
      String? dokumentasiData;
      if (_pickedDokumentasi != null) {
        // Compress image iteratively
        final compressedImage = await _compressImageIteratively(_pickedDokumentasi!);
        if (compressedImage != null) {
          dokumentasiData = compressedImage;
        } else {
          // Image terlalu besar - show user notice
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('⚠️ Foto terlalu besar. Disimpan tanpa perubahan foto.'),
                backgroundColor: AppColors.warning,
                duration: Duration(seconds: 2),
              ),
            );
          }
          dokumentasiData = _lastSavedAgenda.dokumentasi;
        }
      } else {
        dokumentasiData = dokumentasiController.text.isNotEmpty 
            ? dokumentasiController.text 
            : _lastSavedAgenda.dokumentasi;
      }

      final updatedAgenda = widget.agenda.copyWith(
        judul: judulController.text,
        tanggal: tanggalController.text,
        deskripsi: deskripsiController.text,
        dokumentasi: dokumentasiData,
        status: _status,
      );

      await AgendaService().updateAgenda(
        updatedAgenda.id,
        updatedAgenda.judul,
        updatedAgenda.tanggal,
        updatedAgenda.deskripsi,
        dokumentasiText: dokumentasiData,
        status: _status,
      );

      if (mounted) {
        _lastSavedAgenda = updatedAgenda;
        setState(() => _hasChanges = false);
        
        // Show subtle save notification
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✓ Perubahan tersimpan otomatis'),
            backgroundColor: AppColors.success,
            duration: Duration(milliseconds: 1500),
          ),
        );
      }
    } catch (e) {
      print('Auto-save error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isAutoSaving = false);
      }
    }
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    judulController.removeListener(_onContentChanged);
    tanggalController.removeListener(_onContentChanged);
    deskripsiController.removeListener(_onContentChanged);
    dokumentasiController.removeListener(_onContentChanged);
    judulController.dispose();
    tanggalController.dispose();
    deskripsiController.dispose();
    dokumentasiController.dispose();
    super.dispose();
  }

  Future<void> updateAgenda() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      // Encode dokumentasi file ke base64 jika ada file baru dipilih
      String? dokumentasiData;
      if (_pickedDokumentasi != null) {
        final uploadedUrl = await _compressImageIteratively(_pickedDokumentasi!);
        if (uploadedUrl != null) {
          dokumentasiData = uploadedUrl;
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('⚠️ Foto terlalu besar. Disimpan tanpa perubahan foto.'),
                backgroundColor: AppColors.warning,
                duration: Duration(seconds: 2),
              ),
            );
          }
          dokumentasiData = dokumentasiController.text;
        }
      } else {
        dokumentasiData = dokumentasiController.text;
      }

      final updatedAgenda = widget.agenda.copyWith(
        judul: judulController.text,
        tanggal: tanggalController.text,
        deskripsi: deskripsiController.text,
        dokumentasi: dokumentasiData,
        status: _status,
      );

      await AgendaService().updateAgenda(
        updatedAgenda.id,
        updatedAgenda.judul,
        updatedAgenda.tanggal,
        updatedAgenda.deskripsi,
        dokumentasiText: dokumentasiData,
        status: _status,
      );

      if (!mounted) return;
      
      _lastSavedAgenda = updatedAgenda;
      setState(() => _hasChanges = false);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✓ Agenda berhasil disimpan'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      print('Update agenda error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> deleteAgenda() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Agenda'),
        content: const Text('Yakin ingin menghapus agenda ini?'),
        actions: [
          TextButton(
            child: const Text('Batal'),
            onPressed: () => Navigator.pop(context, false),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Hapus'),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await AgendaService().deleteAgenda(widget.agenda.id);

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  Future<void> _pickDokumentasi() async {
    final XFile? pickedFile = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _pickedDokumentasi = pickedFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Agenda'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: deleteAgenda,
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Judul
              const Text(
                'Judul Agenda',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: judulController,
                decoration: InputDecoration(
                  hintText: 'Masukkan judul agenda',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  prefixIcon: const Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Judul tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.lg),

              // Tanggal
              const Text(
                'Tanggal',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: tanggalController,
                decoration: InputDecoration(
                  hintText: 'YYYY-MM-DD',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  prefixIcon: const Icon(Icons.calendar_today),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tanggal tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.lg),

              // Status
              const Text(
                'Status',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                  prefixIcon: const Icon(Icons.flag),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'akan_datang',
                    child: Text('Akan Datang'),
                  ),
                  DropdownMenuItem(
                    value: 'terlaksana',
                    child: Text('Terlaksana'),
                  ),
                  DropdownMenuItem(
                    value: 'tidak_terlaksana',
                    child: Text('Tidak Terlaksana'),
                  ),
                ],
                onChanged: (value) {
                  setState(() => _status = value ?? 'akan_datang');
                },
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
              TextFormField(
                controller: deskripsiController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: 'Masukkan deskripsi agenda',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Deskripsi tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.lg),

              // Dokumentasi Agenda
              const Text(
                'Dokumentasi Agenda (Opsional)',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              GestureDetector(
                onTap: _pickDokumentasi,
                child: Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _pickedDokumentasi == null ? Colors.grey : AppColors.success,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    color: _pickedDokumentasi == null ? Colors.grey[100] : Colors.transparent,
                  ),
                  child: _pickedDokumentasi == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.photo_camera_outlined,
                              size: 48,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              'Pilih Foto Dokumentasi',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        )
                      : Stack(
                          fit: StackFit.expand,
                          children: [
                            if (kIsWeb)
                              Image.network(
                                _pickedDokumentasi!.path,
                                fit: BoxFit.cover,
                              )
                            else
                              Image.file(
                                File(_pickedDokumentasi!.path),
                                fit: BoxFit.cover,
                              ),
                            Positioned(
                              top: 5,
                              right: 5,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() => _pickedDokumentasi = null);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: AppColors.error,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Auto-save indicator and save button
              if (_isAutoSaving)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      const Text(
                        'Menyimpan perubahan...',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.primary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading || _isAutoSaving ? null : updateAgenda,
                  child: isLoading || _isAutoSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Simpan & Tutup'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
