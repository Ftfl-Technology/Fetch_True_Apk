class BankKycModel {
  final String userId;
  final String accountNumber;
  final String ifsc;
  final String bankName;
  final String branchName;

  BankKycModel({
    required this.userId,
    required this.accountNumber,
    required this.ifsc,
    required this.bankName,
    required this.branchName,
  });

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "accountNumber": accountNumber,
    "ifsc": ifsc,
    "bankName": bankName,
    "branchName": branchName,
  };
}
