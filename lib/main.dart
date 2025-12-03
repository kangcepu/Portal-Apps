import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'screens/initial_page.dart';
import 'services/api_service.dart';
import 'utils/pc_id_utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  
  await reportInstallationToServer();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(1280, 800),
    minimumSize: Size(1024, 768),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    title: "Utama Portal",
    titleBarStyle: TitleBarStyle.hidden,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const MyApp());
}

Future<void> reportInstallationToServer() async {
  String? pcId = await getUniquePcId();
  if (pcId != null) {
    debugPrint("Melaporkan instalasi untuk PC_ID: $pcId");
    await apiService.reportInstallation(pcId);
  } else {
    debugPrint("Tidak bisa mendapatkan ID unik PC, pelaporan instalasi dibatalkan.");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const InitialPage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: 'Segoe UI',
          primaryColor: Colors.red.shade700,
          scaffoldBackgroundColor: const Color(0xFFF0F2F5)),
    );
  }
}