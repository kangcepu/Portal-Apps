import 'package:flutter/material.dart';
import 'base_portal_page.dart';

class CreativePage extends StatelessWidget {
  const CreativePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePortalPage(
      category: 'creative',
      title: 'CREATIVE PORTAL',
      titleColor: Colors.green.shade800,
      backgroundAsset: 'assets/bg/portal.svg',
      backgroundColor: const Color(0xFFE3F2FD),
    );
  }
}