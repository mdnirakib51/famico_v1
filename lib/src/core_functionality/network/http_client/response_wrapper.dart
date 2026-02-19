class ResponseWrapper<T> {
  int? code;
  String? status;
  String? message;
  ErrorDetail? error;
  dynamic data;

  // * Generic response getter
  T? _response;
  void setResponse({required T? convertedFromData}) => _response = convertedFromData;
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
    status  = json['status']?.toString();
    code    = int.tryParse(status ?? '0');
    message = json['message'];
    error   = json['error'] != null ? ErrorDetail.fromJson(json['error']) : null;

    if (json['data'] is Map || json['data'] is List) {
      data = json['data'];
    } else {
      data = {};
    }
  }

  T? getDataAsType() {
    if (data is Map || data is List) return data as T;
    return null;
  }

  /// ✅ Combined message for toast
  /// "Not Found • Invalid credentials"
  String get combinedMessage {
    final main   = message?.trim() ?? '';
    final detail = error?.error?.trim() ?? '';

    if (main.isNotEmpty && detail.isNotEmpty) return '$main\n$detail';
    if (detail.isNotEmpty) return detail;
    return main;
  }

  /// Check if success
  bool get isSuccess {
    final c = code ?? 0;
    return c >= 200 && c < 300;
  }
}

class ErrorDetail {
  String? error;

  ErrorDetail({this.error});

  ErrorDetail.fromJson(Map<String, dynamic> json) {
    error = json['error'];
  }

  Map<String, dynamic> toJson() => {'error': error};
}