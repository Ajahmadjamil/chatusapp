import 'package:chatus/core/constants/app_constants.dart';

class ApiEndPoints {
  final Uri cloudinaryUploadUrl = Uri.parse(
    "https://api.cloudinary.com/v1_1/${AppConstants.cloudinaryCloudName}/image/upload",
  );

  static const String cloudinarySearchApiAuthority = "api.cloudinary.com";
  static String get cloudinarySearchApiPath =>
      '/v1_1/${AppConstants.cloudinaryCloudName}/resources/search';

  Uri get cloudinarySearchUrl =>
      Uri.https(cloudinarySearchApiAuthority, cloudinarySearchApiPath);
  Uri get cloudinary => cloudinaryUploadUrl;
}
