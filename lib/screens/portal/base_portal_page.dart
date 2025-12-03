import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../models/app_model.dart';
import '../../services/api_service.dart';
import '../../widgets/custom_title_bar.dart';
import '../../widgets/app_grid_view.dart';
import '../../widgets/utility_grid_view.dart';
import '../initial_page.dart';

class BasePortalPage extends StatefulWidget {
  final String category; // 'portal', 'tax', 'creative'
  final String title;
  final Color titleColor;
  final String backgroundAsset;
  final Color backgroundColor;
  
  const BasePortalPage({
    super.key,
    required this.category,
    required this.title,
    required this.titleColor,
    required this.backgroundAsset,
    required this.backgroundColor,
  });

  @override
  State<BasePortalPage> createState() => _BasePortalPageState();
}

class _BasePortalPageState extends State<BasePortalPage> {
  List<AppModel> _mainApps = [];
  List<AppModel> _utilityApps = [];
  bool _isLoading = true;
  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();
    _fetchApps();
    _pollingTimer = Timer.periodic(const Duration(seconds: 10), (timer) => _fetchApps(showLoading: false));
  }

  @override
  void dispose() {
    _pollingTimer?.cancel(); 
    super.dispose();
  }

  Future<void> _fetchApps({bool showLoading = true}) async {
    if (showLoading) setState(() { _isLoading = true; });
    final data = await apiService.fetchData();
    if (data != null && mounted) {
      final allApps = (data['applications'] as List).map((json) => AppModel.fromJson(json)).toList();
      allApps.sort((a,b)=> a.displayOrder.compareTo(b.displayOrder));
      
      setState(() {
        if (widget.category == 'portal') {
          _mainApps = allApps.where((app) => app.appGroup == 'main').toList();
          _utilityApps = allApps.where((app) => app.appGroup == 'utility').toList();
        } else if (widget.category == 'tax') {
          _mainApps = allApps.where((app) => app.appGroup == 'tax_main').toList();
          _utilityApps = allApps.where((app) => app.appGroup == 'tax_utility').toList();
        } else if (widget.category == 'creative') {
          _mainApps = allApps.where((app) => app.appGroup == 'creative_main').toList();
          _utilityApps = allApps.where((app) => app.appGroup == 'creative_utility').toList();
        }
        _isLoading = false;
      });
    } else if (mounted) {
      setState(() { _isLoading = false; });
    }
  }

  Widget _buildTitleHeader() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, top: 5),
      child: SizedBox(
        height: 50,
        child: SvgPicture.asset('assets/icons/teks.svg'),
      ),
    );
  }

  Widget _buildContent() {
    String firstSectionTitle = "Aplikasi Utama";
    String secondSectionTitle = "Aplikasi Utilitas";
    
    if (widget.category != 'portal') {
      String categoryName = widget.category == 'tax' ? 'Tax' : 'Creative';
      firstSectionTitle = "Aplikasi $categoryName Utama";
      secondSectionTitle = "Aplikasi $categoryName Utilitas";
    }

    return Column(
      children: [
        // SECTION PERTAMA (Main Apps)
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
            child: Text(
              firstSectionTitle,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: _mainApps.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    "Belum ada aplikasi di bagian ini.\nSilakan tambahkan melalui halaman Admin.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                )
              : AppGridView(apps: _mainApps),
        ),
        const SizedBox(height: 40),
        
        // SECTION KEDUA (Utility Apps)
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
            child: Text(
              secondSectionTitle,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: _utilityApps.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    "Belum ada aplikasi di bagian ini.\nSilakan tambahkan melalui halaman Admin.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                )
              : widget.category == 'portal'
                  ? UtilityGridView(apps: _utilityApps)
                  : AppGridView(apps: _utilityApps),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      body: Stack(
        children: [
          SvgPicture.asset(
            'assets/bg/portal.svg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Column(
            children: [
              CustomTitleBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, size: 20),
                  onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const InitialPage()),
                  ),
                ),
              ),
              _buildTitleHeader(),
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(40, 0, 40, 40),
                      child: _buildContent(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}