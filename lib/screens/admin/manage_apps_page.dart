import 'package:flutter/material.dart';
import '../../config/constants.dart';
import '../../models/app_model.dart';
import '../../models/category_model.dart';
import '../../services/api_service.dart';
import '../../widgets/custom_title_bar.dart';
import 'widgets/app_editor_dialog.dart';

class ManageAppsPage extends StatefulWidget {
  const ManageAppsPage({super.key});
  
  @override
  State<ManageAppsPage> createState() => _ManageAppsPageState();
}

class _ManageAppsPageState extends State<ManageAppsPage> {
  List<AppModel> _allApps = [];
  List<CategoryModel> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    final categoriesData = await apiService.getCategories();
    if (categoriesData != null) {
      _categories = categoriesData.map((json) => CategoryModel.fromJson(json)).toList();
      _categories.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
    }
    
    final data = await apiService.fetchData();
    if (data != null && mounted) {
      setState(() {
        _allApps = (data['applications'] as List).map((e) => AppModel.fromJson(e)).toList();
        _allApps.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
        _isLoading = false;
      });
    }
  }

  Future<void> _saveChanges() async {
    for (var category in _categories) {
      final mainApps = _allApps.where((app) => app.appGroup == '${category.id}_main').toList();
      final utilityApps = _allApps.where((app) => app.appGroup == '${category.id}_utility').toList();
      
      for (int i = 0; i < mainApps.length; i++) {
        mainApps[i].displayOrder = i;
      }
      for (int i = 0; i < utilityApps.length; i++) {
        utilityApps[i].displayOrder = i;
      }
    }

    final success = await apiService.saveAllApps(_allApps);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Perubahan berhasil disimpan!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal menyimpan perubahan.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _deleteApp(AppModel app) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Aplikasi'),
        content: Text('Yakin ingin menghapus "${app.name}"?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _allApps.removeWhere((element) => element.id == app.id);
              });
              _saveChanges();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _showAppDialog({AppModel? app}) async {
    final result = await showDialog<AppModel>(
      context: context,
      builder: (context) => AppEditorDialog(app: app),
    );

    if (result != null) {
      setState(() {
        if (app == null) {
          _allApps.add(result);
        } else {
          final index = _allApps.indexWhere((element) => element.id == app.id);
          if (index != -1) {
            _allApps[index] = result;
          }
        }
      });
      _saveChanges();
    }
  }

  void _onReorder(int oldIndex, int newIndex, List<AppModel> appList, String group) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final AppModel item = appList.removeAt(oldIndex);
      appList.insert(newIndex, item);

      final otherGroupApps = _allApps.where((app) => app.appGroup != group).toList();
      _allApps = [...otherGroupApps, ...appList];
    });
    _saveChanges();
  }

  Widget _buildAppSection(String title, List<AppModel> apps, String groupName, Color accentColor) {
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
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  color: accentColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${apps.length}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: accentColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (apps.isEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200, style: BorderStyle.solid),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_outlined, size: 20, color: Colors.grey.shade400),
                  const SizedBox(width: 8),
                  Text(
                    "Belum ada aplikasi",
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            )
          else
            ReorderableListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: apps.length,
              buildDefaultDragHandles: false,
              itemBuilder: (context, index) {
                final app = apps[index];
                return Container(
                  key: ValueKey(app.id),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ReorderableDragStartListener(
                          index: index,
                          child: Icon(Icons.drag_indicator, size: 20, color: Colors.grey.shade400),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: app.borderColor, width: 2),
                          ),
                          padding: const EdgeInsets.all(3),
                          child: Image.network(
                            app.iconPath.replaceAll('localhost', serverIp),
                            fit: BoxFit.contain,
                            errorBuilder: (c, e, s) => Icon(Icons.error, size: 16, color: Colors.grey.shade400),
                          ),
                        ),
                      ],
                    ),
                    title: Text(
                      app.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      app.executablePath,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 18),
                          onPressed: () => _showAppDialog(app: app),
                          tooltip: 'Edit',
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 4),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                          onPressed: () => _deleteApp(app),
                          tooltip: 'Hapus',
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ),
                );
              },
              onReorder: (oldIndex, newIndex) {
                _onReorder(oldIndex, newIndex, apps, groupName);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildCategoryRow(CategoryModel category) {
    final mainApps = _allApps.where((app) => app.appGroup == '${category.id}_main').toList();
    final utilityApps = _allApps.where((app) => app.appGroup == '${category.id}_utility').toList();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 12),
          child: Text(
            category.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kolom Kiri - Utility
            Expanded(
              child: _buildAppSection(
                "Aplikasi Utilitas",
                utilityApps,
                '${category.id}_utility',
                Colors.orange,
              ),
            ),
            const SizedBox(width: 16),
            // Kolom Kanan - Utama
            Expanded(
              child: _buildAppSection(
                "Aplikasi Utama",
                mainApps,
                '${category.id}_main',
                Colors.blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
      ],
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
            actions: [
              IconButton(
                icon: const Icon(Icons.save, size: 20),
                tooltip: 'Simpan Manual',
                onPressed: _saveChanges,
              ),
              const SizedBox(width: 4),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Kelola Aplikasi",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  "Drag & drop untuk mengubah urutan aplikasi",
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _categories.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.category_outlined, size: 64, color: Colors.grey.shade400),
                            const SizedBox(height: 16),
                            Text(
                              'Belum ada kategori',
                              style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Tambahkan kategori terlebih dahulu\ndi menu Kelola Kategori',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                        itemCount: _categories.length,
                        itemBuilder: (context, index) {
                          return _buildCategoryRow(_categories[index]);
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAppDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Tambah App'),
      ),
    );
  }
}