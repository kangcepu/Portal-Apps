import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:process_run/shell.dart';

Future<String?> getUniquePcId() async {
  if (!Platform.isWindows) {
    debugPrint("Bukan platform Windows, skip pengambilan ID.");
    return null;
  }

  final shell = Shell();
  String? finalId;

  // --- Cara 1: Coba Ambil Serial Number Motherboard (Pilihan Terbaik) ---
  try {
    var result = await shell.run('wmic baseboard get serialnumber');
    var serialNumber = result.first.stdout.toString().split('\n')[1].trim();
    
    if (serialNumber.isNotEmpty && !serialNumber.contains("SerialNumber")) {
      debugPrint("ID Unik PC (Serial Number Motherboard) ditemukan: $serialNumber");
      finalId = serialNumber;
    }
  } catch (e) {
    debugPrint("Cara 1 (Serial Number) gagal: $e");
  }

  if (finalId == null || finalId.isEmpty) {
    debugPrint("Mencoba Cara 2: Mengambil UUID Hardware Sistem...");
    try {
      var result = await shell.run('wmic csproduct get uuid');
      var uuid = result.first.stdout.toString().split('\n')[1].trim();

      if (uuid.isNotEmpty && !uuid.contains("UUID")) {
        debugPrint("ID Unik PC (Hardware UUID) ditemukan: $uuid");
        finalId = uuid;
      }
    } catch (e) {
      debugPrint("Cara 2 (Hardware UUID) juga gagal: $e");
    }
  }

  if (finalId == null || finalId.isEmpty) {
    debugPrint("Semua cara untuk mendapatkan ID unik PC gagal.");
    return null;
  }

  return finalId;
}