class LeadStatusModel {
  final String id;
  final String checkout;
  final bool? isAdminApproved;
  final List<LeadStatusItem> leads;
  final List<ExtraService>? extraService;

  LeadStatusModel({
    required this.id,
    required this.checkout,
    required this.isAdminApproved,
    required this.leads,
    this.extraService,
  });

  factory LeadStatusModel.fromJson(Map<String, dynamic> json) {
    return LeadStatusModel(
      id: json['_id'] ?? '',
      checkout: json['checkout'] ?? '',
      isAdminApproved: json['isAdminApproved'] ?? false,
      leads: (json['leads'] as List<dynamic>?)
          ?.map((e) => LeadStatusItem.fromJson(e))
          .toList() ??
          [],
      extraService: (json['extraService'] as List<dynamic>?)
          ?.map((e) => ExtraService.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class LeadStatusItem {
  final String statusType;
  final String description;
  final String zoomLink;
  final String? document;
  final String? paymentLink;
  final String? paymentType;
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;

  LeadStatusItem({
    required this.statusType,
    required this.description,
    required this.zoomLink,
    this.document,
    this.paymentLink,
    this.paymentType,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LeadStatusItem.fromJson(Map<String, dynamic> json) {
    return LeadStatusItem(
      statusType: json['statusType'] ?? '',
      description: json['description'] ?? '',
      zoomLink: json['zoomLink'] ?? '',
      document: json['document'],
      paymentLink: json['paymentLink'],
      paymentType: json['paymentType'],
      id: json['_id'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class ExtraService {
  final String serviceName;
  final double price;
  final double discount;
  final double total;
  final String commission;
  final bool isLeadApproved;

  ExtraService({
    required this.serviceName,
    required this.price,
    required this.discount,
    required this.total,
    required this.commission,
    required this.isLeadApproved,
  });

  factory ExtraService.fromJson(Map<String, dynamic> json) {
    return ExtraService(
      serviceName: json['serviceName'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      discount: (json['discount'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
      commission: json['commission'] ?? '',
      isLeadApproved: json['isLeadApproved'] ?? false,
    );
  }
}
