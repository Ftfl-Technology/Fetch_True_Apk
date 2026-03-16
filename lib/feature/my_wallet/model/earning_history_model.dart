class EarningHistory {
  final String transactionId;
  final String type;
  final double amount;
  final String? bankName;
  final String? accountNumber;
  final String date;
  final String time;
  final String status;

  EarningHistory({
    required this.transactionId,
    required this.type,
    required this.amount,
    this.bankName,
    this.accountNumber,
    required this.date,
    required this.time,
    required this.status,
  });

  factory EarningHistory.fromJson(Map<String, dynamic> json) {
    return EarningHistory(
      transactionId: json['transactionId'] ?? '',
      type: json['type'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      bankName: json['bankName'],
      accountNumber: json['accountNumber'],
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      status: json['status'] ?? '',
    );
  }
}
