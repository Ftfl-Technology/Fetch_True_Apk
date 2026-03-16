import 'package:fetchtrue/core/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:fetchtrue/core/widgets/custom_text_tield.dart';
import '../../customer/widget/india_state_city_picker.dart';
import '../bloc/add_address/add_address_bloc.dart';
import '../bloc/add_address/add_address_event.dart';
import '../bloc/add_address/add_address_state.dart';
import '../bloc/user/user_bloc.dart';
import '../bloc/user/user_event.dart';
import '../bloc/user/user_state.dart';
import '../model/user_model.dart';
import '../repository/add_address_repository.dart';
import '../model/address_model.dart';

class AddAddressScreen extends StatefulWidget {
  final UserModel user;
  const AddAddressScreen({super.key, required this.user});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final TextEditingController houseNumberController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();
  final TextEditingController fullAddressController = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();
  final TextEditingController countryController = TextEditingController(text: "India");

  final List<String> labels = ['homeAddress', 'workAddress', 'otherAddress'];
  final List<IconData> icons = [Icons.home, Icons.work, Icons.location_pin];
  final Map<String, String> displayLabels = {
    'homeAddress': 'Home',
    'workAddress': 'Work',
    'otherAddress': 'Other',
  };

  int selectedIndex = 0;
  String? selectedState;
  String? selectedCity;

  @override
  void initState() {
    super.initState();
    _populateInitialData(widget.user);
  }

  void _populateInitialData(UserModel user) {
    Address? defaultAddress = user.homeAddress ?? user.workAddress ?? user.otherAddress;
    houseNumberController.text = defaultAddress?.houseNumber ?? '';
    landmarkController.text = defaultAddress?.landmark ?? '';
    fullAddressController.text = defaultAddress?.fullAddress ?? '';
    pinCodeController.text = defaultAddress?.pinCode ?? '';
    countryController.text = defaultAddress?.country ?? 'India';
    selectedState = defaultAddress?.state ?? 'Select State';
    selectedCity = defaultAddress?.city ?? 'Select City';
  }

  @override
  void dispose() {
    houseNumberController.dispose();
    landmarkController.dispose();
    fullAddressController.dispose();
    pinCodeController.dispose();
    countryController.dispose();
    super.dispose();
  }

  void _saveAddress(BuildContext context) {
    final userAddress = UserAddress(
      houseNumber: houseNumberController.text,
      landmark: landmarkController.text,
      state: selectedState ?? '',
      city: selectedCity ?? '',
      pinCode: pinCodeController.text,
      country: countryController.text,
      fullAddress: fullAddressController.text,
    );

    final addressModel = AddressModel(
      addressType: labels[selectedIndex],
      address: userAddress,
    );

    context.read<AddressBloc>().add(
      AddOrUpdateAddressEvent(
        userId: widget.user.id,
        addressModel: addressModel,
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddressBloc(AddressRepository()),
      child: MultiBlocListener(
        listeners: [
          BlocListener<AddressBloc, AddressState>(
            listener: (context, state) {
              if (state is AddressSuccess) {
                showCustomToast(state.message);
                context.read<UserBloc>().add(GetUserById(widget.user.id));              } else if (state is AddressFailure) {
              }
              else if(state is AddressFailure){
                showCustomToast(state.error);
              }
            },
          ),
          BlocListener<UserBloc, UserState>(
            listener: (context, state) {
              if (state is UserLoaded) {
                _populateInitialData(state.user);
              }
            },
          ),
        ],
        child: BlocBuilder<AddressBloc, AddressState>(
          builder: (context, state) {
            final isLoading = state is AddressLoading;
            return Scaffold(
              backgroundColor: CustomColor.whiteColor,
              appBar: const CustomAppBar(title: 'Add Address', showBackButton: true),
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // House & Landmark
                      Row(
                        children: [
                          Expanded(
                            child: CustomLabelFormField(
                              context,
                              'House/Flat/Floor Number',
                              controller: houseNumberController,
                              hint: 'Enter here...',
                              keyboardType: TextInputType.text,
                              isRequired: true,
                            ),
                          ),
                          10.width,
                          Expanded(
                            child: CustomLabelFormField(
                              context,
                              'Landmark',
                              controller: landmarkController,
                              hint: 'Enter here...',
                              keyboardType: TextInputType.text,
                              isRequired: true,
                            ),
                          ),
                        ],
                      ),
                      15.height,
                      CustomLabelFormField(
                        context,
                        'Complete Address',
                        controller: fullAddressController,
                        hint: 'Enter here...',
                        keyboardType: TextInputType.text,
                        isRequired: true,
                      ),
                      15.height,
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
                      15.height,
                      Row(
                        children: [
                          Expanded(
                            child: CustomLabelFormField(
                              context,
                              'Pin Code',
                              controller: pinCodeController,
                              hint: 'Enter here...',
                              keyboardType: TextInputType.number,
                              isRequired: true,
                            ),
                          ),
                          10.width,
                          Expanded(
                            child: CustomLabelFormField(
                              context,
                              "Country",
                              controller: countryController,
                              isRequired: true,
                              hint: 'India',
                              enabled: false,
                              keyboardType: TextInputType.text,
                            ),
                          ),
                        ],
                      ),
                      25.height,
                      Text('Save As', style: textStyle16(context)),
                      10.height,
                      Row(
                        children: List.generate(
                          labels.length,
                              (index) {
                            final labelKey = labels[index];
                            return CustomContainer(
                              border: true,
                              color: CustomColor.whiteColor,
                              borderColor: selectedIndex == index
                                  ? CustomColor.appColor
                                  : Colors.grey.shade400,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              margin: const EdgeInsets.only(right: 10),
                              onTap: () {
                                setState(() {
                                  selectedIndex = index;
                                  final userState = context.read<UserBloc>().state;
                                  Address? selectedAddress;
                                  if (userState is UserLoaded) {
                                    final user = userState.user;
                                    if (labelKey == 'homeAddress') selectedAddress = user.homeAddress;
                                    if (labelKey == 'workAddress') selectedAddress = user.workAddress;
                                    if (labelKey == 'otherAddress') selectedAddress = user.otherAddress;
                                  }

                                  houseNumberController.text = selectedAddress?.houseNumber ?? '';
                                  landmarkController.text = selectedAddress?.landmark ?? '';
                                  fullAddressController.text = selectedAddress?.fullAddress ?? '';
                                  pinCodeController.text = selectedAddress?.pinCode ?? '';
                                  countryController.text = selectedAddress?.country ?? 'India';
                                  selectedState = selectedAddress?.state ?? '';
                                  selectedCity = selectedAddress?.city ?? '';
                                });
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    icons[index],
                                    color: selectedIndex == index ? CustomColor.appColor : Colors.grey,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    displayLabels[labelKey]!,
                                    style: textStyle14(context),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      50.height,
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: isLoading ? null : () => Navigator.pop(context),
                              child: const Text("CANCEL", style: TextStyle(color: Colors.red)),
                            ),
                          ),
                          10.width,
                          Expanded(
                            child: CustomContainer(
                              border: true,
                              borderColor: CustomColor.appColor,
                              color: CustomColor.whiteColor,
                              onTap: isLoading ? null : () => _saveAddress(context),
                              child: Center(
                                child: isLoading
                                    ? const CircularProgressIndicator()
                                    : Text("SAVE", style: textStyle16(context)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      10.height,
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
