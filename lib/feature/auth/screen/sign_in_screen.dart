import 'package:fetchtrue/core/costants/custom_icon.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:fetchtrue/feature/auth/model/sign_in_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_logo.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_alert_dialog.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_snackbar.dart';
import '../../../core/widgets/custom_text_tield.dart';
import '../../profile/bloc/user/user_bloc.dart';
import '../../profile/bloc/user/user_event.dart';
import '../bloc/sign_in/sign_in_bloc.dart';
import '../bloc/sign_in/sign_in_event.dart';
import '../bloc/sign_in/sign_in_state.dart';
import '../repository/sign_in_repository.dart';
import '../user_notifier/user_notifier.dart';
import 'forgot_password_screen.dart';

class SignInScreen extends StatefulWidget {
  final Function(bool) onToggle;
  const SignInScreen({super.key, required this.onToggle});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _mainController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  bool _obscureText = true;
  String? prefixText;
  String inputLabel = 'Email/Phone';

  @override
  void initState() {
    super.initState();
    _mainController.addListener(() {
      setState(() {
        _updateInputLabel(_mainController.text);
      });
    });
  }


  void _updateInputLabel(String input) {
    if (RegExp(r'^\d+$').hasMatch(input)) {
      inputLabel = 'Phone';
      prefixText = '+91 ';
    } else if (input.contains('@') || RegExp(r'[a-zA-Z]').hasMatch(input)) {
      inputLabel = 'Email';
      prefixText = null;
    } else {
      inputLabel = 'Email/Phone';
      prefixText = null;
    }
  }



  @override
  void dispose() {
    _mainController.dispose();
    _passwordController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignInBloc(SignInRepository()),
      child: BlocConsumer<SignInBloc, SignInState>(
        listener: (context, state) async{
          if (state is SignInSuccess) {
            final response = state.response;

            final userSession = Provider.of<UserSession>(context, listen: false);
            await userSession.login(response.user.id, response.token);

            /// Reset UserBloc and get new user
            final userBloc = context.read<UserBloc>();
            userBloc.add(ResetUser());
            userBloc.add(GetUserById(response.user.id));

            showCustomToast("Sign In Success: ${response.user.fullName}");
            Navigator.pop(context, true);
          }

          if (state is SignInFailure) {
            showCustomToast(state.error);
          }
        },
          builder: (context, state)  {
           final isLoading = state is SignInLoading;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  30.height,

                  Center(
                      child: Image.asset(
                      CustomLogo.fetchTrueLogo,
                      height: 180,
                  )),
                  30.height,

                  CustomLabelFormField(
                    context,
                    inputLabel,
                    hint: 'Enter email or phone number',
                    prefixText: prefixText,
                    icon:Icons.person,
                    controller: _mainController,
                    keyboardType: TextInputType.text,
                    isRequired: true,
                  ),

                  15.height,

                  CustomLabelFormField(context, 'Password',
                      hint: 'Enter Password',
                      controller: _passwordController,
                      keyboardType: TextInputType.text,
                      icon:Icons.lock,
                      isRequired: true,
                      obscureText: _obscureText ? true : false,
                      suffixIcon: InkWell(
                        onTap: (){
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                        child: Icon( _obscureText ? Icons.visibility_off : Icons.visibility,color: CustomColor.appColor,),)
                  ),
                  50.height,

                  CustomButton(
                    label: 'Sign In',
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) return;

                      final input = _mainController.text.trim();
                      final password = _passwordController.text.trim();

                      String email = "";
                      String mobileNumber = "";

                      if (RegExp(r'^\d{10}$').hasMatch(input)) {
                        mobileNumber = input;
                      } else if (input.contains('@')) {
                        email = input.toLowerCase();
                      } else {
                        showCustomToast("Please enter a valid email or 10-digit phone number.");
                        return;
                      }

                      final signInData = SignInModel(email: email, mobileNumber: mobileNumber, password: password);
                      context.read<SignInBloc>().add(SignInButtonPressed(signInData));
                    },
                    isLoading: isLoading,
                  ),
                  10.height,

                  /// Forgot Password
                  TextButton(
                    onPressed: () {
                     Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordScreen(),));
                    },
                    child: Text(
                      'Forgot Password ?',
                      style: TextStyle(color: CustomColor.appColor),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Don\'t have an account ?'),
                      TextButton(
                        onPressed: () {
                          widget.onToggle(true); // Go to SignUpScreen
                        },
                        child: Text('Sign Up', style: textStyle14(context, color: CustomColor.appColor),),
                      ),
                    ],
                  ),
                  20.height,


                  // Row(
                  //   children: [
                  //     Expanded(child: CustomContainer(padding: EdgeInsetsDirectional.symmetric(vertical: 0.5,), color: CustomColor.appColor,)),
                  //     Text('Or Continue with'),
                  //     Expanded(child: CustomContainer(padding: EdgeInsetsDirectional.symmetric(vertical: 0.5,), color: CustomColor.appColor,)),
                  //   ],
                  // ),
                  // 30.height,
                  // Row(
                  //   spacing: 50,
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   crossAxisAlignment: CrossAxisAlignment.center,
                  //   children: [
                  //     InkWell(onTap: () => CustomAlertDialog(context,title: 'Alert!', content: 'Dear Franchise This Feature Is Not Valid', onConfirm: () {}, ),child: Image.asset(CustomIcon.googleIcon, height: 30,)),
                  //     // InkWell(onTap: () => CustomAlertDialog(context,title: 'Alert!', content: 'Dear Franchise This Feature Is Not Valid', onConfirm: () {}, ),child: Image.asset(CustomIcon.facebookIcon, height: 35,)),
                  //     InkWell(onTap: () => CustomAlertDialog(context,title: 'Alert!', content: 'Dear Franchise This Feature Is Not Valid', onConfirm: () {}, ),child: Image.asset(CustomIcon.appleIcon, height: 30,)),
                  //   ],
                  // )

                ],
              ),
            ),
          );
        }
      ),
    );
  }
}
