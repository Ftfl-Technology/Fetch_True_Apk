class FiveXModel {
  final String id;
  final int leadcount;
  final int fixearning;
  final int months;

  FiveXModel({
    required this.id,
    required this.leadcount,
    required this.fixearning,
    required this.months,
  });

  factory FiveXModel.fromJson(Map<String, dynamic> json) {
    return FiveXModel(
      id: json['_id'],
      leadcount: json['leadcount'],
      fixearning: json['fixearning'],
      months: json['months'],
    );
  }
}
