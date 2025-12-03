import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/app_model.dart';
import '../models/category_model.dart';
import '../services/api_service.dart';
import '../widgets/custom_title_bar.dart';
import 'portal/dynamic_category_page.dart';
import 'admin/admin_login_page.dart';
import 'help_page.dart';
import 'dynamic_app_page.dart';

class KeywordPage extends StatefulWidget {
  final Map<String, dynamic> data;
  const KeywordPage({super.key, required this.data});
  
  @override
  State<KeywordPage> createState() => _KeywordPageState();
}

class _KeywordPageState extends State<KeywordPage> {
  final TextEditingController _controller = TextEditingController();
  String? _errorText;
  List<CategoryModel> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final categoriesData = await apiService.getCategories();
    if (categoriesData != null && mounted) {
      setState(() {
        _categories = categoriesData.map((json) => CategoryModel.fromJson(json)).toList();
      });
    }
  }

  void _processInput() {
    String input = _controller.text.trim().toLowerCase();
    final settings = widget.data['settings'];
    
    // RESERVED SYSTEM PAGES (prioritas tertinggi)
    if (input == settings['admin_keyword']) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminLoginPage(password: settings['admin_password'])));
    } else if (input == settings['help_keyword']) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HelpPage(imagePath: settings['help_image_path'])));
    } else {
      // Cek dynamic categories
      final foundCategory = _categories.where((cat) => cat.keyword.toLowerCase() == input).toList();
      
      if (foundCategory.isNotEmpty) {
        // Route ke dynamic category page
        Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => DynamicCategoryPage(category: foundCategory.first)
        ));
      } else {
        // Cek dynamic apps dari database
        final apps = widget.data['applications'] as List;
        final foundApp = apps.where((app) => 
          app['name'].toString().toLowerCase() == input ||
          app['name'].toString().toLowerCase().replaceAll(' ', '') == input
        ).toList();
        
        if (foundApp.isNotEmpty) {
          // Route ke dynamic app page dengan data app
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) => DynamicAppPage(appData: AppModel.fromJson(foundApp.first))
          ));
        } else {
          setState(() { 
            _errorText = 'Kata kunci tidak valid.';
            _controller.clear();
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomTitleBar(),
          Expanded(
            child: Center(
              child: SizedBox(
                width: 350,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50,
                      child: SvgPicture.asset('assets/icons/teks.svg'),
                    ),
                    const SizedBox(height: 40),
                    TextField(
                        controller: _controller,
                        obscureText: true,
                        obscuringCharacter: '*',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                            hintText: 'Masukkan kata kunci...',
                            errorText: _errorText,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: Colors.red.shade700, width: 2))),
                        onSubmitted: (_) => _processInput()),
                    const SizedBox(height: 20),
                    ElevatedButton(
                        onPressed: _processInput,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade700,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            textStyle: const TextStyle(fontSize: 18)),
                        child: const Text('Masuk')),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}