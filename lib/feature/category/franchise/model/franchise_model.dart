class FranchiseModelResponse {
  final bool success;
  final FranchiseModelData? data;

  FranchiseModelResponse({
    required this.success,
    this.data,
  });

  factory FranchiseModelResponse.fromJson(Map<String, dynamic> json) {
    return FranchiseModelResponse(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? FranchiseModelData.fromJson(json['data'])
          : null,
    );
  }
}

class FranchiseModelData {
  final String id;
  final String serviceId;
  final List<FranchiseModelItem> model;

  FranchiseModelData({
    required this.id,
    required this.serviceId,
    required this.model,
  });

  factory FranchiseModelData.fromJson(Map<String, dynamic> json) {
    return FranchiseModelData(
      id: json['_id'] ?? '',
      serviceId: json['serviceId'] ?? '',
      model: (json['model'] as List<dynamic>? ?? [])
          .map((e) => FranchiseModelItem.fromJson(e))
          .toList(),
    );
  }
}

class FranchiseModelItem {
  final String id;
  final String franchiseSize;
  final String areaRequired;
  final String marketing;
  final String returnOfInvestment;
  final int manPower;
  final String staffManagement;
  final String royaltyPercent;
  final String grossMargin;
  final String radiusArea;

  FranchiseModelItem({
    required this.id,
    required this.franchiseSize,
    required this.areaRequired,
    required this.marketing,
    required this.returnOfInvestment,
    required this.manPower,
    required this.staffManagement,
    required this.royaltyPercent,
    required this.grossMargin,
    required this.radiusArea,
  });

  factory FranchiseModelItem.fromJson(Map<String, dynamic> json) {
    return FranchiseModelItem(
      id: json['_id'] ?? '',
      franchiseSize: json['franchiseSize'] ?? '',
      areaRequired: json['areaRequired'] ?? '',
      marketing: json['marketing'] ?? '',
      returnOfInvestment: json['returnOfInvestment'] ?? '',
      manPower: json['manPower'] ?? 0,
      staffManagement: json['staffManagement'] ?? '',
      royaltyPercent: json['royaltyPercent'] ?? '',
      grossMargin: json['grossMargin'] ?? '',
      radiusArea: json['radiusArea'] ?? '',
    );
  }
}
