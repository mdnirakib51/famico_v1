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
}