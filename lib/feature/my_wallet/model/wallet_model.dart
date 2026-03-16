import '../../profile/model/user_model.dart';

class WalletModel {
  final String id;
  final UserModel user;
  final double balance;
  final double selfEarnings;
  final double referralEarnings;
  final double totalCredits;
  final double totalDebits;
  final bool isActive;
  final DateTime? lastTransactionAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<TransactionModel> transactions;

  WalletModel({
    required this.id,
    required this.user,
    required this.balance,
    required this.selfEarnings,
    required this.referralEarnings,
    required this.totalCredits,
    required this.totalDebits,
    required this.isActive,
    this.lastTransactionAt,
    this.createdAt,
    this.updatedAt,
    required this.transactions,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};

    DateTime? parseDate(dynamic dateStr) {
      if (dateStr == null) return null;
      return DateTime.tryParse(dateStr.toString());
    }

    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString()) ?? 0.0;
    }

    return WalletModel(
      id: data['_id'] ?? '',
      user: UserModel.fromJson(data['userId'] ?? {}),
      balance: parseDouble(data['balance']),
      selfEarnings: parseDouble(data['selfEarnings']),
      referralEarnings: parseDouble(data['referralEarnings']),
      totalCredits: parseDouble(data['totalCredits']),
      totalDebits: parseDouble(data['totalDebits']),
      isActive: data['isActive'] ?? false,
      lastTransactionAt: parseDate(data['lastTransactionAt']),
      createdAt: parseDate(data['createdAt']),
      updatedAt: parseDate(data['updatedAt']),
      transactions: (data['transactions'] as List? ?? [])
          .map((e) => TransactionModel.fromJson(e))
          .toList(),
    );
  }
}

class TransactionModel {
  final String type;
  final String leadId;
  final String commissionFrom;
  final double amount;
  final String description;
  final String referenceId;
  final String method;
  final String source;
  final String status;
  final double balanceAfterTransaction;
  final DateTime? createdAt;

  TransactionModel({
    required this.type,
    required this.leadId,
    required this.commissionFrom,
    required this.amount,
    required this.description,
    required this.referenceId,
    required this.method,
    required this.source,
    required this.status,
    required this.balanceAfterTransaction,
    this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString()) ?? 0.0;
    }

    DateTime? parseDate(dynamic dateStr) {
      if (dateStr == null) return null;
      return DateTime.tryParse(dateStr.toString());
    }

    return TransactionModel(
      type: json['type'] ?? '',
      leadId: json['leadId'] ?? '',
      commissionFrom: json['commissionFrom'] ?? '',
      amount: parseDouble(json['amount']),
      description: json['description'] ?? '',
      referenceId: json['referenceId'] ?? '',
      method: json['method'] ?? '',
      source: json['source'] ?? '',
      status: json['status'] ?? '',
      balanceAfterTransaction: parseDouble(json['balanceAfterTransaction']),
      createdAt: parseDate(json['createdAt']),
    );
  }
}
