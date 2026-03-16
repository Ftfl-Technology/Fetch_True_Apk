import 'package:fetchtrue/core/costants/custom_log_emoji.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:fetchtrue/core/widgets/custom_button.dart';
import 'package:fetchtrue/core/widgets/custom_snackbar.dart';
import 'package:fetchtrue/core/widgets/custom_text_tield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bank_details/bank_detail_bloc.dart';
import '../bloc/bank_details/bank_detail_event.dart';
import '../bloc/bank_details/bank_detail_state.dart';
import '../bloc/bank_kyc/bank_kyc_bloc.dart';
import '../bloc/bank_kyc/bank_kyc_event.dart';
import '../bloc/bank_kyc/bank_kyc_state.dart';
import '../model/bank_kyc_model.dart';
import '../repository/bank_kyc_repository.dart';
import '../repository/bank_detail_repository.dart';

class BankKycScreen extends StatefulWidget {
  final String userId;
  const BankKycScreen({super.key, required this.userId});

  @override
  State<BankKycScreen> createState() => _BankKycScreenState();
}

class _BankKycScreenState extends State<BankKycScreen> {
  final TextEditingController accountController = TextEditingController();
  final TextEditingController ifscController = TextEditingController();
  final TextEditingController bankController = TextEditingController();
  final TextEditingController branchController = TextEditingController();

  void _validateAndSubmit(BuildContext context) {
    final account = accountController.text.trim();
    final ifsc = ifscController.text.trim().toUpperCase();
    final bank = bankController.text.trim();
    final branch = branchController.text.trim();

    // Manual validations 🔍
    if (account.isEmpty) {
      showCustomToast('${CustomLogEmoji.fail} Please enter account number');
      return;
    }
    if (account.length < 9 || account.length > 18) {
      showCustomToast('${CustomLogEmoji.fail} Enter valid account number (9–18 digits)');
      return;
    }
    if (ifsc.isEmpty) {
      showCustomToast('${CustomLogEmoji.fail} Please enter IFSC code');
      return;
    }
    final ifscRegex = RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$');
    if (!ifscRegex.hasMatch(ifsc)) {
      showCustomToast('${CustomLogEmoji.fail} Enter valid IFSC code');
      return;
    }
    if (bank.isEmpty) {
      showCustomToast('${CustomLogEmoji.fail} Please enter bank name');
      return;
    }
    if (branch.isEmpty) {
      showCustomToast('${CustomLogEmoji.fail} Please enter branch name');
      return;
    }

    // ✅ All fields valid → submit
    final model = BankKycModel(
      userId: widget.userId,
      accountNumber: account,
      ifsc: ifsc,
      bankName: bank,
      branchName: branch,
    );

    context.read<BankKycBloc>().add(SubmitBankKycEvent(model));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => BankKycBloc(BankKycRepository())),
        BlocProvider(
          create: (_) => BankDetailBloc(BankDetailRepository())
            ..add(FetchBankDetailEvent(widget.userId)),
        ),
      ],
      child: Scaffold(
        appBar: const CustomAppBar(
          title: 'Bank KYC Verification',
          showBackButton: true,
        ),
        body: BlocListener<BankKycBloc, BankKycState>(
          listener: (context, state) {
            if (state is BankKycSuccess) {
              showCustomToast('${CustomLogEmoji.done} Bank KYC Submitted Successfully ✅');
              Navigator.pop(context);
            } else if (state is BankKycError) {
              showCustomToast('${CustomLogEmoji.fail} ${state.message}');
            }
          },
          child: BlocBuilder<BankDetailBloc, BankDetailState>(
            builder: (context, state) {
              if (state is BankDetailLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is BankDetailLoaded) {
                final detail = state.bankDetail;

                accountController.text = detail.accountNumber;
                ifscController.text = detail.ifsc;
                bankController.text = detail.bankName;
                branchController.text = detail.branchName;
              }

              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: BlocBuilder<BankKycBloc, BankKycState>(
                  builder: (context, kycState) {
                    final isLoading = kycState is BankKycLoading;
                    return ListView(
                      children: [
                        const Text(
                          "Fill your bank details carefully 👇",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 20),

                        CustomLabelFormField(
                          context,
                          'Account Number',
                          controller: accountController,
                          keyboardType: TextInputType.number,
                          hint: 'Account Number',
                          isRequired: true,
                        ),
                        const SizedBox(height: 15),

                        CustomLabelFormField(
                          context,
                          'IFSC Code',
                          controller: ifscController,
                          keyboardType: TextInputType.text,
                          hint: 'IFSC Code',
                          isRequired: true,
                        ),
                        const SizedBox(height: 15),

                        CustomLabelFormField(
                          context,
                          'Bank Name',
                          controller: bankController,
                          keyboardType: TextInputType.text,
                          hint: 'Bank Name',
                          isRequired: true,
                        ),
                        const SizedBox(height: 15),

                        CustomLabelFormField(
                          context,
                          'Branch Name',
                          controller: branchController,
                          keyboardType: TextInputType.text,
                          hint: 'Branch Name',
                          isRequired: true,
                        ),
                        const SizedBox(height: 25),

                        CustomButton(
                          isLoading: isLoading,
                          label: 'Submit KYC',
                          onPressed: () => _validateAndSubmit(context),
                        ),
                      ],
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
