import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:chatus/core/local/shared_pref.dart';
import 'package:chatus/services/api_end_points.dart';
import 'package:chatus/features/auth/login/screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:chatus/core/constants/app_constants.dart';
import 'package:chatus/core/widgets/custom_alert_dialog.dart';

class HomeController extends ChangeNotifier {
  final ApiEndPoints _apiEndPoints = ApiEndPoints();
  final supabase = Supabase.instance.client;

  File? _imageFile;
  File? get imageFile => _imageFile;

  List<String> _imageUrls = [];
  List<String> get imageUrls => _imageUrls;

  List<dynamic> chats = [];
  bool isLoading = false;

  RealtimeChannel? channel;
  bool _isListening = false;

  Timer? _reloadTimer; // *** debounce scheduler ***

  // ======================
  // LOAD CHATS (DEBOUNCED)
  // ======================
  Future loadChats() async {
    isLoading = true;
    notifyListeners();

    final userId = supabase.auth.currentUser!.id;

    final result = await supabase
        .from('chats')
        .select('*, chat_participants(*), messages(*)')
        .order('updated_at', ascending: false);

    // Only chats where this user is a participant
    chats = result.where((c) {
      final participants = c['chat_participants'] as List;
      return participants.any((p) => p['user_id'] == userId);
    }).toList();

    isLoading = false;
    notifyListeners();
  }

  // Debounce real-time reload to prevent spam
  void _debounceReload() {
    _reloadTimer?.cancel();
    _reloadTimer = Timer(const Duration(milliseconds: 350), () {
      loadChats();
    });
  }

  // ==================================
  // REALTIME LISTENER (ONLY RUN ONCE)
  // ==================================
  void listenRealTime() {
    if (_isListening) return;
    _isListening = true;

    final supabase = Supabase.instance.client;

    channel = supabase.channel('public:chats')
      ..onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        table: 'chats',
        callback: (payload) {
          _debounceReload(); // FIX: Prevent too many reloads
        },
      )
      ..subscribe();
  }

  // ===============
  // DISPOSE
  // ===============
  @override
  void dispose() {
    channel?.unsubscribe();
    _reloadTimer?.cancel();
    super.dispose();
  }

  // ========================
  // PICK IMAGE
  // ========================
  Future<void> pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      _imageFile = File(pickedFile.path);
      notifyListeners();
    }
  }

  // -----------------------
  // SNACKBAR
  // -----------------------
  void _showSnackBar(
      BuildContext context,
      String message, {
        bool isError = false,
      }) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ========================
  // UPLOAD IMAGE
  // ========================
  Future<void> uploadImage(BuildContext context) async {
    if (_imageFile == null) {
      _showSnackBar(context, "No image selected.", isError: true);
      return;
    }

    final request =
    http.MultipartRequest('POST', _apiEndPoints.cloudinaryUploadUrl)
      ..fields['upload_preset'] = 'upload_images'
      ..files.add(await http.MultipartFile.fromPath('file', _imageFile!.path));

    try {
      final response = await request.send();
      final responseString = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        if (context.mounted) {
          _showSnackBar(context, "Image Uploaded Successfully");
        }

        final jsonMap = jsonDecode(responseString);
        final String? assetFolder = jsonMap['asset_folder'];

        if (assetFolder != null && assetFolder.isNotEmpty) {
          if (context.mounted) {
            await fetchImagesFromCloudinaryFolder(context, assetFolder);
          }
        }
      } else {
        if (context.mounted) {
          _showSnackBar(context, "Error: ${response.statusCode}", isError: true);
        }
        print("Error uploading: ${response.statusCode}, Body: $responseString");
      }
    } catch (e) {
      if (context.mounted) {
        _showSnackBar(context, "Exception: $e", isError: true);
      }
      print("Upload exception: $e");
    }
  }

  // ========================
  // FETCH CLOUDINARY IMAGES
  // ========================
  Future<void> fetchImagesFromCloudinaryFolder(
      BuildContext context,
      String folderName,
      ) async {
    if (AppConstants.cloudinaryApiKey.isEmpty ||
        AppConstants.cloudinaryApiSecret.isEmpty) {
      _showSnackBar(context, "API Key/Secret not set.", isError: true);
      return;
    }

    final auth = 'Basic ${base64Encode(
      utf8.encode('${AppConstants.cloudinaryApiKey}:${AppConstants.cloudinaryApiSecret}'),
    )}';

    try {
      final res = await http.post(
        _apiEndPoints.cloudinarySearchUrl,
        headers: {"Authorization": auth, "Content-Type": "application/json"},
        body: jsonEncode({
          "expression": 'asset_folder:"$folderName"',
          "max_results": 50,
        }),
      );

      if (res.statusCode != 200) {
        if (context.mounted) {
          _showSnackBar(context, "Failed to fetch images: ${res.statusCode}",
              isError: true);
        }
        return;
      }

      final resources = (jsonDecode(res.body)["resources"] as List?) ?? [];

      _imageUrls = resources
          .map((r) => r["secure_url"] ?? r["url"])
          .whereType<String>()
          .toList();

      notifyListeners();

      if (context.mounted) {
        _showSnackBar(
            context,
            _imageUrls.isEmpty
                ? "No images in '$folderName'."
                : "${_imageUrls.length} images loaded.");
      }
    } catch (e) {
      if (context.mounted) {
        _showSnackBar(context, "Error: $e", isError: true);
      }
    }
  }

  // ========================
  // LOGOUT
  // ========================
  Future<void> confirmLogout(BuildContext context) async {
    showDialog(
      context: context,
      builder: (dialogContext) => CustomConfirmationDialog(
        message: "Are you sure you want to log out?",
        onConfirm: () async {
          Navigator.of(dialogContext).pop();
          await SharedPref.clearUserData();
          await Supabase.instance.client.auth.signOut();

          if (context.mounted) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => LoginScreen()),
                  (route) => false,
            );
          }
        },
        onCancel: () => Navigator.of(dialogContext).pop(),
      ),
    );
  }
}
