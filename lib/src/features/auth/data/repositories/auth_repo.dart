
import '../../../../core_functionality/constants/api_helper.dart';
import '../../../../core_functionality/constants/app_config.dart';
import '../models/auth_model.dart';
import '../../../../core_functionality/network/http_client/request_handler.dart';
import '../../../../core_functionality/storage/storage_controller.dart';
import '../../../../initializer.dart';

class AuthRepository extends ApiHelper {
  AuthRepository() : super(
    requestHandler: locator<RequestHandler>(),
    storage: locator<LocalStorageService>(),
  );

  Future<AuthModel> reqLogIn({
    required String? email,
    required String? password
  }) async {

    Map<String, dynamic> params = {};
    params['email'] = email;
    params['password'] = password;

    final response = await requestHandler.postWrp(AppConfig.logInUrl.url, params);
    if(response.status == '200' || response.status == '201' || response.isSuccess){
      return AuthModel.fromJson(response.data ?? {});
    }
    throw Exception(response.message);
  }

  Future<AuthModel> reqRegistration({
    required String? username,
    required String? dialCode,
    required String? phone,
    required String? email,
    required String? password
  }) async {

    Map<String, dynamic> params = {};
    params['username'] = username;
    params['dial_code'] = dialCode;
    params['phone'] = phone;
    params['email'] = email;
    params['password'] = password;

    final response = await requestHandler.postWrp(AppConfig.registrationUrl.url, params);
    if(response.code == 200 || response.code == 201){
      return AuthModel.fromJson(response.data ?? {});
    }
    throw Exception(response.message);
  }

  Future<void> reqForgetPass({
    required String email,
    int? otp,
    String? newPassword,
  }) async {

    Map<String, dynamic> params = {};
    params['email'] = email;
    if (otp != null) params['otp'] = otp;
    if (newPassword != null) params['new_password'] = newPassword;

    final response = await requestHandler.postWrp(AppConfig.forgetPasUrl.url, params);
    if (response.status == '200' || response.status == '201' || response.isSuccess) {
      return;
    }
    throw Exception(response.message);
  }

}