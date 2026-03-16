class InvestmentResponse {
  final bool success;
  final InvestmentData data;

  InvestmentResponse({
    required this.success,
    required this.data,
  });

  factory InvestmentResponse.fromJson(Map<String, dynamic> json) {
    return InvestmentResponse(
      success: json['success'],
      data: InvestmentData.fromJson(json['data']),
    );
  }
}

class InvestmentData {
  final String id;
  final String serviceId;
  final List<InvestmentItem> investment;
  final String createdAt;
  final String updatedAt;

  InvestmentData({
    required this.id,
    required this.serviceId,
    required this.investment,
    required this.createdAt,
    required this.updatedAt,
  });

  factory InvestmentData.fromJson(Map<String, dynamic> json) {
    return InvestmentData(
      id: json['_id'],
      serviceId: json['serviceId'],
      investment: (json['investment'] as List)
          .map((e) => InvestmentItem.fromJson(e))
          .toList(),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

class InvestmentItem {
  final String id;
  final String franchiseSize;
  final String franchiseType;
  final String city;

  final int franchiseFee;
  final int businessLicenses;
  final int insurance;
  final int legalAndAccountingFee;
  final int inventoryFee;
  final int officeSetup;
  final int initialStartupEquipmentAndMarketing;
  final int staffAndManagementTrainingExpense;
  final int otherExpense;
  final int totalInvestment;

  final bool gstIncluded;
  final int gst;
  final int tokenAmount;

  InvestmentItem({
    required this.id,
    required this.franchiseSize,
    required this.franchiseType,
    required this.city,
    required this.franchiseFee,
    required this.businessLicenses,
    required this.insurance,
    required this.legalAndAccountingFee,
    required this.inventoryFee,
    required this.officeSetup,
    required this.initialStartupEquipmentAndMarketing,
    required this.staffAndManagementTrainingExpense,
    required this.otherExpense,
    required this.totalInvestment,
    required this.gstIncluded,
    required this.gst,
    required this.tokenAmount,
  });

  factory InvestmentItem.fromJson(Map<String, dynamic> json) {
    return InvestmentItem(
      id: json['_id'],
      franchiseSize: json['franchiseSize'],
      franchiseType: json['franchiseType'],
      city: json['city'],
      franchiseFee: json['franchiseFee'],
      businessLicenses: json['businessLicenses'],
      insurance: json['insurance'],
      legalAndAccountingFee: json['legalAndAccountingFee'],
      inventoryFee: json['inventoryFee'],
      officeSetup: json['officeSetup'],
      initialStartupEquipmentAndMarketing:
      json['initialStartupEquipmentAndMarketing'],
      staffAndManagementTrainingExpense:
      json['staffAndManagementTrainingExpense'],
      otherExpense: json['otherExpense'],
      totalInvestment: json['totalInvestment'],
      gstIncluded: json['gstIncluded'],
      gst: json['gst'],
      tokenAmount: json['tokenAmount'],
    );
  }
}

