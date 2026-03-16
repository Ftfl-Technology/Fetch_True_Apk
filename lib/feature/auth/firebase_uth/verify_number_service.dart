import 'package:firebase_auth/firebase_auth.dart';

typedef CodeSentCallback = Future<void> Function(String verificationId);
typedef AutoFillCallback = void Function(String? smsCode);

class VerifyNumberService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _verificationId;
  int? _resendToken; // 🔁 Reliable resend token
  bool _isOtpSending = false; // 🚫 Prevent double OTP requests

  /// 📤 Send OTP safely with Firebase phone auth
  Future<void> sendOtp(
      String phoneNumber, {
        required CodeSentCallback onCodeSent,
        AutoFillCallback? onVerificationCompleted,
      }) async {
    if (_isOtpSending) {
      print("⚠️ OTP already sending... ignoring duplicate request");
      return;
    }

    _isOtpSending = true;

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: '+91$phoneNumber',
        timeout: const Duration(seconds: 30),
        forceResendingToken: _resendToken,

        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto verification (if possible)
          try {
            await _auth.signInWithCredential(credential);
            if (credential.smsCode != null) {
              onVerificationCompleted?.call(credential.smsCode);
            }
          } catch (e) {
            print("⚠️ Auto sign-in failed: $e");
          }
        },

        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'too-many-requests') {
            throw Exception(
              "We have blocked all requests from this device due to unusual activity. Try again later.",
            );
          } else if (e.code == 'invalid-phone-number') {
            throw Exception("Invalid phone number format.");
          } else if (e.code == 'quota-exceeded') {
            throw Exception("SMS quota exceeded. Try again later.");
          } else {
            throw Exception(e.message ?? "OTP verification failed.");
          }
        },

        codeSent: (String verificationId, int? resendToken) async {
          _verificationId = verificationId;
          _resendToken = resendToken;
          await onCodeSent(verificationId);
          print("✅ OTP sent successfully to +91$phoneNumber");
        },

        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
          print("⌛ OTP auto retrieval timeout");
        },
      );
    } catch (e) {
      throw Exception("❌ OTP sending failed: $e");
    } finally {
      _isOtpSending = false; // 🔓 unlock sending
    }
  }

  /// ✅ Verify OTP manually (entered by user)
  Future<bool> verifyOtp(String otp) async {
    if (_verificationId == null) {
      throw Exception("Verification ID missing or expired");
    }

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user != null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-verification-code') {
        throw Exception("Invalid OTP entered.");
      }
      throw Exception(e.message ?? "OTP verification failed");
    }
  }

  /// 🔁 Resend OTP (uses same resend token)
  Future<void> resendOtp(
      String phoneNumber, {
        required CodeSentCallback onCodeSent,
        AutoFillCallback? onVerificationCompleted,
      }) async {
    print("🔁 Resending OTP...");
    await sendOtp(
      phoneNumber,
      onCodeSent: onCodeSent,
      onVerificationCompleted: onVerificationCompleted,
    );
  }

  /// 🧹 Invalidate OTP manually
  void invalidateOtp() {
    _verificationId = null;
    _resendToken = null;
    print("🧹 OTP invalidated manually");
  }
}
