
import '../../../core_functionality/constants/api_helper.dart';
import '../../../core_functionality/constants/app_config.dart';
import 'auth_model.dart';

class AuthRepository extends ApiHelper {

  Future<AuthModel> reqLogIn({
    required String? email,
    required String? password
  }) async {

    Map<String, dynamic> params = {};
    params['email'] = email;
    params['passwordHash'] = password;

    final response = await requestHandler.postWrp(AppConfig.logInUrl.url, params, isFormData: true);
    if(response.code == 200 || response.code == 201){
      return AuthModel.fromJson(response.data ?? {});
    }

    throw Exception('Login failed with code ${response.code}: ${response.message}');
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

    final response = await requestHandler.postWrp(AppConfig.logInUrl.url, params, isFormData: true);
    if(response.code == 200 || response.code == 201){
      return AuthModel.fromJson(response.data ?? {});
    }

    throw Exception('Login failed with code ${response.code}: ${response.message}');
  }

}
