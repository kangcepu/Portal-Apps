import 'dart:io';
import 'package:flutter/material.dart';
import 'package:process_run/shell.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/constants.dart';
import '../models/app_model.dart';
import '../widgets/custom_title_bar.dart';
import 'initial_page.dart';

class DynamicAppPage extends StatelessWidget {
  final AppModel appData;
  const DynamicAppPage({super.key, required this.appData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      body: Column(
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
          Expanded(
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.network(
                      appData.iconPath.replaceAll('localhost', serverIp),
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain,
                      errorBuilder: (c, e, s) => const Icon(Icons.apps, size: 100),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      appData.name.toUpperCase(),
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange.shade800,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (appData.description != null && appData.description!.isNotEmpty)
                      Text(
                        appData.description!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    const SizedBox(height: 30),
                    ElevatedButton.icon(
                      onPressed: () async {
                        if (appData.executablePath.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Path/URL untuk ${appData.name} belum diatur.')));
                          return;
                        }

                        final path = appData.executablePath;
                        if (path.startsWith('http://') || path.startsWith('https://')) {
                          final url = Uri.parse(path);
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url, mode: LaunchMode.externalApplication);
                          }
                        } else if (path.startsWith('\\\\')) {
                          try {
                            await Shell().run('start "" "$path"');
                          } catch (e) {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Tidak bisa membuka folder jaringan: $path. Error: $e')));
                          }
                        } else {
                          try {
                            await Process.run(path, [], runInShell: true, workingDirectory: File(path).parent.path);
                          } catch (e) {
                            try {
                              await Shell().run('start "" "$path"');
                            } catch (e2) {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Gagal menjalankan ${appData.name}: $e2')));
                            }
                          }
                        }
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: Text('Jalankan ${appData.name}'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      ),
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