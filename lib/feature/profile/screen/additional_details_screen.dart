import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:fetchtrue/core/widgets/custom_snackbar.dart';
import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:fetchtrue/core/widgets/custom_dropdown_field.dart';
import 'package:fetchtrue/core/widgets/custom_text_tield.dart';
import '../bloc/additional_details/additional_details_bloc.dart';
import '../bloc/additional_details/additional_details_event.dart';
import '../bloc/additional_details/additional_details_state.dart';
import '../bloc/user/user_bloc.dart';
import '../bloc/user/user_event.dart';
import '../bloc/user/user_state.dart';
import '../model/user_model.dart';
import '../repository/additinal_details_repository.dart';

class AdditionalDetailsScreen extends StatefulWidget {
  final String user;
  const AdditionalDetailsScreen({super.key, required this.user});

  @override
  State<AdditionalDetailsScreen> createState() =>
      _AdditionalDetailsScreenState();
}

class _AdditionalDetailsScreenState extends State<AdditionalDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController educationController = TextEditingController();
  final TextEditingController professionController = TextEditingController();
  final TextEditingController emergencyContactController =
  TextEditingController();

  String? gender;
  String? maritalStatus;
  final ValueNotifier<String> selectedBloodGroups = ValueNotifier('');
  final List<String> bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'O+',
    'O-',
    'AB+',
    'AB-'
  ];

  bool _isPrefilled = false;

  @override
  void dispose() {
    dobController.dispose();
    educationController.dispose();
    professionController.dispose();
    emergencyContactController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    context.read<UserBloc>().add(GetUserById(widget.user));

    context.read<UserBloc>().stream.listen((state) {
      if ((state is UserLoaded || state is ProfilePhotoUpdated) &&
          !_isPrefilled) {
        final user =
        (state is UserLoaded) ? state.user : (state as ProfilePhotoUpdated).user;
        if (user != null) {
          _prefillForm(user);
          _isPrefilled = true;
        }
      }
    });
  }

  void _prefillForm(UserModel user) {
    setState(() {
      if (user.dateOfBirth != null && user.dateOfBirth!.isNotEmpty) {
        DateTime dob = DateTime.parse(user.dateOfBirth!);
        dobController.text =
        "${dob.year.toString().padLeft(4, '0')}-${dob.month.toString().padLeft(2, '0')}-${dob.day.toString().padLeft(2, '0')}";
      } else {
        dobController.text = '';
      }

      educationController.text = user.education ?? '';
      professionController.text = user.profession ?? '';
      emergencyContactController.text = user.emergencyContact ?? '';
      gender = user.gender?.capitalize();
      maritalStatus = user.maritalStatus?.capitalize();
      selectedBloodGroups.value = user.bloodGroup?.toUpperCase() ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.whiteColor,
      appBar: CustomAppBar(title: 'Additional Details', showBackButton: true),
      body: BlocProvider(
        create: (_) => AdditionalDetailsBloc(
          service: UserAdditionalDetailsService(),
        ),
        child: BlocConsumer<AdditionalDetailsBloc, AdditionalDetailsState>(
          listener: (context, state) {
            if (state is AdditionalDetailsSuccess) {
              showCustomToast('Details updated successfully');
              context.read<UserBloc>().add(GetUserById(widget.user));
            } else if (state is AdditionalDetailsFailure) {
              showCustomToast(state.error);
            }
          },
          builder: (context, state) {
            final isSaving = state is AdditionalDetailsLoading;
        
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    10.height,
                    Text("Gender", style: textStyle16(context)),
                    Row(
                      children: [
                        Radio<String>(
                          value: "Male",
                          groupValue: gender,
                          activeColor: CustomColor.appColor,
                          onChanged: (value) => setState(() => gender = value),
                        ),
                        const Text("Male"),
                        15.width,
                        Radio<String>(
                          value: "Female",
                          groupValue: gender,
                          activeColor: CustomColor.appColor,
                          onChanged: (value) => setState(() => gender = value),
                        ),
                        const Text("Female"),
                        15.width,
                        Radio<String>(
                          value: "Other",
                          groupValue: gender,
                          activeColor: CustomColor.appColor,
                          onChanged: (value) => setState(() => gender = value),
                        ),
                        const Text("Other"),
                      ],
                    ),
                    15.height,
                    Text("Marital Status", style: textStyle16(context)),
                    Row(
                      children: [
                        Radio<String>(
                          value: "Single",
                          groupValue: maritalStatus,
                          activeColor: CustomColor.appColor,
                          onChanged: (value) =>
                              setState(() => maritalStatus = value),
                        ),
                        const Text("Single"),
                        15.width,
                        Radio<String>(
                          value: "Married",
                          groupValue: maritalStatus,
                          activeColor: CustomColor.appColor,
                          onChanged: (value) =>
                              setState(() => maritalStatus = value),
                        ),
                        const Text("Married"),
                      ],
                    ),
                    15.height,
                    ValueListenableBuilder<String>(
                      valueListenable: selectedBloodGroups,
                      builder: (context, value, _) {
                        return CustomDropdownField(
                          headline: "Blood Group",
                          label: "Select Blood Group",
                          items: bloodGroups,
                          selectedValue: selectedBloodGroups,
                        );
                      },
                    ),
                    15.height,
                    CustomLabelFormField(
                      context,
                      'Education',
                      hint: 'Enter here...',
                      controller: educationController,
                      keyboardType: TextInputType.text,
                      isRequired: true,
                    ),
                    15.height,
                    CustomLabelFormField(
                      context,
                      'DOB',
                      hint: 'Year-Month-Day',
                      controller: dobController,
                      keyboardType: TextInputType.text,
                      isRequired: true,
                    ),
                    15.height,
                    CustomLabelFormField(
                      context,
                      'Professional',
                      hint: 'Enter here...',
                      controller: professionController,
                      keyboardType: TextInputType.text,
                      isRequired: true,
                    ),
                    15.height,
                    CustomLabelFormField(
                      context,
                      'Emergency Contact',
                      hint: 'Enter here...',
                      controller: emergencyContactController,
                      keyboardType: TextInputType.number,
                      isRequired: true,
                    ),
                    50.height,
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              "CANCEL",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ),
                        10.width,
                        Expanded(
                          child: CustomContainer(
                            border: true,
                            borderColor: CustomColor.appColor,
                            color: CustomColor.whiteColor,
                            onTap: isSaving
                                ? null
                                : () {
                              if (_formKey.currentState!.validate()) {
                                if (gender == null || gender!.isEmpty) {
                                  showCustomToast(
                                      'Please select gender');
                                  return;
                                }
                                if (maritalStatus == null ||
                                    maritalStatus!.isEmpty) {
                                  showCustomToast(
                                      'Please select marital status');
                                  return;
                                }
                                if (selectedBloodGroups.value.isEmpty) {
                                  showCustomToast(
                                      'Please select blood group');
                                  return;
                                }
                                // DOB validation
                                if (dobController.text.isEmpty) {
                                  showCustomToast(
                                      'Please enter date of birth in Year-Month-Day format');
                                  return;
                                }
                                final dobRegex =
                                RegExp(r'^\d{4}-\d{2}-\d{2}$');
                                if (!dobRegex
                                    .hasMatch(dobController.text.trim())) {
                                  showCustomToast(
                                      'Invalid DOB format! Use Year-Month-Day (YYYY-MM-DD)');
                                  return;
                                }
        
                                if (educationController.text
                                    .trim()
                                    .isEmpty) {
                                  showCustomToast(
                                      'Please enter education details');
                                  return;
                                }
                                if (professionController.text
                                    .trim()
                                    .isEmpty) {
                                  showCustomToast(
                                      'Please enter profession');
                                  return;
                                }
                                if (emergencyContactController.text
                                    .trim()
                                    .length !=
                                    10 ||
                                    !RegExp(r'^\d+$').hasMatch(
                                        emergencyContactController.text
                                            .trim())) {
                                  showCustomToast(
                                      'Please enter valid 10-digit emergency contact number');
                                  return;
                                }
        
                                final data = {
                                  "gender": gender?.toLowerCase(),
                                  "maritalStatus":
                                  maritalStatus?.toLowerCase(),
                                  "bloodGroup": selectedBloodGroups.value
                                      .toLowerCase(),
                                  "dateOfBirth": dobController.text.trim(),
                                  "education":
                                  educationController.text.trim(),
                                  "profession":
                                  professionController.text.trim(),
                                  "emergencyContact":
                                  emergencyContactController.text.trim(),
                                };
        
                                context
                                    .read<AdditionalDetailsBloc>()
                                    .add(UpdateAdditionalDetailsEvent(
                                  userId: widget.user,
                                  data: data,
                                ));
                              }
                            },
                            child: Center(
                              child: isSaving
                                  ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(),
                              )
                                  : Text("SAVE", style: textStyle16(context)),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

extension StringCasing on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
