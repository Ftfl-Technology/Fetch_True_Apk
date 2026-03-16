import 'package:fetchtrue/core/widgets/custom_text_tield.dart';
import 'package:fetchtrue/feature/customer/repository/customer_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_snackbar.dart';
import '../../../core/widgets/no_user_sign_widget.dart';
import '../../auth/user_notifier/user_notifier.dart';
import '../bloc/customer/customer_bloc.dart';
import '../bloc/customer/customer_event.dart';
import '../bloc/customer/customer_state.dart';
import '../model/add_customer_model.dart';
import '../widget/india_state_city_picker.dart';

class AddCustomerScreen extends StatefulWidget {
  final String? userId;
  const AddCustomerScreen({super.key, this.userId});

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {

  final _formKey = GlobalKey<FormState>();
  final fullName = TextEditingController();
  final phone = TextEditingController();
  final email = TextEditingController();
  final description = TextEditingController();
  final address = TextEditingController();
  final country = TextEditingController(text: "India");


  String? selectedState;
  String? selectedCity;

  void _submitForm(BuildContext context) {
    if (fullName.text.trim().isEmpty) {
      showCustomToast("Name is required");
      return;
    } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(fullName.text.trim())) {
      showCustomToast("Please enter valid name");
      return;
    }

    if (phone.text.trim().isEmpty) {
      showCustomToast("Phone number is required");
      return;
    } else if (phone.text.trim().length != 10 ||
        !RegExp(r'^[0-9]+$').hasMatch(phone.text.trim())) {
      showCustomToast("Enter a valid 10-digit phone number");
      return;
    }

    if (email.text.trim().isEmpty) {
      showCustomToast("Email is required");
      return;
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
        .hasMatch(email.text.trim())) {
      showCustomToast("Enter a valid email address");
      return;
    }

    if (address.text.trim().isEmpty) {
      showCustomToast("Address is required");
      return;
    }

    if (selectedState == null || selectedState!.isEmpty) {
      showCustomToast("Please select a State");
      return;
    }

    if (selectedCity == null || selectedCity!.isEmpty) {
      showCustomToast("Please select a City");
      return;
    }

    final newCustomer = AddCustomerModel(
      fullName: fullName.text.trim(),
      phone: phone.text.trim(),
      email: email.text.trim(),
      description: description.text.trim(),
      address: address.text.trim(),
      city: selectedCity.toString(),
      state: selectedState.toString(),
      country: country.text.trim().isEmpty ? "India" : country.text.trim(),
      user: widget.userId.toString(),
    );

    context.read<CustomerBloc>().add(CreateCustomer(newCustomer));

  }


  @override
  void dispose() {
    fullName.dispose();
    phone.dispose();
    email.dispose();
    address.dispose();
    country.dispose();
    description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);

    final userSession = Provider.of<UserSession>(context);

    if (widget.userId == null || !userSession.isLoggedIn) {
      return Scaffold(
        appBar: CustomAppBar(title: 'Add New Customer', showBackButton: true,),
        body: const Center(child: NoUserSignWidget()),
      );
    }


    return BlocProvider(
      create: (_) => CustomerBloc(CustomerRepository()),
      child: Scaffold(
      backgroundColor: CustomColor.whiteColor,
      appBar: CustomAppBar(title: 'Add New Customer', showBackButton: true,),

      body:  BlocConsumer<CustomerBloc, CustomerState>(
          listener: (context, state) {
            if (state is CustomerSuccess) {

              showCustomToast("Customer Created: ${state.customer.fullName}");
              context.read<CustomerBloc>().add(const GetCustomers());
              Navigator.pop(context, {
                "_id": state.customer.id,
                "userId": state.customer.user,
                "fullName": state.customer.fullName,
                "phone": state.customer.phone,
                "message": state.customer.description,
              });

            } else if (state is CustomerFailure) {
              showCustomToast(state.error);
            }
          },
        builder:  (context, state) {
          return SafeArea(child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  15.height,
                  CustomLabelFormField(context, "Name", isRequired: true,
                      hint: 'Enter Name...',
                      controller: fullName,
                      icon: Icons.person_outline,
                      keyboardType: TextInputType.text),
                  10.height,

                  CustomLabelFormField(context, "Phone", isRequired: true,
                      hint: 'Enter Phone No...',
                      icon: Icons.call_outlined,
                      controller: phone,
                      keyboardType: TextInputType.number),
                  15.height,

                  CustomLabelFormField(context, "Email", isRequired: true,
                    hint: 'Enter Email Id...',
                    icon: Icons.email_outlined,
                    controller: email,
                    keyboardType: TextInputType.text,),
                  15.height,

                  CustomDescriptionField(context,
                    "Description (Optional)",
                    controller: description,
                    isRequired: false,
                    hint: "Enter full details here...",
                  ),
                  15.height,

                  CustomLabelFormField(context, "Address", isRequired: true,
                      hint: 'Enter Service Address...',
                      icon: Icons.location_on_outlined,
                      controller: address,
                      keyboardType: TextInputType.text),
                  10.height,

                  IndiaStateCityPicker(
                    initialState: selectedState,
                    initialCity: selectedCity,
                    onStateChanged: (state) {
                      setState(() {
                        selectedState = state;
                        selectedCity = null;
                      });
                    },
                    onCityChanged: (city) {
                      setState(() {
                        selectedCity = city;
                      });
                    },
                  ),
                  10.height,

                  CustomLabelFormField(context, "Country", isRequired: true,
                      hint: 'India',
                      enabled: false,
                      controller: country,
                      keyboardType: TextInputType.text),
                  SizedBox(height: dimensions.screenHeight * 0.04,),

                  CustomButton(
                    label: 'Save Data',
                    isLoading: state is CustomerLoading,
                    onPressed: () {
                      _submitForm(context);
                    },
                  ),
                  20.height

                ],
              ),
            ),
          ));
        }
      ),
    ),
);
  }
}
