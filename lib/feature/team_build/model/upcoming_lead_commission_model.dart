class UpcomingLeadCommissionModel {
  final bool success;
  final CommissionData? data;

  UpcomingLeadCommissionModel({
    required this.success,
    this.data,
  });

  factory UpcomingLeadCommissionModel.fromJson(Map<String, dynamic> json) {
    return UpcomingLeadCommissionModel(
      success: json['success'] ?? false,
      data: json['data'] != null ? CommissionData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data?.toJson(),
    };
  }
}

class CommissionData {
  final String id;
  final String? leadId;
  final String checkoutId;
  final double share1;
  final double share2;
  final double share3;
  final double adminCommission;
  final double providerShare;
  final double extraShare1;
  final double extraShare2;
  final double extraShare3;
  final double extraAdminCommission;
  final double extraProviderShare;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  CommissionData({
    required this.id,
    this.leadId,
    required this.checkoutId,
    required this.share1,
    required this.share2,
    required this.share3,
    required this.adminCommission,
    required this.providerShare,
    required this.extraShare1,
    required this.extraShare2,
    required this.extraShare3,
    required this.extraAdminCommission,
    required this.extraProviderShare,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  /// helper function to safely cast to double
  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  factory CommissionData.fromJson(Map<String, dynamic> json) {
    return CommissionData(
      id: json['_id'] ?? '',
      leadId: json['leadId'],
      checkoutId: json['checkoutId'] ?? '',
      share1: _toDouble(json['share_1']),
      share2: _toDouble(json['share_2']),
      share3: _toDouble(json['share_3']),
      adminCommission: _toDouble(json['admin_commission']),
      providerShare: _toDouble(json['provider_share']),
      extraShare1: _toDouble(json['extra_share_1']),
      extraShare2: _toDouble(json['extra_share_2']),
      extraShare3: _toDouble(json['extra_share_3']),
      extraAdminCommission: _toDouble(json['extra_admin_commission']),
      extraProviderShare: _toDouble(json['extra_provider_share']),
      status: json['status'] ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      v: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'leadId': leadId,
      'checkoutId': checkoutId,
      'share_1': share1,
      'share_2': share2,
      'share_3': share3,
      'admin_commission': adminCommission,
      'provider_share': providerShare,
      'extra_share_1': extraShare1,
      'extra_share_2': extraShare2,
      'extra_share_3': extraShare3,
      'extra_admin_commission': extraAdminCommission,
      'extra_provider_share': extraProviderShare,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      '__v': v,
    };
  }
}
