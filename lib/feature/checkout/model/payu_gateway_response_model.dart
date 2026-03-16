class PayUGatewayResponseModel {
  final int status;
  final String message;
  final PayUResult? result;
  final String? errorCode;
  final String? guid;

  PayUGatewayResponseModel({
    required this.status,
    required this.message,
    this.result,
    this.errorCode,
    this.guid,
  });

  factory PayUGatewayResponseModel.fromJson(Map<String, dynamic> json) {
    return PayUGatewayResponseModel(
      status: json['status'],
      message: json['message'],
      result: json['result'] != null ? PayUResult.fromJson(json['result']) : null,
      errorCode: json['errorCode'],
      guid: json['guid'],
    );
  }
}

class PayUResult {
  final double subAmount;
  final double totalAmount;
  final String invoiceNumber;
  final String paymentLink;
  final String description;
  final bool active;
  final bool isPartialPaymentAllowed;
  final String expiryDate;
  final Udf? udf;
  final String customerName;
  final String customerPhone;
  final String customerEmail;
  final String status;

  PayUResult({
    required this.subAmount,
    required this.totalAmount,
    required this.invoiceNumber,
    required this.paymentLink,
    required this.description,
    required this.active,
    required this.isPartialPaymentAllowed,
    required this.expiryDate,
    required this.udf,
    required this.customerName,
    required this.customerPhone,
    required this.customerEmail,
    required this.status,
  });

  factory PayUResult.fromJson(Map<String, dynamic> json) {
    return PayUResult(
      subAmount: (json['subAmount'] ?? 0).toDouble(),
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      invoiceNumber: json['invoiceNumber'] ?? '',
      paymentLink: json['paymentLink'] ?? '',
      description: json['description'] ?? '',
      active: json['active'] ?? false,
      isPartialPaymentAllowed: json['isPartialPaymentAllowed'] ?? false,
      expiryDate: json['expiryDate'] ?? '',
      udf: json['udf'] != null ? Udf.fromJson(json['udf']) : null,
      customerName: json['customerName'] ?? '',
      customerPhone: json['customerPhone'] ?? '',
      customerEmail: json['customerEmail'] ?? '',
      status: json['status'] ?? '',
    );
  }
}

class Udf {
  final String? udf1;
  final String? udf2;
  final String? udf3;
  final String? udf4;
  final String? udf5;

  Udf({this.udf1, this.udf2, this.udf3, this.udf4, this.udf5});

  factory Udf.fromJson(Map<String, dynamic> json) {
    return Udf(
      udf1: json['udf1'],
      udf2: json['udf2'],
      udf3: json['udf3'],
      udf4: json['udf4'],
      udf5: json['udf5'],
    );
  }
}
