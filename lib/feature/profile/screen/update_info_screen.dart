import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:fetchtrue/core/widgets/custom_snackbar.dart';
import 'package:fetchtrue/core/widgets/custom_text_tield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_container.dart';
import '../../profile/bloc/user/user_bloc.dart';
import '../../profile/bloc/user/user_state.dart';
import '../../profile/bloc/user/user_event.dart';
import '../model/user_model.dart';

class UpdateInfoScreen extends StatefulWidget {
  final UserModel user;
  const UpdateInfoScreen({super.key, required this.user});

  @override
  State<UpdateInfoScreen> createState() => _UpdateInfoScreenState();
}

class _UpdateInfoScreenState extends State<UpdateInfoScreen> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;


  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.fullName);
    _phoneController = TextEditingController(text: widget.user.mobileNumber);
    _emailController = TextEditingController(text: widget.user.email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }


  void _onSave() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();

    if (name.isEmpty || name.length < 3) {
      showCustomToast("Please enter a valid name (min 3 characters)");
      return;
    }

    if (email.isEmpty) {
      showCustomToast( "Email cannot be empty");
      return;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      showCustomToast( "Please enter a valid email address");
      return;
    }

    final updatedData = {
      "fullName": name,
      "email": email,
    };
    context.read<UserBloc>().add(UpdateUser(widget.user.id, updatedData));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Update Info', showBackButton: true),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomLabelFormField(
              context,
              'Name',
              hint: 'Update Name',
              keyboardType: TextInputType.text,
              controller: _nameController,
            ),
            const SizedBox(height: 15),
            CustomLabelFormField(
              context,
              'Phone',
              hint: 'Update Phone Number',
              keyboardType: TextInputType.phone,
              controller: _phoneController,
              enabled: false,
            ),
            const SizedBox(height: 15),
            CustomLabelFormField(
              context,
              'Email Id',
              hint: 'Update Email Id',
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
            ),
            const SizedBox(height: 50),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("CANCEL", style: TextStyle(color: Colors.red)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: BlocConsumer<UserBloc, UserState>(
                    listener: (context, state) {
                      if (state is UserUpdated) {
                        context.read<UserBloc>().add(GetUserById(state.user.id));
                        Navigator.pop(context, true);
                      }
                      if (state is UserError) {
                        print('${state.massage}');
                      }
                    },
                    builder: (context, state) {
                      final isLoading = state is UserLoading;
                      return CustomContainer(
                        border: true,
                        borderColor: CustomColor.appColor,
                        color: CustomColor.whiteColor,
                        onTap: isLoading ? null : _onSave,
                        child: Center(
                          child: isLoading
                              ? const SizedBox(
                            height: 20, width: 20,
                            child: CircularProgressIndicator(),
                          )
                              : Text("SAVE", style: textStyle16(context)),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      )
    );
  }
}