
import '../../../../core_functionality/constants/api_helper.dart';
import '../../../../core_functionality/constants/app_config.dart';
import '../../../../core_functionality/network/http_client/request_handler.dart';
import '../../../../core_functionality/storage/storage_controller.dart';
import '../../../../initializer.dart';
import '../model/family_member_model.dart';
import '../model/family_name_model.dart';
import '../model/family_tree_model.dart';
import '../model/relation_ship_model.dart';

class FamilyRepository extends ApiHelper {
  FamilyRepository()
      : super(
    requestHandler: locator<RequestHandler>(),
    storage: locator<LocalStorageService>(),
  );

  // ── Family Name ────────────────────────────────────────────────────────────
  Future reqCreateFamilyName({required String familyName}) async {
    final response = await requestHandler.postWrp(AppConfig.familyNameUrl.url, {'family_name': familyName});
    if (response.code == 200 || response.code == 201) return response.data ?? {};
    throw Exception(response.message);
  }

  Future<FamilyNameModel> getAllFamilyName() async {
    final response = await requestHandler.getWrp(AppConfig.familyNameUrl.url);
    if (response.code == 200 || response.code == 201) {
      return FamilyNameModel.fromJson(response.data ?? {});
    }
    throw Exception(response.message);
  }

  // ── Family Member ──────────────────────────────────────────────────────────
  Future reqCreateFamilyMember({
    required int familyId,
    required String name,
    required String dob,
    required String phone,
    String? email,
    String? status,
    required String presentStreet,
    required String presentCity,
    required String presentState,
    required String presentZip,
    required String presentCountry,
    required String permanentStreet,
    required String permanentCity,
    required String permanentState,
    required String permanentZip,
    required String permanentCountry,
  }) async {
    final Map<String, dynamic> params = {
      'family_id': familyId,
      'name': name,
      'dob': dob,
      'phone': phone,
      'email': ?email,
      'status': ?status,
      'present_address': {
        'street': presentStreet,
        'city': presentCity,
        'state': presentState,
        'zip': presentZip,
        'country': presentCountry,
      },
      'permanent_address': {
        'street': permanentStreet,
        'city': permanentCity,
        'state': permanentState,
        'zip': permanentZip,
        'country': permanentCountry,
      },
    };

    final response = await requestHandler.postWrp(AppConfig.familyMemberUrl.url, params);
    if (response.code == 200 || response.code == 201) return response.data ?? {};
    throw Exception(response.message);
  }

  Future<FamilyMemberModel> getFamilyMember({int? familyId}) async {
    final url = familyId != null ? '${AppConfig.familyMemberUrl.url}?family_id=$familyId' : AppConfig.familyMemberUrl.url;
    final response = await requestHandler.getWrp(url);
    if (response.code == 200 || response.code == 201) {
      return FamilyMemberModel.fromJson(response.data ?? {});
    }
    throw Exception(response.message);
  }

  // ── Relationship ───────────────────────────────────────────────────────────

  /// Relation type list — sibling, parent, spouse etc. → relation_id
  Future<RelationShipModel> getRelationShip() async {
    final response = await requestHandler.getWrp(AppConfig.relationShipUrl.url);
    if (response.code == 200 || response.code == 201) {
      return RelationShipModel.fromJson(response.data ?? {});
    }
    throw Exception(response.message);
  }

  /// Relation nature list — direct/indirect etc. → relationship_id
  Future<RelationShipModel> getRelation() async {
    final response = await requestHandler.getWrp(AppConfig.relationUrl.url);
    if (response.code == 200 || response.code == 201) {
      return RelationShipModel.fromJson(response.data ?? {});
    }
    throw Exception(response.message);
  }

  /// Make relationship between two members
  Future reqMakeRelationship({
    required int familyId,
    required int memberId,
    required int relativeId,
    required int relationId,
    required int relationshipId,
  }) async {
    final Map<String, dynamic> params = {
      'family_id': familyId,
      'member_id': memberId,
      'relative_id': relativeId,
      'relation_id': relationId,
      'relationship_id': relationshipId,
    };

    final response = await requestHandler.postWrp(AppConfig.makeRelationshipUrl.url, params);
    if (response.code == 200 || response.code == 201) return response.data ?? {};
    throw Exception(response.message);
  }

  Future<FamilyTreeModel> getFamilyTree() async {
    final response = await requestHandler.getWrp(AppConfig.familyTreeUrl.url);
    if (response.code == 200 || response.code == 201) {
      return FamilyTreeModel.fromJson(response.data ?? {});
    }
    throw Exception(response.message);
  }
}