import '../../../../core_functionality/constants/api_helper.dart';
import '../../../../core_functionality/constants/app_config.dart';
import '../../../../core_functionality/network/http_client/request_handler.dart';
import '../../../../core_functionality/storage/storage_controller.dart';
import '../../../../initializer.dart';
import '../model/family_name_model.dart';

class FamilyRepository extends ApiHelper {
  FamilyRepository() : super(
    requestHandler: locator<RequestHandler>(),
    storage: locator<LocalStorageService>(),
  );

  Future reqCreateFamilyName({
    required String familyName,
    required String city,
    required String state,
    required String zip,
    required String country,
    required String addressType,
  }) async {
    final Map<String, dynamic> params = {
      'family_name': familyName,
    };

    final response = await requestHandler.postWrp(AppConfig.familyNameUrl.url, params);
    if (response.code == 200 || response.code == 201) {
      return response.data ?? {};
    }
    throw Exception(response.message);
  }

  Future<FamilyNameModel> getAllFamilyName() async {
    final response = await requestHandler.getWrp(AppConfig.familyNameUrl.url);
    if (response.code == 200 || response.code == 201) {
      return FamilyNameModel.fromJson(response.data ?? {});
    }
    throw Exception(response.message);
  }

}