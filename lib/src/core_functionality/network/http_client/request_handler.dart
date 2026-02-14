import 'dart:convert';
import 'dart:developer' show log;
import 'package:dio/dio.dart';
import 'package:famico_v1/src/core_functionality/constants/app_config.dart';
import 'package:flutter/cupertino.dart';
import '../../constants/api_constants.dart';
import '../../constants/storage_keys.dart';
import '../../errors/request_exception.dart';
import '../../storage/storage_controller.dart';
import '../api_check.dart';
import 'response_wrapper.dart';

class RequestHandler {
  final Dio _dio;
  final LocalStorageService _storage;

  RequestHandler({
    required Dio dio,
    required LocalStorageService storage,
  })  : _dio = dio,
        _storage = storage {
    _initialize();
  }

  /// Factory constructor for easy creation
  static Future<RequestHandler> create() async {
    final dio = Dio(BaseOptions(
      baseUrl: AppConfig.base.url,
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
      headers: {
        'Content-Type': ApiConstants.contentTypeJson,
        'Accept': ApiConstants.keepAlive,
      },
    ));

    final storage = await LocalStorageService.getInstance();

    return RequestHandler(dio: dio, storage: storage);
  }

  Dio get dio => _dio;
  String get mainUrl => AppConfig.base.url;

  /// Initialize headers with stored token
  void _initialize() {
    final currentToken = _storage.accessToken;

    if (currentToken != null) {
      log("==/@ Access Token Found: ${currentToken.substring(0, 20)}...");
      _updateDioHeaders(token: currentToken);
    } else {
      log("Token Not Found!!");
    }
  }

