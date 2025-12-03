import 'package:flutter/material.dart';
import '../config/constants.dart';
import 'initial_page.dart';

class HelpPage extends StatelessWidget {
  final String imagePath;
  const HelpPage({super.key, required this.imagePath});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          InteractiveViewer(
            panEnabled: true,
            minScale: 0.5,
            maxScale: 4,
            child: Center(
              child: Image.network(
                imagePath.replaceAll('localhost', serverIp),
                fit: BoxFit.contain,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) =>
                    const Center(child: Icon(Icons.broken_image, color: Colors.white, size: 64)),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 32),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const InitialPage()));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}