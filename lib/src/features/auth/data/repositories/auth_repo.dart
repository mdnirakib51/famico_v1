
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
    params['passwordHash'] = password;

    final response = await requestHandler.postWrp(AppConfig.logInUrl.url, params);
    if(response.status == '200' || response.status == '201' || response.isSuccess){
      return AuthModel.fromJson(response.data ?? {});
    }
    throw Exception('Login 1 failed with code ${response.code}: ${response.message}');
  }

  Future<AuthModel> reqRegistration({
    required String? username,
    required String? phone,
    String? email,
    required String? password
  }) async {

    Map<String, dynamic> params = {};
    params['username'] = username;
    params['phone'] = phone;
    params['email'] = email;
    params['passwordHash'] = password;
    params['verificationStatus'] = true;

    final response = await requestHandler.postWrp(AppConfig.registrationUrl.url, params);
    if(response.code == 200 || response.code == 201){
      return AuthModel.fromJson(response.data ?? {});
    }
    throw Exception('Registration failed with code ${response.code}: ${response.message}');
  }

  Future<AuthModel> reqSendOtp({
    required String? phoneEmail,
  }) async {

    Map<String, dynamic> params = {};
    params['phoneEmail'] = phoneEmail;
    params['verificationStatus'] = true;

    final response = await requestHandler.postWrp(AppConfig.forgetPasUrl.url, params);
    if(response.status == '200' || response.status == '201'){
      return AuthModel.fromJson(response.data ?? {});
    }
    throw Exception('Login failed with code ${response.code}: ${response.message}');
  }

  Future<AuthModel> reqResetPass({
    required String? phoneEmail,
    required String? password
  }) async {

    Map<String, dynamic> params = {};
    params['phoneEmail'] = phoneEmail;
    params['password'] = password;

    final response = await requestHandler.postWrp(AppConfig.resetPassUrl.url, params);
    if(response.status == '200' || response.status == '201'){
      return AuthModel.fromJson(response.data ?? {});
    }
    throw Exception('Login failed with code ${response.code}: ${response.message}');
  }

}