  /// Update Dio headers
  void _updateDioHeaders({required String token}) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
    _dio.options.headers['Connection'] = 'keep-alive';
  }

  /// Update token in both storage and headers
  Future<void> updateHeader({required String token}) async {
    await _storage.saveUserToken(token);
    _updateDioHeaders(token: token);
    log("#UpdatedHeader: TOKEN => ${token.substring(0, 20)}...");
  }

  /// POST Request
  Future<ResponseWrapper> postWrp(
      String url,
      dynamic params, {
        bool? isFormData = false,
        String? errorMsg,
        String? baseUrl,
        Options? options,
        Map<String, dynamic>? queryParams,
      }) async {
    _initialize();
    log(" === Start API POST Request === ");

    try {
      final formData = isFormData == true ? FormData.fromMap(params) : params;

      final response = await _dio.post(
        baseUrl ?? mainUrl + url,
        data: formData,
        queryParameters: queryParams,
        options: options,
      );

      _logResponse(
        method: "POST",
        url: response.realUri.toString(),
        params: params,
        statusCode: response.statusCode,
        responseData: response.data,
        isFormData: isFormData ?? false,
      );

      final Map<String, dynamic> responseData = _parseResponseData(response.data);
      ResponseWrapper resWrp = ResponseWrapper.fromJson(responseData);

      ApiChecker.checkApi(
        responseData['code'] ?? response.statusCode,
        responseData['message'] ?? 'Success',
      );

      return resWrp;
    } on DioException catch (error, stackTrace) {
      final responseData = _extractErrorData(error);

      throw RequestException(
        method: "POST",
        url: baseUrl ?? mainUrl + url,
        statusCode: responseData['code'],
        message: responseData['message'],
        data: params,
        error: error,
        trace: stackTrace,
        res: error.response,
        errorMsg: error.message,
      );
    } catch (error, stackTrace) {
      throw RequestException(
        method: "POST",
        url: baseUrl ?? mainUrl + url,
        message: errorMsg ?? error.toString(),
        data: params,
        error: error,
        trace: stackTrace,
      );
    }
  }

  /// GET Request
  Future<ResponseWrapper> getWrp(
      String url, {
        dynamic params,
        String? errorMsg,
        String? baseUrl,
        Options? options,
        Map<String, dynamic>? queryParams,
      }) async {
    _initialize();
    log(" === Start API GET Request === ");

    try {
      final response = await _dio.get(
        baseUrl ?? mainUrl + url,
        data: params,
        queryParameters: queryParams,
        options: options,
      );

      _logResponse(
        method: "GET",
        url: response.realUri.toString(),
        params: params,
        statusCode: response.statusCode,
        responseData: response.data,
      );

      final Map<String, dynamic> responseData = _parseResponseData(response.data);
      ResponseWrapper resWrp = ResponseWrapper.fromJson(responseData);

      return resWrp;
    } on DioException catch (error, stackTrace) {
      final responseData = _extractErrorData(error);

      throw RequestException(
        method: "GET",
        url: baseUrl ?? mainUrl + url,
        statusCode: responseData['code'],
        message: responseData['message'],
        data: params,
        error: error,
        trace: stackTrace,
        res: error.response,
        errorMsg: error.message,
      );
    } catch (error, stackTrace) {
      throw RequestException(
        method: "GET",
        url: baseUrl ?? mainUrl + url,
        message: errorMsg ?? error.toString(),
        data: params,
        error: error,
        trace: stackTrace,
      );
    }
  }

  /// PUT Request
  Future<ResponseWrapper> putWrp(
      String url,
      dynamic params, {
        bool? isFormData = false,
        String? errorMsg,
        String? baseUrl,
        Options? options,
        Map<String, dynamic>? queryParams,
      }) async {
    _initialize();
    log(" === Start API PUT Request === ");

    try {
      final formData = isFormData == true ? FormData.fromMap(params) : params;

      final response = await _dio.put(
        baseUrl ?? mainUrl + url,
        data: formData,
        queryParameters: queryParams,
        options: options,
      );

      _logResponse(
        method: "PUT",
        url: response.realUri.toString(),
        params: params,
        statusCode: response.statusCode,
        responseData: response.data,
        isFormData: isFormData ?? false,
      );

      final Map<String, dynamic> responseData = _parseResponseData(response.data);
      ResponseWrapper resWrp = ResponseWrapper.fromJson(responseData);

      ApiChecker.checkApi(
        responseData['code'] ?? response.statusCode,
        responseData['message'] ?? 'Success',
      );

      return resWrp;
    } on DioException catch (error, stackTrace) {
      final responseData = _extractErrorData(error);

      throw RequestException(
        method: "PUT",
        url: baseUrl ?? mainUrl + url,
        statusCode: responseData['code'],
        message: responseData['message'],
        data: params,
        error: error,
        trace: stackTrace,
        res: error.response,
        errorMsg: error.message,
      );
    } catch (error, stackTrace) {
      throw RequestException(
        method: "PUT",
        url: baseUrl ?? mainUrl + url,
        message: errorMsg ?? error.toString(),
        data: params,
        error: error,
        trace: stackTrace,
      );
    }
  }

  /// DELETE Request
  Future<ResponseWrapper> deleteWrp(
      String url, {
        dynamic params,
        String? errorMsg,
        String? baseUrl,
        Options? options,
        Map<String, dynamic>? queryParams,
      }) async {
    _initialize();
    log(" === Start API DELETE Request === ");

    try {
      final response = await _dio.delete(
        baseUrl ?? mainUrl + url,
        data: params,
        queryParameters: queryParams,
        options: options,
      );

      _logResponse(
        method: "DELETE",
        url: response.realUri.toString(),
        params: params,
        statusCode: response.statusCode,
        responseData: response.data,
      );

      final Map<String, dynamic> responseData = _parseResponseData(response.data);
      ResponseWrapper resWrp = ResponseWrapper.fromJson(responseData);

      ApiChecker.checkApi(
        responseData['code'] ?? response.statusCode,
        responseData['message'] ?? 'Success',
      );

      return resWrp;
    } on DioException catch (error, stackTrace) {
      final responseData = _extractErrorData(error);

      throw RequestException(
        method: "DELETE",
        url: baseUrl ?? mainUrl + url,
        statusCode: responseData['code'],
        message: responseData['message'],
        data: params,
        error: error,
        trace: stackTrace,
        res: error.response,
        errorMsg: error.message,
      );
    } catch (error, stackTrace) {
      throw RequestException(
        method: "DELETE",
        url: baseUrl ?? mainUrl + url,
        message: errorMsg ?? error.toString(),
        data: params,
        error: error,
        trace: stackTrace,
      );
    }
  }

  /// Helper: Parse response data
  Map<String, dynamic> _parseResponseData(dynamic data) {
    if (data is String) {
      return jsonDecode(data);
    } else if (data is Map<String, dynamic>) {
      return data;
    } else {
      return {'data': data};
    }
  }

  /// Helper: Extract error data from DioException
  Map<String, dynamic> _extractErrorData(DioException error) {
    try {
      final data = error.response?.data;
      if (data is String) {
        return jsonDecode(data);
      } else if (data is Map<String, dynamic>) {
        return data;
      }
    } catch (e) {
      // Parsing failed, use fallback
    }

    return {
      'code': error.response?.statusCode ?? 0,
      'message': error.message ?? 'Unknown error',
    };
  }

  /// Helper: Log response
  void _logResponse({
    required String method,
    required String url,
    dynamic params,
    int? statusCode,
    dynamic responseData,
    bool isFormData = false,
  }) {
    debugPrint("""
==/@
    Message: "Success.."
    Method: "#$method"
    Url: $url
    ${isFormData ? "Form " : ''}Params: $params
    Headers: ${_dio.options.headers.toString()}
    StatusCode: $statusCode
    Response Data: $responseData
==/@
""");
  }
}