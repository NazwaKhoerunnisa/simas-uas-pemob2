import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import '../core/constants/app_colors.dart';
import '../core/constants/app_spacing.dart';

class AgendaAddPage extends StatefulWidget {
  const AgendaAddPage({super.key});

  @override
  State<AgendaAddPage> createState() => _AgendaAddPageState();
}

class _AgendaAddPageState extends State<AgendaAddPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController judulController = TextEditingController();
  final TextEditingController tanggalController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();

  XFile? _pickedDokumentasi;
  String _status = 'akan_datang';
  bool isLoading = false;

  final String apiUrl =
      'https://695be5ba1d8041d5eeb8e3ae.mockapi.io/agenda';

  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _pickDokumentasi() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          _pickedDokumentasi = pickedFile;
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error memilih dokumentasi: $e')),
      );
    }
  }

  Future<void> tambahAgenda() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      String? dokumentasiBase64;

      if (_pickedDokumentasi != null) {
        final bytes = await _pickedDokumentasi!.readAsBytes();
        dokumentasiBase64 = base64Encode(bytes);
      }

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'judul': judulController.text,
          'tanggal': tanggalController.text,
          'deskripsi': deskripsiController.text,
          'dokumentasi': dokumentasiBase64,
          'status': _status,
        }),
      );

      if (response.statusCode == 201) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Agenda berhasil ditambahkan'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pop(context, true);
      } else {
        throw Exception('Gagal menambah agenda');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Agenda'),
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

              // Tambah Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : tambahAgenda,
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Tambah Agenda'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
