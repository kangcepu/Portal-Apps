import 'package:flutter/material.dart';
import '../../models/category_model.dart';
import '../../services/api_service.dart';
import '../../widgets/custom_title_bar.dart';

class ManageCategoriesPage extends StatefulWidget {
  const ManageCategoriesPage({super.key});
  
  @override
  State<ManageCategoriesPage> createState() => _ManageCategoriesPageState();
}

class _ManageCategoriesPageState extends State<ManageCategoriesPage> {
  List<CategoryModel> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() => _isLoading = true);
    final data = await apiService.getCategories();
    if (data != null && mounted) {
      setState(() {
        _categories = data.map((json) => CategoryModel.fromJson(json)).toList();
        _categories.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
        _isLoading = false;
      });
    }
  }

  void _showCategoryDialog({CategoryModel? category}) async {
    final nameController = TextEditingController(text: category?.name ?? '');
    final keywordController = TextEditingController(text: category?.keyword ?? '');
    Color selectedColor = category?.backgroundColor ?? const Color(0xFFE3F2FD);

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(category == null ? 'Tambah Kategori Baru' : 'Edit Kategori'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Nama Kategori'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: keywordController,
                  decoration: const InputDecoration(
                    labelText: 'Kata Kunci',
                    helperText: 'Huruf kecil, tanpa spasi',
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Warna Background:'),
                    const SizedBox(width: 16),
                    InkWell(
                      onTap: () async {
                        // Simple color picker
                        final colors = [
                          const Color(0xFFE3F2FD), // Blue
                          const Color(0xFFF3E5F5), // Purple
                          const Color(0xFFE8F5E9), // Green
                          const Color(0xFFFFF3E0), // Orange
                          const Color(0xFFFCE4EC), // Pink
                          const Color(0xFFFFFDE7), // Yellow
                        ];
                        
                        final picked = await showDialog<Color>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Pilih Warna'),
                            content: Wrap(
                              spacing: 10,
                              children: colors.map((color) {
                                return InkWell(
                                  onTap: () => Navigator.pop(context, color),
                                  child: Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: color,
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        );
                        
                        if (picked != null) {
                          setState(() {
                            selectedColor = picked;
                          });
                        }
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: selectedColor,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isEmpty || keywordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Nama dan keyword harus diisi!')),
                  );
                  return;
                }

                final newCategory = CategoryModel(
                  id: category?.id,
                  name: nameController.text,
                  keyword: keywordController.text.toLowerCase().replaceAll(' ', ''),
                  backgroundColor: selectedColor,
                  displayOrder: category?.displayOrder ?? _categories.length,
                );

                final success = await apiService.saveCategory(newCategory.toJson());
                if (success) {
                  Navigator.pop(context, true);
                } else {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Gagal menyimpan kategori')),
                  );
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );

    if (result == true) {
      _loadCategories();
    }
  }

  void _deleteCategory(CategoryModel category) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Kategori'),
        content: Text('Yakin ingin menghapus kategori "${category.name}"?\n\nSemua aplikasi dalam kategori ini juga akan terhapus.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await apiService.deleteCategory(category.id!);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kategori berhasil dihapus')),
        );
        _loadCategories();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Text("Kelola Kategori Portal", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Text(
              "Tambah atau edit kategori portal. Setiap kategori akan punya halaman sendiri dengan keyword unik.",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _categories.isEmpty
                    ? const Center(
                        child: Text('Belum ada kategori.\nTekan tombol + untuk menambah.'),
                      )
                    : ReorderableListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _categories.length,
                        itemBuilder: (context, index) {
                          final category = _categories[index];
                          return ListTile(
                            key: ValueKey(category.id),
                            leading: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: category.backgroundColor,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                            ),
                            title: Text(category.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text('Keyword: ${category.keyword}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => _showCategoryDialog(category: category),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => _deleteCategory(category),
                                ),
                              ],
                            ),
                          );
                        },
                        onReorder: (oldIndex, newIndex) {
                          setState(() {
                            if (newIndex > oldIndex) {
                              newIndex -= 1;
                            }
                            final item = _categories.removeAt(oldIndex);
                            _categories.insert(newIndex, item);
                            
                            // Update display order
                            for (int i = 0; i < _categories.length; i++) {
                              _categories[i].displayOrder = i;
                              apiService.saveCategory(_categories[i].toJson());
                            }
                          });
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCategoryDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}