class PackageModel {
  final String id;
  final int price;
  final int discount;
  final int discountedPrice;
  final int deposit;
  final int grandtotal;
  final int monthlyEarnings;
  final int? lockInPeriod;
  final Map<String, String> description;

  PackageModel({
    required this.id,
    required this.price,
    required this.discount,
    required this.discountedPrice,
    required this.deposit,
    required this.description,
    required this.grandtotal,
    this.lockInPeriod,
    required this.monthlyEarnings,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) {
    return PackageModel(
      id: json['_id'],
      price: json['price'],
      discount: json['discount'],
      discountedPrice: json['discountedPrice'],
      deposit: json['deposit'],
      monthlyEarnings: json['monthlyEarnings'],
      grandtotal: json['grandtotal'],
      lockInPeriod: json['lockInPeriod'],
      description: Map<String, String>.from(json['description']),
    );
  }
}
