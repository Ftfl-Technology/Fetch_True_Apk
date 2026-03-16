class BankDetailModel {
  final String id;
  final String userId;
  final String accountNumber;
  final String bankName;
  final String branchName;
  final String ifsc;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  BankDetailModel({
    required this.id,
    required this.userId,
    required this.accountNumber,
    required this.bankName,
    required this.branchName,
    required this.ifsc,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BankDetailModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return BankDetailModel(
      id: data['_id'],
      userId: data['userId'],
      accountNumber: data['accountNumber'],
      bankName: data['bankName'],
      branchName: data['branchName'],
      ifsc: data['ifsc'],
      isActive: data['isActive'],
      createdAt: DateTime.parse(data['createdAt']),
      updatedAt: DateTime.parse(data['updatedAt']),
    );
  }
}
