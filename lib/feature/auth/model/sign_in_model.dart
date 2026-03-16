class SignInModel {
  final String email;
  final String mobileNumber;
  final String password;

  SignInModel({
    required this.email,
    required this.mobileNumber,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      "email": email,
      "mobileNumber": mobileNumber,
      "password": password,
    };
  }
}
