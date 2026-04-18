import '../../../../core_functionality/constants/api_helper.dart';
import '../../../../core_functionality/constants/app_config.dart';
import '../../../../core_functionality/network/http_client/request_handler.dart';
import '../../../../core_functionality/storage/storage_controller.dart';
import '../../../../initializer.dart';
import '../model/family_name_model.dart';
import '../model/relation_model.dart';
import '../model/relation_ship_model.dart';

class FamilyRepository extends ApiHelper {
  FamilyRepository() : super(
    requestHandler: locator<RequestHandler>(),
    storage: locator<LocalStorageService>(),
  );

  Future reqCreateFamilyName({
    required String familyName,
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

  Future<RelationModel> getFamilyMember() async {
    final response = await requestHandler.getWrp(AppConfig.familyMemberUrl.url);
    if (response.code == 200 || response.code == 201) {
      return RelationModel.fromJson(response.data ?? {});
    }
    throw Exception(response.message);
  }

  Future<RelationShipModel> getRelationShip() async {
    final response = await requestHandler.getWrp(AppConfig.relationShipUrl.url);
    if (response.code == 200 || response.code == 201) {
      return RelationShipModel.fromJson(response.data ?? {});
    }
    throw Exception(response.message);
  }

  Future<RelationShipModel> getRelation() async {
    final response = await requestHandler.getWrp(AppConfig.familyNameUrl.url);
    if (response.code == 200 || response.code == 201) {
      return RelationShipModel.fromJson(response.data ?? {});
    }
    throw Exception(response.message);
  }

}