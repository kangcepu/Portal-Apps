import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../config/constants.dart';
import '../../services/api_service.dart';
import '../../widgets/custom_title_bar.dart';

class ManageSettingsPage extends StatefulWidget {
  const ManageSettingsPage({super.key});
  
  @override
  State<ManageSettingsPage> createState() => _ManageSettingsPageState();
}

class _ManageSettingsPageState extends State<ManageSettingsPage> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _portalKeywordController = TextEditingController();
  final _adminKeywordController = TextEditingController();
  final _helpKeywordController = TextEditingController();
  
  String _currentPassword = '';
  String _currentHelpImagePath = '';
  bool _isLoading = true;
  bool _isUploading = false;
  bool _obscureOldPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() => _isLoading = true);
    try {
      final data = await apiService.fetchData();
      
      if (data != null && mounted) {
        final settings = data['settings'];
        
        setState(() {
          _currentPassword = settings['admin_password'] ?? '';
          _portalKeywordController.text = settings['portal_keyword'] ?? '';
          _adminKeywordController.text = settings['admin_keyword'] ?? '';
          _helpKeywordController.text = settings['help_keyword'] ?? '';
          _currentHelpImagePath = settings['help_image_path'] ?? '';
          _isLoading = false;
        });
      } else if (mounted) {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('Error loading settings: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _pickAndUploadHelpImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) {
      setState(() => _isUploading = true);
      final filePath = result.files.single.path!;
      final newImageUrl = await apiService.uploadHelpImage(filePath);
      setState(() => _isUploading = false);
      
      if (newImageUrl != null) {
        setState(() {
          _currentHelpImagePath = newImageUrl;
        });
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gambar berhasil diupload!'), backgroundColor: Colors.green));
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal meng-upload gambar.'), backgroundColor: Colors.red));
      }
    }
  }

  Future<void> _saveSettings() async {
    Map<String, String> settingsToUpdate = {};

    if (_newPasswordController.text.isNotEmpty) {
      if (_oldPasswordController.text != _currentPassword) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password lama salah!'), backgroundColor: Colors.red));
        return;
      }
      if (_newPasswordController.text != _confirmPasswordController.text) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password baru tidak cocok!'), backgroundColor: Colors.red));
        return;
      }
      settingsToUpdate['admin_password'] = _newPasswordController.text;
    }

    settingsToUpdate['portal_keyword'] = _portalKeywordController.text;
    settingsToUpdate['admin_keyword'] = _adminKeywordController.text;
    settingsToUpdate['help_keyword'] = _helpKeywordController.text;
    settingsToUpdate['help_image_path'] = _currentHelpImagePath;

    final success = await apiService.updateSettings(settingsToUpdate);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pengaturan berhasil disimpan!'), backgroundColor: Colors.green));
      Navigator.pop(context);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan pengaturan.'), backgroundColor: Colors.red));
    }
  }

  Widget _buildSection({required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool obscureText = false,
    bool? obscureValue,
    VoidCallback? onToggleObscure,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        obscureText: obscureValue ?? obscureText,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.blue, width: 2),
          ),
          suffixIcon: onToggleObscure != null
              ? IconButton(
                  icon: Icon(
                    (obscureValue ?? obscureText) ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: onToggleObscure,
                )
              : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTitleBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
              iconSize: 20,
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Pengaturan Umum",
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Kelola password, kata kunci, dan gambar bantuan",
                          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 24),
                        
                        // Two Column Layout
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left Column
                            Expanded(
                              child: Column(
                                children: [
                                  // Password Section
                                  _buildSection(
                                    title: "Ganti Password Admin",
                                    children: [
                                      _buildTextField(
                                        controller: _oldPasswordController,
                                        label: 'Password Lama',
                                        obscureValue: _obscureOldPassword,
                                        onToggleObscure: () => setState(() => _obscureOldPassword = !_obscureOldPassword),
                                      ),
                                      _buildTextField(
                                        controller: _newPasswordController,
                                        label: 'Password Baru',
                                        obscureValue: _obscureNewPassword,
                                        onToggleObscure: () => setState(() => _obscureNewPassword = !_obscureNewPassword),
                                      ),
                                      _buildTextField(
                                        controller: _confirmPasswordController,
                                        label: 'Konfirmasi Password Baru',
                                        obscureValue: _obscureConfirmPassword,
                                        onToggleObscure: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                  
                                  // Keywords Section
                                  _buildSection(
                                    title: "Kata Kunci Sistem",
                                    children: [
                                      _buildTextField(
                                        controller: _portalKeywordController,
                                        label: 'Kata Kunci Portal',
                                      ),
                                      _buildTextField(
                                        controller: _adminKeywordController,
                                        label: 'Kata Kunci Admin',
                                      ),
                                      _buildTextField(
                                        controller: _helpKeywordController,
                                        label: 'Kata Kunci Bantuan',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(width: 24),
                            
                            // Right Column
                            Expanded(
                              child: _buildSection(
                                title: "Gambar Bantuan",
                                children: [
                                  if (_currentHelpImagePath.isNotEmpty)
                                    Container(
                                      height: 400,
                                      width: double.infinity,
                                      margin: const EdgeInsets.only(bottom: 16),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey.shade300),
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.grey.shade50,
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          _currentHelpImagePath.replaceAll('localhost', serverIp),
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    )
                                  else 
                                    Container(
                                      height: 400,
                                      width: double.infinity,
                                      margin: const EdgeInsets.only(bottom: 16),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.grey.shade50,
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.image_outlined, size: 64, color: Colors.grey.shade400),
                                          const SizedBox(height: 8),
                                          Text(
                                            "Belum ada gambar",
                                            style: TextStyle(color: Colors.grey.shade600),
                                          ),
                                        ],
                                      ),
                                    ),
                                  _isUploading
                                      ? const Center(child: CircularProgressIndicator())
                                      : SizedBox(
                                          width: double.infinity,
                                          height: 48,
                                          child: ElevatedButton.icon(
                                            icon: const Icon(Icons.upload_file),
                                            label: const Text("Pilih Gambar Baru"),
                                            onPressed: _pickAndUploadHelpImage,
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),
                        
                        // Save Button
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _saveSettings,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              "Simpan Semua Pengaturan",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}