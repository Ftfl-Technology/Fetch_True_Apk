import 'package:fetchtrue/core/widgets/no_user_sign_widget.dart';
import 'package:fetchtrue/feature/profile/bloc/user/user_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:fetchtrue/core/widgets/custom_snackbar.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_button.dart';
import '../../auth/user_notifier/user_notifier.dart';
import '../../profile/bloc/user/user_bloc.dart';
import '../../profile/bloc/user/user_state.dart';

class DeleteAccountScreen extends StatefulWidget {
  final String userId;
  const DeleteAccountScreen({super.key, required this.userId});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  bool _isConfirmed = false;

  void _handleDelete() {
    if (!_isConfirmed) return;

    context.read<UserBloc>().add(DeleteUser(widget.userId));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Delete Account', showBackButton: true),

      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) async {
          if (state is UserDeleted) {
            final userSession = Provider.of<UserSession>(context, listen: false);
            await userSession.logout();

            if (context.mounted) {
              Navigator.pop(context, true);
              showCustomToast('Account deleted successfully');
            }
          } else if (state is UserError) {
            if (context.mounted) {
              showCustomToast('Failed: ${state.massage}');
            }
          }
        },
        builder: (context, state) {
          final isLoading = state is UserLoading;

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Icon(Icons.warning_amber_rounded, size: 80, color: Colors.red),
                const SizedBox(height: 10),
                Text(
                  "Are you sure you want to delete your account?",
                  style: textStyle16(context, color: CustomColor.redColor),
                ),
                const SizedBox(height: 16),
                Text(
                  "Deleting your account is permanent and will erase all your data including profile, history, and preferences from our servers.",
                  style: textStyle14(context, fontWeight: FontWeight.w400, color: Colors.grey.shade500),
                ),
                const Spacer(),
                Column(
                  children: [
                    Theme(
                      data: Theme.of(context).copyWith(
                        splashFactory: NoSplash.splashFactory,
                        highlightColor: Colors.transparent,
                      ),
                      child: CheckboxListTile(
                        title: const Text("Yes, I want to delete my account."),
                        value: _isConfirmed,
                        activeColor: CustomColor.appColor,
                        onChanged: (value) => setState(() => _isConfirmed = value!),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Opacity(
                      opacity: _isConfirmed ? 1.0 : 0.5,
                      child: IgnorePointer(
                        ignoring: !_isConfirmed || isLoading,
                        child: CustomButton(
                          label: isLoading ? 'Deleting...' : 'Delete My Account',
                          isLoading: isLoading,
                          onPressed: _handleDelete,
                          buttonColor: CustomColor.appColor,
                        ),
                      ),
                    ),
                  ],
                ),
                50.height,
              ],
            ),
          );
        },
      ),
    );
  }
}
