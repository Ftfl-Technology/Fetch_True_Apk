import 'package:fetchtrue/core/costants/custom_logo.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:fetchtrue/core/widgets/custom_button.dart';
import 'package:fetchtrue/feature/auth/screen/verify_otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/costants/custom_color.dart';
import '../../../core/widgets/custom_snackbar.dart';
import '../../../core/widgets/custom_text_tield.dart';
import '../firebase_uth/verify_number_service.dart';
import '../repository/forgot_password_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final VerifyNumberService _verifyNumberService = VerifyNumberService();
  final ForgotPasswordService _forgotPasswordService = ForgotPasswordService();

  bool _isOtpVerified = false;
  bool _isLoading = false;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(() {
      final digits = _phoneController.text.replaceAll(RegExp(r'[^0-9]'), '');
      final last10 = digits.length > 10 ? digits.substring(digits.length - 10) : digits;
      if (_phoneController.text != last10) {
        _phoneController.value = TextEditingValue(
          text: last10,
          selection: TextSelection.collapsed(offset: last10.length),
        );
      }
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isVerifyButtonDisabled = _phoneController.text.trim().isEmpty;
    final isSaveButtonDisabled = _confirmPasswordController.text.trim().isEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Forgot Password', showBackButton: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Logo
                Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    height: _isOtpVerified ? 150 : 300,
                    child: Image.asset(CustomLogo.fetchTrueLogo),
                  ),
                ),

                /// Phone Field
                RichText(
                  text: const TextSpan(
                    text: 'Phone',
                    style: TextStyle(color: Colors.black, fontSize: 14),
                    children: [TextSpan(text: ' *', style: TextStyle(color: Colors.red))],
                  ),
                ),
                5.height,
                Row(
                  children: [
                    Container(
                      height: 48,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Center(
                        child: Text('+91',
                            style: TextStyle(
                                color: CustomColor.appColor, fontWeight: FontWeight.w500)),
                      ),
                    ),
                    10.width,
                    Expanded(
                      child: CustomFormField(
                        context,
                        maxLength: 12,
                        hint: 'Enter phone number',
                        controller: _phoneController,
                        keyboardType: TextInputType.number,
                        isRequired: true,
                        enabled: !_isOtpVerified,
                        autofillHints: const [AutofillHints.telephoneNumber],
                      ),
                    ),
                  ],
                ),

                /// Password Fields
                if (_isOtpVerified)
                  Column(
                    children: [
                      20.height,
                      CustomLabelFormField(
                        context,
                        'Password',
                        hint: 'Enter password',
                        controller: _passwordController,
                        keyboardType: TextInputType.text,
                        isRequired: true,
                        obscureText: _obscureText,
                        suffixIcon: InkWell(
                          onTap: () => setState(() => _obscureText = !_obscureText),
                          child: Icon(_obscureText ? Icons.visibility_off : Icons.visibility,
                              color: CustomColor.appColor),
                        ),
                      ),
                      15.height,
                      CustomLabelFormField(
                        context,
                        'Confirm Password',
                        hint: 'Enter confirm password',
                        controller: _confirmPasswordController,
                        keyboardType: TextInputType.text,
                        isRequired: true,
                        obscureText: _obscureText,
                        suffixIcon: InkWell(
                          onTap: () => setState(() => _obscureText = !_obscureText),
                          child: Icon(_obscureText ? Icons.visibility_off : Icons.visibility,
                              color: CustomColor.appColor),
                        ),
                      ),
                    ],
                  ),
              ],
            ),

            /// Buttons
            200.height,
            CustomButton(
              isLoading: _isLoading,
              label: !_isOtpVerified ? 'Verify Number' : 'Save Password',
              buttonColor: (!_isOtpVerified && isVerifyButtonDisabled) ||
                  (_isOtpVerified && isSaveButtonDisabled)
                  ? Colors.grey
                  : CustomColor.appColor,
              onPressed: () {
                // Disabled condition
                if ((!_isOtpVerified && isVerifyButtonDisabled) ||
                    (_isOtpVerified && isSaveButtonDisabled)) return;

                // Call async functions safely
                if (!_isOtpVerified) {
                  _handleVerifyNumber(); // async, but called safely
                } else {
                  _handleSavePassword(); // async, but called safely
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Separate functions for clarity
  Future<void> _handleVerifyNumber() async {
    final phone = _phoneController.text.trim();
    if (!RegExp(r'^[0-9]{10}$').hasMatch(phone)) {
      showCustomToast('Please enter a valid 10-digit phone number');
      return;
    }
    setState(() => _isLoading = true);
    try {
      await _verifyNumberService.sendOtp(
        phone,
        onCodeSent: (verificationId) async {
          setState(() => _isLoading = false);
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => VerifyOtpScreen(
                phoneNumber: phone,
                verifyService: _verifyNumberService,
              ),
            ),
          );
          if (result == true) setState(() => _isOtpVerified = true);
        },
      );
    } catch (e) {
      setState(() => _isLoading = false);
      showCustomSnackBar(context, e.toString());
    }
  }

  Future<void> _handleSavePassword() async {
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();
    final phone = _phoneController.text.trim();

    if (password.isEmpty || confirmPassword.isEmpty || phone.isEmpty) {
      showCustomToast('Please fill all required fields');
      return;
    }
    if (password.length < 8 || password.length > 15) {
      showCustomToast('Password must be between 8 to 15 characters.');
      return;
    }
    if (password != confirmPassword) {
      showCustomToast('Passwords do not match');
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _forgotPasswordService.forgotPasswordUser(
        mobileNumber: phone,
        newPassword: password,
      );
      showCustomToast('🎉 Password reset successful');
      Navigator.pop(context);
    } catch (e) {
      showCustomSnackBar(context, e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

}
