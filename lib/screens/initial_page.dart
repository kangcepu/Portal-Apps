import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:process_run/shell.dart';
import 'package:version/version.dart';
import 'dart:io';
import '../services/api_service.dart';
import '../widgets/custom_title_bar.dart';
import 'keyword_page.dart';

class InitialPage extends StatefulWidget {
  const InitialPage({super.key});
  
  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  Map<String, dynamic>? _data;
  bool _isLoading = true;
  bool _isDownloading = false;
  double _downloadProgress = 0.0;
  String _downloadStatusText = '';

  @override
  void initState() {
    super.initState();
    _initialize();
  }
  
  Future<void> _initialize() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForUpdate();
    });
    await _fetchData();
  }

  Future<void> _fetchData() async {
    final data = await apiService.fetchData();
    if (data != null && mounted) {
      setState(() {
        _data = data;
        _isLoading = false;
      });
    } else if (mounted) {
      setState(() { _isLoading = false; });
    }
  }

  Future<void> _checkForUpdate() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final currentVersion = Version.parse(packageInfo.version);

    final latestVersionInfo = await apiService.getLatestAppVersion();
    if (latestVersionInfo == null) return;

    final latestVersion = Version.parse(latestVersionInfo['version']);
    final downloadUrl = latestVersionInfo['url'];

    if (latestVersion > currentVersion && mounted) {
      _showUpdateDialog(latestVersion.toString(), downloadUrl);
    }
  }

  Future<void> _startUpdate(String downloadUrl, StateSetter setState) async {
    setState(() {
      _isDownloading = true;
      _downloadProgress = 0.0;
      _downloadStatusText = 'Mengunduh pembaruan...';
    });

    try {
      final tempDir = await getTemporaryDirectory();
      final fileName = downloadUrl.split('/').last;
      final savePath = '${tempDir.path}\\$fileName';

      final dio = Dio();
      await dio.download(
        downloadUrl,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            setState(() {
              _downloadProgress = received / total;
            });
          }
        },
      );
      
      setState(() {
        _downloadStatusText = 'Download selesai. Menjalankan installer...\n\nAplikasi akan ditutup otomatis.';
      });

      await Future.delayed(const Duration(seconds: 2));

      await Shell().run('powershell -Command "Start-Process \\"$savePath\\" -ArgumentList \\"/VERYSILENT /CLOSEAPPLICATIONS /RESTARTAPPLICATIONS\\" -Verb RunAs"');
      
      await Future.delayed(const Duration(seconds: 1));
      
      exit(0);

    } catch (e) {
      debugPrint("Error saat update: $e");
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal update: $e'))
        );
      }
    }
  }

  void _showUpdateDialog(String newVersion, String downloadUrl) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Pembaruan Wajib Tersedia"),
              content: _isDownloading
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_downloadStatusText),
                        const SizedBox(height: 20),
                        LinearProgressIndicator(value: _downloadProgress),
                        const SizedBox(height: 10),
                        Text('${(_downloadProgress * 100).toStringAsFixed(0)}%'),
                      ],
                    )
                  : Text("Versi baru ($newVersion) harus di-install untuk melanjutkan."),
              actions: _isDownloading
                  ? []
                  : <Widget>[
                      ElevatedButton(
                        child: const Text("PERBARUI SEKARANG"),
                        onPressed: () => _startUpdate(downloadUrl, setState),
                      ),
                    ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_data == null) {
      return Scaffold(
        body: Column(
          children: [
            CustomTitleBar(),
            Expanded(
              child: Center(
                child: Text("Gagal terhubung ke server"),
              ),
            ),
          ],
        ),
      );
    }
    return KeywordPage(data: _data!);
  }
}