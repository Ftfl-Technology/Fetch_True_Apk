class ShareOneCommissionModel {
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

  ShareOneCommissionModel({
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
  });

  factory ShareOneCommissionModel.fromJson(Map<String, dynamic> json) {
    return ShareOneCommissionModel(
      share1: (json['share_1'] ?? 0).toDouble(),
      share2: (json['share_2'] ?? 0).toDouble(),
      share3: (json['share_3'] ?? 0).toDouble(),
      adminCommission: (json['admin_commission'] ?? 0).toDouble(),
      providerShare: (json['provider_share'] ?? 0).toDouble(),
      extraShare1: (json['extra_share_1'] ?? 0).toDouble(),
      extraShare2: (json['extra_share_2'] ?? 0).toDouble(),
      extraShare3: (json['extra_share_3'] ?? 0).toDouble(),
      extraAdminCommission:
      (json['extra_admin_commission'] ?? 0).toDouble(),
      extraProviderShare:
      (json['extra_provider_share'] ?? 0).toDouble(),
    );
  }
}
