import 'package:flutter/material.dart';
import 'base_portal_page.dart';

class TaxPage extends StatelessWidget {
  const TaxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePortalPage(
      category: 'tax',
      title: 'TAX PORTAL',
      titleColor: Colors.purple.shade800,
      backgroundAsset: 'assets/bg/portal.svg',
      backgroundColor: const Color(0xFFE3F2FD),
    );
  }
}