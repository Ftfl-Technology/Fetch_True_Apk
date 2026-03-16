import 'dart:async';
import 'package:fetchtrue/core/costants/custom_log_emoji.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_snackbar.dart';
import '../firebase_uth/verify_number_service.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String phoneNumber;
  final VerifyNumberService verifyService;

  const VerifyOtpScreen({
    super.key,
    required this.phoneNumber,
    required this.verifyService,
  });

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final TextEditingController _otpController = TextEditingController();

  bool _isVerifying = false;
  bool _isButtonEnabled = false;

  Timer? _timer;
  int _secondsRemaining = 30;
  bool _isResendEnabled = false;

  @override
  void initState() {
    super.initState();
    _startTimer();

    _otpController.addListener(() {
      setState(() {
        _isButtonEnabled = _otpController.text.trim().length == 6;
      });
    });
  }

  Future<void> _sendOtpWithAutoFill() async {
    await widget.verifyService.sendOtp(
      widget.phoneNumber,
      onCodeSent: (verificationId) async {
        // showCustomToast('${CustomLogEmoji.mail} OTP Sent');
      },
      onVerificationCompleted: (smsCode) {
        if (mounted && smsCode != null && smsCode.length == 6) {
          _otpController.text = smsCode;
          _verifyOtp();
        }
      },
    );
  }

  void _startTimer() {
    _secondsRemaining = 30;
    _isResendEnabled = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        setState(() => _isResendEnabled = true);
        _timer?.cancel();
      }
    });
  }

  Future<void> _verifyOtp() async {
    final otp = _otpController.text.trim();
    if (otp.length != 6) return;

    setState(() => _isVerifying = true);
    try {
      final verified = await widget.verifyService.verifyOtp(otp);
      if (verified) {
        Navigator.pop(context, true);
      } else {
        showCustomToast('OTP verification failed');
      }
    } catch (e) {
      showCustomToast('Something went wrong');
    } finally {
      setState(() => _isVerifying = false);
    }
  }

  Future<void> _resendOtp() async {
    try {
      widget.verifyService.invalidateOtp(); // old OTP invalidate
      await widget.verifyService.resendOtp(
        widget.phoneNumber,
        onCodeSent: (verificationId) async {
          showCustomToast('${CustomLogEmoji.mail} OTP Resent');
        },
        onVerificationCompleted: (smsCode) {
          if (smsCode != null && smsCode.length == 6) {
            _otpController.text = smsCode;
            _verifyOtp();
          }
        },
      );
      _otpController.clear();
      _startTimer();
    } catch (e) {
      showCustomToast('Failed to resend OTP');
    }
  }

  @override
  void dispose() {
    _otpController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);

    final defaultPinTheme = PinTheme(
      width: 48,
      height: 48,
      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
    );

    return Scaffold(
      backgroundColor: CustomColor.whiteColor,
      appBar: const CustomAppBar(title: 'Verify OTP', showBackButton: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: dimensions.screenHeight * 0.02),
                Text(
                  'Verify Number With OTP',
                  style: textStyle16(context, color: CustomColor.blackColor),
                ),
                SizedBox(height: dimensions.screenHeight * 0.01),
                Text(
                  "We've sent a 6-digit code to +91 ${widget.phoneNumber}",
                  style: textStyle12(context, color: CustomColor.descriptionColor),
                ),
                SizedBox(height: dimensions.screenHeight * 0.03),

                Center(
                  child: Pinput(
                    length: 6,
                    controller: _otpController,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: defaultPinTheme.copyWith(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    submittedPinTheme: defaultPinTheme.copyWith(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    showCursor: true,
                  ),
                ),

                SizedBox(height: dimensions.screenHeight * 0.02),

                _isResendEnabled ?
                InkWell(
                  onTap: _resendOtp,
                  child:  Text('Resend OTP', style: textStyle12(context, color: CustomColor.appColor).copyWith(decoration: TextDecoration.underline)),
                ):
                Text('Resend available in $_secondsRemaining sec', style: textStyle12(context),),
              ],
            ),

            Padding(
              padding: EdgeInsets.only(bottom: dimensions.screenHeight * 0.1),
              child: CustomButton(
                label: 'Verify OTP',
                isLoading: _isVerifying,
                buttonColor: !_isButtonEnabled ? Colors.grey.shade500 : CustomColor.appColor,
                onPressed: () {
                  if (_isButtonEnabled) _verifyOtp();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
