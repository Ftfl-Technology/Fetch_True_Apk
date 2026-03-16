class UserModel {
  final String id;
  final String? userId;
  final String? profilePhoto;
  final String fullName;
  final String email;
  final String mobileNumber;
  final String? password;
  final String referralCode;
  final String? referredBy;
  final bool isAgree;
  final bool isEmailVerified;
  final bool isMobileVerified;
  final List<String> serviceCustomers;

  final String? packageType;
  final String? packageStatus;
  final String? packageActivateDate;
  final bool? packageActive;
  final int? packageAmountPaid;
  final num? remainingAmount;

  final bool isCommissionDistribute;
  final List<String> favoriteServices;
  final List<String> favoriteProviders;
  final bool isDeleted;
  final String createdAt;
  final String updatedAt;
  final bool additionalDetailsCompleted;
  final bool addressCompleted;
  final bool personalDetailsCompleted;
  final String? bloodGroup;
  final String? dateOfBirth;
  final String? gender;
  final String? maritalStatus;
  final String? education;
  final String? profession;
  final String? emergencyContact;
  final Address? workAddress;
  final Address? homeAddress;
  final Address? otherAddress;

  UserModel({
    required this.id,
    this.userId,
    this.profilePhoto,
    required this.fullName,
    required this.email,
    required this.mobileNumber,
    this.password,
    required this.referralCode,
    this.referredBy,
    required this.isAgree,
    required this.isEmailVerified,
    required this.isMobileVerified,
    required this.serviceCustomers,
    required this.isCommissionDistribute,
    required this.favoriteServices,
    required this.favoriteProviders,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    required this.additionalDetailsCompleted,
    required this.addressCompleted,
    required this.personalDetailsCompleted,
    this.bloodGroup,
    this.dateOfBirth,
    this.gender,
    this.maritalStatus,
    this.education,
    this.profession,
    this.emergencyContact,
    this.workAddress,
    this.homeAddress,
    this.otherAddress,

    this.packageType,
    this.packageStatus,
    this.packageActivateDate,
    this.packageActive,
    this.packageAmountPaid,
    this.remainingAmount,
  });


  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      profilePhoto: json['profilePhoto'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      password: json['password'],
      referralCode: json['referralCode'] ?? '',
      referredBy: json['referredBy'],
      isAgree: json['isAgree'] ?? false,
      isEmailVerified: json['isEmailVerified'] ?? false,
      isMobileVerified: json['isMobileVerified'] ?? false,
      serviceCustomers: List<String>.from(json['serviceCustomers'] ?? []),
      // packageActive: json['packageActive'] ?? false,
      isCommissionDistribute: json['isCommissionDistribute'] ?? false,
      favoriteServices: List<String>.from(json['favoriteServices'] ?? []),
      favoriteProviders: List<String>.from(json['favoriteProviders'] ?? []),
      isDeleted: json['isDeleted'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      additionalDetailsCompleted: json['additionalDetailsCompleted'] ?? false,
      addressCompleted: json['addressCompleted'] ?? false,
      personalDetailsCompleted: json['personalDetailsCompleted'] ?? false,
      bloodGroup: json['bloodGroup'],
      dateOfBirth: json['dateOfBirth'],
      gender: json['gender'],
      maritalStatus: json['maritalStatus'],
      education: json['education'],
      profession: json['profession'],
      emergencyContact: json['emergencyContact'],
      workAddress: json['workAddress'] != null
          ? Address.fromJson(json['workAddress'])
          : null,
      homeAddress: json['homeAddress'] != null
          ? Address.fromJson(json['homeAddress'])
          : null,
      otherAddress: json['otherAddress'] != null
          ? Address.fromJson(json['otherAddress'])
          : null,

      packageType: json['packageType'],
      packageStatus: json['packageStatus'],
      packageActivateDate: json['packageActivateDate'],
      packageActive: json['packageActive'],
      packageAmountPaid: json['packageAmountPaid'],
      remainingAmount: json['remainingAmount'],
    );
  }

}
class Address {
  final String houseNumber;
  final String landmark;
  final String state;
  final String city;
  final String pinCode;
  final String country;
  final String fullAddress;

  Address({
    required this.houseNumber,
    required this.landmark,
    required this.state,
    required this.city,
    required this.pinCode,
    required this.country,
    required this.fullAddress,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      houseNumber: json['houseNumber'] ?? '',
      landmark: json['landmark'] ?? '',
      state: json['state'] ?? '',
      city: json['city'] ?? '',
      pinCode: json['pinCode'] ?? '',
      country: json['country'] ?? '',
      fullAddress: json['fullAddress'] ?? '',
    );
  }
}
