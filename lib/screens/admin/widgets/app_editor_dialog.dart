import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../../models/app_model.dart';
import '../../../models/category_model.dart';
import '../../../services/api_service.dart';

class AppEditorDialog extends StatefulWidget {
  final AppModel? app;
  const AppEditorDialog({super.key, this.app});

  @override
  State<AppEditorDialog> createState() => _AppEditorDialogState();
}

class _AppEditorDialogState extends State<AppEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descController;
  late TextEditingController _iconPathController;
  late TextEditingController _execPathController;
  String _selectedGroup = 'main';
  bool get _isEditing => widget.app != null;
  bool _isUploading = false;
  bool _isLoadingCategories = true;
  List<CategoryModel> _categories = [];
  List<DropdownMenuItem<String>> _dropdownItems = [];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.app?.name ?? '');
    _descController = TextEditingController(text: widget.app?.description ?? '');
    _iconPathController = TextEditingController(text: widget.app?.iconPath ?? '');
    _execPathController =
        TextEditingController(text: widget.app?.executablePath ?? '');
    _selectedGroup = widget.app?.appGroup ?? 'main';
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final categoriesData = await apiService.getCategories();
    if (categoriesData != null && mounted) {
      setState(() {
        _categories = categoriesData.map((json) => CategoryModel.fromJson(json)).toList();
        _buildDropdownItems();
        _isLoadingCategories = false;
      });
    }
  }

  void _buildDropdownItems() {
    _dropdownItems = [];
    
    // Gunakan Set untuk tracking value yang sudah ada
    Set<String> addedValues = {};
    
    for (var category in _categories) {
      final mainValue = '${category.id}_main';
      final utilityValue = '${category.id}_utility';
      
      // Hanya tambahkan jika belum ada
      if (!addedValues.contains(mainValue)) {
        _dropdownItems.add(
          DropdownMenuItem(
            value: mainValue,
            child: Text('${category.name} - Aplikasi Utama'),
          ),
        );
        addedValues.add(mainValue);
      }
      
      if (!addedValues.contains(utilityValue)) {
        _dropdownItems.add(
          DropdownMenuItem(
            value: utilityValue,
            child: Text('${category.name} - Aplikasi Utilitas'),
          ),
        );
        addedValues.add(utilityValue);
      }
    }
    
    if (_dropdownItems.isNotEmpty) {
      final validValues = _dropdownItems.map((item) => item.value).toSet();
      if (!validValues.contains(_selectedGroup)) {
        _selectedGroup = _dropdownItems.first.value!;
      }
    }
  }

  Future<void> _pickAndUploadIcon() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg', 'ico'],
    );
    if (result != null) {
      setState(() => _isUploading = true);
      final filePath = result.files.single.path!;
      final newIconUrl = await apiService.uploadIcon(filePath);
      setState(() => _isUploading = false);
      if (newIconUrl != null) {
        setState(() {
          _iconPathController.text = newIconUrl;
        });
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal meng-upload ikon.')));
      }
    }
  }

  Future<void> _pickExecutable() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _execPathController.text = result.files.single.path!;
      });
    }
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      Color borderColor;
      if (_selectedGroup.endsWith('_main')) {
        borderColor = Colors.red.shade700;
      } else {
        final categoryId = int.tryParse(_selectedGroup.split('_')[0]);
        final category = _categories.firstWhere(
          (cat) => cat.id == categoryId,
          orElse: () => CategoryModel(
            name: 'Default',
            keyword: 'default',
            backgroundColor: const Color(0xFFE3F2FD),
          ),
        );
        borderColor = category.backgroundColor.withOpacity(0.8);
      }
      
      final newApp = AppModel(
        id: widget.app?.id,
        name: _nameController.text,
        description: _descController.text,
        iconPath: _iconPathController.text,
        executablePath: _execPathController.text,
        borderColor: borderColor,
        appGroup: _selectedGroup,
        displayOrder: widget.app?.displayOrder ?? 99,
      );
      Navigator.of(context).pop(newApp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEditing ? 'Edit Aplikasi' : 'Tambah Aplikasi Baru'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_isUploading)
                const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator()),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nama Aplikasi'),
                validator: (value) =>
                    value!.isEmpty ? 'Nama tidak boleh kosong' : null,
              ),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
              ),
              if (_isLoadingCategories)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                )
              else if (_dropdownItems.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Belum ada kategori. Silakan buat kategori terlebih dahulu.',
                    style: TextStyle(color: Colors.red),
                  ),
                )
              else
                DropdownButtonFormField<String>(
                  value: _selectedGroup,
                  items: _dropdownItems,
                  onChanged: (value) => setState(() => _selectedGroup = value!),
                  decoration: const InputDecoration(labelText: 'Pilih Kategori'),
                ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _iconPathController,
                decoration: const InputDecoration(labelText: 'URL Ikon'),
                readOnly: true,
              ),
              ElevatedButton(
                onPressed: _pickAndUploadIcon,
                child: const Text('Pilih & Upload Ikon'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _execPathController,
                decoration: const InputDecoration(labelText: 'Path/URL Aplikasi'),
              ),
              ElevatedButton(
                onPressed: _pickExecutable,
                child: const Text('Pilih File Aplikasi'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Batal')),
        ElevatedButton(
          onPressed: _dropdownItems.isEmpty ? null : _save,
          child: const Text('Simpan'),
        ),
      ],
    );
  }
}