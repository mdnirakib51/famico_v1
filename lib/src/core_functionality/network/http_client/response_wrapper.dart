class ResponseWrapper<T> {
  int? code;
  bool? status;
  String? message;
  dynamic data;

  // * Creating a generic response getter!
  T? _response;
  void setResponse({required T? convertedFromData}) {
    _response = convertedFromData;
  }
  T? get responseData => _response;

  bool get hasSuccessfulData => responseData != null;

  // * End

  ResponseWrapper({
    required this.code,
    required this.status,
    required this.message,
    this.data,
  });

  ResponseWrapper.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    message = json['message'];

    if (json['data'] is Map) {
      data = json['data'];
    } else if (json['data'] is List) {
      data = json['data'];
    } else {
      data = {};
    }
  }

  T? getDataAsType() {
    if (data is Map) {
      return data as T;
    } else if (data is List) {
      return data as T;
    } else {
      return null;
    }
  }
}
