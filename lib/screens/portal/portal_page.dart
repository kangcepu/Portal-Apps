import 'package:flutter/material.dart';
import 'base_portal_page.dart';

class PortalPage extends StatelessWidget {
  const PortalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const BasePortalPage(
      category: 'portal',
      title: 'PORTAL',
      titleColor: Colors.black,
      backgroundAsset: 'assets/bg/portal.svg',
      backgroundColor: Color(0xFFE3F2FD),
    );
  }
}