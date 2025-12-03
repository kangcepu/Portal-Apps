import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../config/constants.dart';
import '../models/app_model.dart';

class ApiService {
  Future<Map<String, dynamic>?> fetchData() async {
    try {
      final response = await http
          .get(Uri.parse('$serverUrl/data'))
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      debugPrint("Error fetching data: $e");
    }
    return null;
  }

  Future<bool> saveAllApps(List<AppModel> apps) async {
    try {
      final response = await http.post(
        Uri.parse('$serverUrl/apps'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
            {'applications': apps.map((app) => app.toJson()).toList()}),
      );
      return response.statusCode == 201;
    } catch (e) {
      debugPrint("Error saving apps: $e");
      return false;
    }
  }

  Future<bool> updateSettings(Map<String, String> settingsToUpdate) async {
    try {
      final response = await http.put(
        Uri.parse('$serverUrl/settings'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(settingsToUpdate),
      );
      return response.statusCode == 200;
    } catch (e) {
      debugPrint("Error updating settings: $e");
      return false;
    }
  }

  Future<String?> uploadIcon(String filePath) async {
    try {
      var request =
          http.MultipartRequest('POST', Uri.parse('$serverUrl/upload/icon'));
      request.files
          .add(await http.MultipartFile.fromPath('iconFile', filePath));
      var res = await request.send();
      if (res.statusCode == 200) {
        final responseBody = await res.stream.bytesToString();
        return jsonDecode(responseBody)['iconUrl'];
      }
    } catch (e) {
      debugPrint("Error uploading icon: $e");
    }
    return null;
  }

  Future<void> reportInstallation(String pcId) async {
    try {
      await http
          .post(
            Uri.parse('$serverUrl/installs/ping'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'pc_id': pcId}),
          )
          .timeout(const Duration(seconds: 5));
    } catch (e) {
      debugPrint("Failed to report installation: $e");
    }
  }

  Future<int> getInstallCount() async {
    try {
      final response = await http.get(Uri.parse('$serverUrl/installs/count'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['total_installs'];
      }
    } catch (e) {
      debugPrint("Error fetching install count: $e");
    }
    return 0;
  }

  Future<Map<String, dynamic>?> getLatestAppVersion() async {
    try {
      final response = await http.get(Uri.parse('$serverUrl/app-version'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      debugPrint("Error fetching app version: $e");
    }
    return null;
  }

  Future<String?> uploadHelpImage(String filePath) async {
    try {
      var request = http.MultipartRequest(
          'POST', Uri.parse('$serverUrl/upload/help-image'));
      request.files
          .add(await http.MultipartFile.fromPath('helpImageFile', filePath));
      var res = await request.send();
      if (res.statusCode == 200) {
        final responseBody = await res.stream.bytesToString();
        return jsonDecode(responseBody)['imageUrl'];
      }
    } catch (e) {
      debugPrint("Error uploading help image: $e");
    }
    return null;
  }

  Future<List<Map<String, dynamic>>?> getCategories() async {
    try {
      final response = await http.get(Uri.parse('$serverUrl/categories'));
      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      }
    } catch (e) {
      debugPrint("Error fetching categories: $e");
    }
    return null;
  }

  Future<bool> saveCategory(Map<String, dynamic> category) async {
    try {
      final response = await http.post(
        Uri.parse('$serverUrl/categories'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(category),
      );
      return response.statusCode == 201;
    } catch (e) {
      debugPrint("Error saving category: $e");
      return false;
    }
  }

  Future<bool> deleteCategory(int id) async {
    try {
      final response = await http.delete(Uri.parse('$serverUrl/categories/$id'));
      return response.statusCode == 200;
    } catch (e) {
      debugPrint("Error deleting category: $e");
      return false;
    }
  }
}

// Instance global
final apiService = ApiService();