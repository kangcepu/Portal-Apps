import 'package:flutter/material.dart';
import '../../widgets/custom_title_bar.dart';
import '../initial_page.dart';
import 'admin_dashboard_page.dart';

class AdminLoginPage extends StatefulWidget {
  final String password;
  const AdminLoginPage({super.key, required this.password});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final TextEditingController _passwordController = TextEditingController();
  String? _errorText;

  void _login() {
    if (_passwordController.text == widget.password) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AdminDashboardPage()));
    } else {
      setState(() {
        _errorText = 'Password salah.';
      });
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
                    const Text("Login Admin", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 30),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                        hintText: 'Masukkan password...',
                        errorText: _errorText,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.red.shade700, width: 2),
                        ),
                      ),
                      onSubmitted: (_) => _login(),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      child: const Text('Login'),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const InitialPage()),
                        );
                      },
                      child: const Text("Kembali"),
                    ),
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