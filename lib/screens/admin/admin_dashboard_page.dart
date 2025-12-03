import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../widgets/custom_title_bar.dart';
import '../initial_page.dart';
import 'manage_categories_page.dart';
import 'manage_apps_page.dart';
import 'manage_settings_page.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  late Future<Map<String, int>> _statsFuture;

@override
void initState() {
  super.initState();
  _statsFuture = _loadStats();
}

Future<Map<String, int>> _loadStats() async {
    final data = await apiService.fetchData();
    final installCount = await apiService.getInstallCount();
    
    int totalApps = 0;
    int totalCategories = 0;
    
    if (data != null) {
      // Hitung total aplikasi unik berdasarkan nama
      final appsList = data['applications'] as List?;
      if (appsList != null) {
        final uniqueAppNames = <String>{};
        for (var app in appsList) {
          uniqueAppNames.add(app['name']);
        }
        totalApps = uniqueAppNames.length;
      }
      
      totalCategories = (data['categories'] as List?)?.length ?? 0;
    }
    
    return {
      'installs': installCount,
      'apps': totalApps,
      'categories': totalCategories,
    };
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    bool isLoading = false,
  }) {
    return Expanded(
      child: Container(
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
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 24, color: color),
            ),
            const SizedBox(height: 16),
            Text(
              isLoading ? "..." : value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
  }) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 28, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, size: 24, color: Colors.grey.shade400),
            ],
          ),
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
            actions: [
              IconButton(
                icon: const Icon(Icons.logout, size: 20),
                tooltip: 'Kembali ke Halaman Awal',
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const InitialPage()),
                ),
              ),
              const SizedBox(width: 4),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Admin Dashboard",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Kelola aplikasi dan pengaturan portal",
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 28),
                  
                  // Statistics Cards
                  FutureBuilder<Map<String, int>>(
                    future: _statsFuture,
                    builder: (context, snapshot) {
                      final isLoading = snapshot.connectionState == ConnectionState.waiting;
                      final stats = snapshot.data ?? {'installs': 0, 'apps': 0, 'categories': 0};
                      
                      return Column(
                        children: [
                          Row(
                            children: [
                              _buildStatCard(
                                title: "PC Terinstall",
                                value: stats['installs'].toString(),
                                icon: Icons.computer_outlined,
                                color: Colors.blue,
                                isLoading: isLoading,
                              ),
                              const SizedBox(width: 16),
                              _buildStatCard(
                                title: "Total Aplikasi",
                                value: stats['apps'].toString(),
                                icon: Icons.apps_rounded,
                                color: Colors.orange,
                                isLoading: isLoading,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              _buildStatCard(
                                title: "Total Kategori",
                                value: stats['categories'].toString(),
                                icon: Icons.category_rounded,
                                color: Colors.purple,
                                isLoading: isLoading,
                              ),
                              const SizedBox(width: 16),
                              _buildStatCard(
                                title: "Sistem Aktif",
                                value: "Online",
                                icon: Icons.check_circle_outline,
                                color: Colors.green,
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                  
                  const SizedBox(height: 32),
                  Text(
                    "Menu Manajemen",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  _buildMenuCard(
                    icon: Icons.category_rounded,
                    title: "Kelola Kategori Portal",
                    subtitle: "Tambah kategori baru seperti Tax, Creative, dll.",
                    color: Colors.purple,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ManageCategoriesPage()),
                      ).then((_) => setState(() {
                        _statsFuture = _loadStats();
                      }));
                    },
                  ),
                  const SizedBox(height: 12),
                  
                  _buildMenuCard(
                    icon: Icons.apps_rounded,
                    title: "Kelola Aplikasi Portal",
                    subtitle: "Tambah, edit, atau hapus aplikasi di halaman portal",
                    color: Colors.orange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ManageAppsPage()),
                      ).then((_) => setState(() {
                        _statsFuture = _loadStats();
                      }));
                    },
                  ),
                  const SizedBox(height: 12),
                  
                  _buildMenuCard(
                    icon: Icons.settings_rounded,
                    title: "Pengaturan Umum",
                    subtitle: "Ganti password admin dan kata kunci",
                    color: Colors.teal,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ManageSettingsPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}