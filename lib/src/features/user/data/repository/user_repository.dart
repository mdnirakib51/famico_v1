import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core_functionality/constants/api_helper.dart';
import '../../../../core_functionality/constants/app_config.dart';
import '../../../../core_functionality/network/http_client/request_handler.dart';
import '../../../../core_functionality/storage/storage_controller.dart';
import '../../../../initializer.dart';
import '../model/profile_model.dart';

class UserRepository extends ApiHelper {
  UserRepository() : super(
    requestHandler: locator<RequestHandler>(),
    storage: locator<LocalStorageService>(),
  );

  Future<ProfileModel> getUserProfile() async {
    final response = await requestHandler.getWrp(AppConfig.userProfileUrl.url);
    if (response.code == 200 || response.code == 201) {
      return ProfileModel.fromJson(response.data ?? {});
    }
    throw Exception('Response failed with code ${response.code}: ${response.message}');
  }

  Future<ProfileModel> reqUpdateProfile({
    required String username,
    required String name,
    required String dialCode,
    required String email,
    required String phone,
    required String gender,
    required String dob,
    required int age,
  }) async {
    final Map<String, dynamic> params = {
      'username': username,
      'name': name,
      'dial_code': dialCode,
      'email': email,
      'phone': phone,
      'gender': gender,
      'dob': dob,
      'age': age,
    };

    final response = await requestHandler.patchWrp(AppConfig.updateProfileUrl.url, params);
    if (response.code == 200 || response.code == 201) {
      return ProfileModel.fromJson(response.data ?? {});
    }
    throw Exception(response.message);
  }

  /// =/@ Product List Method..
  Future reqUploadDoc({
    XFile? imagePath,
    XFile? nidPath,
  }) async {
    MultipartFile? imagePathMul = imagePath != null ? await MultipartFile.fromFile(imagePath.path) : null;
    MultipartFile? nidPathMul = nidPath != null ? await MultipartFile.fromFile(nidPath.path) : null;

    final Map<String, dynamic> params = {};
    if (imagePathMul != null) params['image'] = imagePathMul;
    if (nidPathMul != null) params['nid'] = nidPathMul;

    final response = await requestHandler.postWrp(AppConfig.uploadDocUrl.url, params, isFormData: true);
    if (response.code == 200 || response.code == 201) {
      return response.data ?? {};
    }
    throw Exception('Response failed with code ${response.code}: ${response.message}');
  }

}