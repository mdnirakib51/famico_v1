import '../../../core_functionality/constants/api_helper.dart';
import '../../../core_functionality/constants/app_config.dart';
import '../../../core_functionality/network/http_client/request_handler.dart';
import '../../../core_functionality/storage/storage_controller.dart';
import '../../../initializer.dart';
import 'model/address_list_model.dart';

class AddressRepository extends ApiHelper {
  AddressRepository() : super(
    requestHandler: locator<RequestHandler>(),
    storage: locator<LocalStorageService>(),
  );

  Future reqCreateAddress({
    required String street,
    required String city,
    required String state,
    required String zip,
    required String country,
    required String addressType,
  }) async {
    final Map<String, dynamic> params = {
      'street': street,
      'city': city,
      'state': state,
      'zip': zip,
      'country': country,
      'addressType': addressType,
    };

    final response = await requestHandler.postWrp('${AppConfig.addressUrl.url}/add', params);
    if (response.code == 200 || response.code == 201) {
      return response.data ?? {};
    }
    throw Exception('Failed with code ${response.code}: ${response.message}');
  }

  Future<AddressListModel> getAllAddress() async {
    final response = await requestHandler.getWrp('${AppConfig.addressUrl.url}/all');
    if (response.code == 200 || response.code == 201) {
      return AddressListModel.fromJson(response.data ?? {});
    }
    throw Exception('Response failed with code ${response.code}: ${response.message}');
  }

  Future reqEditAddress({
    required String addressId,
    required String street,
    required String city,
    required String state,
    required String zip,
    required String country,
    required String addressType,
  }) async {
    final Map<String, dynamic> params = {
      'street': street,
      'city': city,
      'state': state,
      'zip': zip,
      'country': country,
      'addressType': addressType,
    };

    final response = await requestHandler.putWrp(
      '${AppConfig.addressUrl.url}/update/$addressId',
      params,
    );
    if (response.code == 200 || response.code == 201) {
      return response.data ?? {};
    }
    throw Exception('Failed with code ${response.code}: ${response.message}');
  }

  Future reqRemoveAddress({required String addressId}) async {
    final response = await requestHandler.deleteWrp(
      '${AppConfig.addressUrl.url}/delete/$addressId',
    );
    if (response.code == 200 || response.code == 201) {
      return response.data ?? {};
    }
    throw Exception('Failed with code ${response.code}: ${response.message}');
  }
}