import 'package:flutter/material.dart';
import '../../core_functionality/constants/image_url_helper.dart';
import '../../core_functionality/storage/storage_controller.dart';
import '../../initializer.dart';
import '../global_widget/global_image_loader.dart';

/// Authenticated network image using GlobalImageLoader.
/// Automatically attaches Bearer token header.
///
/// Usage as Widget:
///   AuthNetworkImage.widget(profile.image, height: 50, width: 50)
///
/// Usage as ImageProvider (for CircleAvatar backgroundImage):
///   AuthNetworkImage.provider(profile.image)
class AuthNetworkImage {
  static Map<String, String> _authHeaders() {
    final token = locator<LocalStorageService>().accessToken ?? '';
    return token.isNotEmpty ? {'Authorization': 'Bearer $token'} : {};
  }

  /// Returns a GlobalImageLoader widget with auth headers
  static Widget widget(String? path, {
        double? height,
        double? width,
        BoxFit? fit,
        Color? color,
        String? errorImg,
      }) {
    if (!ImageUrlHelper.isValid(path)) {
      return const SizedBox.shrink();
    }

    return GlobalImageLoader(
      imagePath: ImageUrlHelper.resolve(path),
      imageFor: ImageFor.network,
      height: height,
      width: width,
      fit: fit,
      color: color,
      errorImg: errorImg,
      // headers: _authHeaders(),
    );
  }

  /// Returns an ImageProvider with auth headers (for CircleAvatar)
  static ImageProvider? provider(String? path) {
    if (!ImageUrlHelper.isValid(path)) return null;

    return NetworkImage(
      ImageUrlHelper.resolve(path),
      headers: _authHeaders(),
    );
  }
}