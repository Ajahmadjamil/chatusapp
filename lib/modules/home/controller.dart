import 'dart:io';
import 'dart:convert';
import 'package:chatus/core/local/shared_pref.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:chatus/services/api_end_points.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:chatus/core/constants/app_constants.dart';
import 'package:chatus/core/widgets/custom_alert_dialog.dart';

class HomeController extends GetxController {
  final ApiEndPoints _apiEndPoints = ApiEndPoints();
  File? imageFile;
  final RxList<String> imageUrls = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      update();
    }
  }

  Future<void> uploadImage() async {
    if (imageFile == null) {
      Get.snackbar("Error", "No image selected.", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final request = http.MultipartRequest('POST', _apiEndPoints.cloudinaryUploadUrl)
      ..fields['upload_preset'] = 'upload_images'
      ..files.add(await http.MultipartFile.fromPath('file', imageFile!.path));

    try {
      final response = await request.send();
      final responseString = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        Get.snackbar("Success", "Image Uploaded", snackPosition: SnackPosition.BOTTOM);
        final jsonMap = jsonDecode(responseString);
        print("Upload Response: $jsonMap");
        final String? assetFolder = jsonMap['asset_folder'];
        if (assetFolder != null && assetFolder.isNotEmpty) {
          await fetchImagesFromCloudinaryFolder(assetFolder);
        }
      } else {
        Get.snackbar("Upload Failed", "Error: ${response.statusCode}", snackPosition: SnackPosition.BOTTOM);
        print("Error uploading image. Status: ${response.statusCode}, Body: $responseString");
      }
    } catch (e) {
      Get.snackbar("Upload Error", "An exception occurred: $e", snackPosition: SnackPosition.BOTTOM);
      print("Exception during image upload: $e");
    }
  }

  Future<void> fetchImagesFromCloudinaryFolder(String folderName) async {
    if (AppConstants.cloudinaryApiKey.isEmpty || AppConstants.cloudinaryApiSecret.isEmpty) {
      Get.snackbar(
        "Config Error",
        "API Key/Secret not set.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final auth =
        'Basic ${base64Encode(utf8.encode('${AppConstants.cloudinaryApiKey}:${AppConstants.cloudinaryApiSecret}'))}';

    final res = await http.post(
      _apiEndPoints.cloudinarySearchUrl,
      headers: {"Authorization": auth, "Content-Type": "application/json"},
      body: jsonEncode({"expression": 'asset_folder:"$folderName"', "max_results": 50}),
    );

    if (res.statusCode != 200) {
      Get.snackbar("Fetch Error", "Failed to fetch images: ${res.statusCode}", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final resources = (jsonDecode(res.body)["resources"] as List?) ?? [];
    imageUrls.value = resources.map((r) => r["secure_url"] ?? r["url"]).whereType<String>().toList();

    Get.snackbar(
      imageUrls.isEmpty ? "Info" : "Success",
      imageUrls.isEmpty ? "No images found in '$folderName'." : "${imageUrls.length} images loaded from '$folderName'.",
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> confirmLogout() async {
    Get.dialog(
      CustomConfirmationDialog(
        // title: "Confirm Logout",
        message: "Are you sure you want to log out?",
        onConfirm: () async {
          Get.back();
          // Clear local authentication state
          await SharedPref.clearUserData();
          // Sign out from Supabase
          await Supabase.instance.client.auth.signOut();
          Get.offAllNamed('/login');
        },
        onCancel: () {
          Get.back();
        },
      ),
    );
  }
}
