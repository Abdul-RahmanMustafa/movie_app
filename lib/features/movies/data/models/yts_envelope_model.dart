class YtsEnvelopeModel {
  const YtsEnvelopeModel({
    required this.status,
    required this.statusMessage,
    required this.data,
  });

  final String status;
  final String statusMessage;
  final Map<String, dynamic>? data;

  factory YtsEnvelopeModel.fromJson(Map<String, dynamic> json) {
    final status = json['status'];
    final statusMessage = json['status_message'];
    final rawData = json['data'];

    if (status is! String || status.trim().isEmpty) {
      throw const YtsInvalidResponseException();
    }

    Map<String, dynamic>? data;
    if (rawData is Map<String, dynamic>) {
      data = rawData;
    } else if (rawData is Map) {
      data = Map<String, dynamic>.from(rawData);
    } else if (rawData != null) {
      throw const YtsInvalidResponseException();
    }

    return YtsEnvelopeModel(
      status: status,
      statusMessage: statusMessage is String ? statusMessage : '',
      data: data,
    );
  }

  Map<String, dynamic> requireSuccessfulData() {
    if (status.toLowerCase() != 'ok') {
      throw YtsApiException(statusMessage);
    }
    return data ?? (throw const YtsInvalidResponseException());
  }
}

class YtsApiException implements Exception {
  const YtsApiException(this.message);

  final String message;
}

class YtsInvalidResponseException implements Exception {
  const YtsInvalidResponseException();
}
