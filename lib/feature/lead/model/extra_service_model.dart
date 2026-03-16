class ExtraServiceModel {
  final String serviceName;
  final double price;
  final double discount;
  final double total;
  final String commission;
  final bool isLeadApproved;

  ExtraServiceModel({
    required this.serviceName,
    required this.price,
    required this.discount,
    required this.total,
    required this.commission,
    required this.isLeadApproved,
  });

  factory ExtraServiceModel.fromJson(Map<String, dynamic> json) {
    return ExtraServiceModel(
      serviceName: json['serviceName'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      discount: (json['discount'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
      commission: json['commission']?.toString() ?? '',
      isLeadApproved: json['isLeadApproved'] ?? false,
    );
  }
}

/// 🔹 New Parent Model for API response
class ExtraServiceResponse {
  final bool isAdminApproved;
  final List<ExtraServiceModel> services;

  ExtraServiceResponse({
    required this.isAdminApproved,
    required this.services,
  });

  factory ExtraServiceResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    final List<dynamic> extraServiceList = data['extraService'] ?? [];

    return ExtraServiceResponse(
      isAdminApproved: data['isAdminApproved'] ?? false,
      services: extraServiceList
          .map((item) => ExtraServiceModel.fromJson(item))
          .toList(),
    );
  }
}
