import 'dart:io';
import 'package:flutter/material.dart';
import 'package:process_run/shell.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/constants.dart';
import '../models/app_model.dart';

class AppItem extends StatefulWidget {
  final AppModel app;
  const AppItem({super.key, required this.app});

  @override
  State<AppItem> createState() => _AppItemState();
}

class _AppItemState extends State<AppItem> {
  bool _isHovered = false;

void _showAppNotFoundDialog() {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.all(24),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // App Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: widget.app.borderColor, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(8),
            child: Image.network(
              widget.app.iconPath.replaceAll('localhost', serverIp),
              fit: BoxFit.contain,
              errorBuilder: (c, e, s) => Icon(Icons.apps, size: 40, color: Colors.grey.shade400),
            ),
          ),
          const SizedBox(height: 16),
          // Warning Icon
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.warning_rounded,
              color: Colors.orange.shade700,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Aplikasi Tidak Tersedia',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                height: 1.4,
              ),
              children: [
                const TextSpan(text: 'Aplikasi '),
                TextSpan(
                  text: '"${widget.app.name}"',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(text: ' tidak ditemukan di komputer Anda.'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              children: [
                Icon(Icons.phone_in_talk, color: Colors.blue.shade700, size: 28),
                const SizedBox(height: 8),
                Text(
                  'Hubungi IT',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Ext. 000',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: _isHovered 
            ? (Matrix4.identity()..scale(1.05)) 
            : Matrix4.identity(),
        transformAlignment: FractionalOffset.center,
        child: InkWell(
          onTap: () async {
            if (widget.app.executablePath.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Path/URL untuk ${widget.app.name} belum diatur.')));
              return;
            }

            final path = widget.app.executablePath;
            if (path.startsWith('http://') || path.startsWith('https://')) {
              final url = Uri.parse(path);
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              } else {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Tidak bisa membuka link: $path')));
              }
            } else if (path.startsWith('\\\\')) {
              // UNC Path for network folder
              try {
                await Shell().run('start "" "$path"');
              } catch (e) {
                if (!context.mounted) return;
                _showAppNotFoundDialog();
              }
            } else {
              // Local executable file
              final file = File(path);
              if (!await file.exists()) {
                if (!context.mounted) return;
                _showAppNotFoundDialog();
                return;
              }
              
              try {
                await Process.run(path, [], runInShell: true, workingDirectory: file.parent.path);
              } catch (e) {
                debugPrint("Gagal menjalankan secara normal, mencoba dengan 'start' command: $e");
                try {
                  await Shell().run('start "" "$path"');
                } catch (e2) {
                  if (!context.mounted) return;
                  _showAppNotFoundDialog();
                }
              }
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: widget.app.borderColor, width: 1.5),
              borderRadius: BorderRadius.circular(12),
              boxShadow: _isHovered 
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [],
            ),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Expanded(
                child: Image.network(
                  widget.app.iconPath.replaceAll('localhost', serverIp),
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (c, e, s) =>
                      const Icon(Icons.image_not_supported, size: 48, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.app.name,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (widget.app.description != null && widget.app.description!.isNotEmpty)
                Text(
                  widget.app.description!,
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ]),
          ),
        ),
      ),
    );
  }
}