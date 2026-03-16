import 'package:fetchtrue/core/costants/custom_icon.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/feature/customer/repository/customer_repository.dart';
import 'package:fetchtrue/feature/customer/screen/add_customer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_image.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_appbar.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_snackbar.dart';
import '../../../core/widgets/no_user_sign_widget.dart';
import '../../../helper/Contact_helper.dart';
import '../../auth/user_notifier/user_notifier.dart';
import '../bloc/customer/customer_bloc.dart';
import '../bloc/customer/customer_event.dart';
import '../bloc/customer/customer_state.dart';

class CustomerScreen extends StatefulWidget {
  final bool? isMenu;
  final String? userId;
  const CustomerScreen({super.key, this.isMenu, this.userId});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {

  TextEditingController _searchController = TextEditingController();
  List filteredCustomer = [];


  List<TextEditingController> _messageControllers = [];
  int? _selectedCustomer;

  @override
  void dispose() {
    for (var controller in _messageControllers) {
      controller.dispose();
    }
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final userSession = Provider.of<UserSession>(context);

    if (widget.userId == null || !userSession.isLoggedIn) {
      return Scaffold(
        appBar: CustomAppBar(title: 'Customer List', showBackButton: true,),
        body: const Center(child: NoUserSignWidget()),
      );
    }
    return BlocProvider(
      create: (_) => CustomerBloc(CustomerRepository())..add(GetCustomers()),
      child: Scaffold(
        body: SafeArea(
          child: BlocBuilder<CustomerBloc, CustomerState>(
            builder: (context, state) {
              if (state is CustomerLoading) {
                return LinearProgressIndicator(
                  backgroundColor: CustomColor.appColor,
                  color: CustomColor.whiteColor,
                  minHeight: 2.5,
                );
              }

              else if (state is CustomersLoaded) {

                final customer = state.customers
                    .where((c) => c.user == widget.userId)
                    .toList();

                if (_searchController.text.isEmpty) {
                  filteredCustomer = customer;
                }


                // Initialize _messageControllers safely
                if (_messageControllers.length != customer.length) {
                  _messageControllers = List.generate(
                    customer.length, (index) => TextEditingController(),
                  );
                }
      
                if (customer.isEmpty) {
                  return  Center(child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: CustomColor.whiteColor,
                        radius: 30,backgroundImage: AssetImage(CustomImage.nullImage),),
                      20.height,
                      Text('No Customer.', style: textStyle14(context, color: CustomColor.descriptionColor),),
                    ],
                  ));
                }


                return Column(
                  children: [
                    Container(
                      color: Color(0xFFF5F8FF),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    IconButton(onPressed: () {
                                      Navigator.pop(context);
                                    }, icon: Icon(Icons.arrow_back_ios, color: CustomColor.appColor,size: 18,)),
                                    Text('Customer List',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16,color: CustomColor.appColor),),
                                  ],
                                ),

                                Text('Customer- ${customer.length}',style: TextStyle(fontWeight: FontWeight.w500),)
                              ],
                            ),
                          ),

                          Container(
                            height: 45,
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: _searchController,

                              textInputAction: TextInputAction.search,

                              onSubmitted: (value) {
                                FocusScope.of(context).unfocus();

                                final searchText = normalize(value);

                                setState(() {
                                  _selectedCustomer = null;

                                  filteredCustomer = customer.where((c) {
                                    final customerName = normalize(c.fullName);
                                    return customerName.contains(searchText);
                                  }).toList();
                                });
                              },



                              decoration: InputDecoration(
                                hintText: 'Search customer',
                                hintStyle: TextStyle(color: Colors.grey.shade500),

                                prefixIcon: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Image.asset(
                                    CustomIcon.searchIcon,
                                    height: 18,
                                    width: 18,
                                    color: CustomColor.greyColor,
                                  ),
                                ),

                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 8,
                                ),
                              ),
                            ),
                          ),


                        ],
                      ),
                    ),


                    Expanded(
                      child: filteredCustomer.isEmpty && _searchController.text.isNotEmpty
                          ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off, size: 50, color: Colors.grey),
                            10.height,
                            Text(
                              'Customer not found',
                              style: textStyle14(context, color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                          : ListView.builder(
                        padding: const EdgeInsets.only(top: 8.0),
                        // itemCount: customer.length,
                        itemCount: filteredCustomer.length,

                        itemBuilder: (context, index) {
                          // final data = customer[index];
                          final data = filteredCustomer[index];

                          return CustomContainer(
                            color: CustomColor.whiteColor,
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                           CircleAvatar(
                                             radius: 25,
                                            backgroundImage:
                                            AssetImage(CustomImage.nullImage),
                                          ),
                                          10.width,
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(data.fullName,
                                                  style: textStyle12(context)),
                                              Text('FT ID: ${data.customerId}',
                                                  style: TextStyle(fontSize: 12,
                                                      color: CustomColor
                                                          .descriptionColor)),
                                            ],
                                          ),
                                        ],
                                      ),
                            
                                      widget.isMenu == true ? SizedBox.shrink():
                                      Checkbox(
                                        activeColor: CustomColor.appColor,
                                        value: _selectedCustomer == index,
                                        onChanged: (value) {
                                          setState(() {
                                            _selectedCustomer =
                                            value! ? index : null;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  const Divider(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Phone: ${data.phone}',style: TextStyle(fontSize: 12,color: Colors.grey.shade700),),
                                            Text('Email: ${data.email}',style: TextStyle(fontSize: 12,color: Colors.grey.shade700),),
                                            Text('Address: ${data.address}',style: TextStyle(fontSize: 12,color: Colors.grey.shade700),),
                                          ],
                                        ),
                                      ),


                                      Row(
                                        spacing: 25,
                                        children: [
                                          InkWell(
                                              onTap: () {
                                                ContactHelper.call(data.phone);
                                              },
                                              child: Image.asset(CustomIcon.phoneIcon,height: 25,color: CustomColor.appColor,)),


                                          Padding(
                                            padding: const EdgeInsets.only(right: 16.0),
                                            child: InkWell(
                                                onTap: () {
                                                  ContactHelper.whatsapp('Hello, ${data.fullName}',data.phone);
                                                },
                                                child: Image.asset(CustomIcon.whatsappIcon,height: 25,)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  // 15.height,
                            
                                  widget.isMenu == true ? SizedBox.shrink():
                                  chatInputField(
                                    context,
                                    controller: _messageControllers[index],
                                    onSend: () {
                                      final message = _messageControllers[index].text.trim();
                            
                                      if (_selectedCustomer != null) {
                                        // final selectedCustomer = customer[_selectedCustomer!];
                                        final selectedCustomer = filteredCustomer[_selectedCustomer!];

                                        final selectedCustomerData = {
                                          '_id': selectedCustomer.id,
                                          'userId': selectedCustomer.user,
                                          'fullName': selectedCustomer.fullName,
                                          'phone': selectedCustomer.phone,
                                          'message': message,
                                        };
                                        Navigator.pop(context, selectedCustomerData);
                                      } else {
                                        showCustomSnackBar(context, 'Please select a customer.');
                                      }
                                    },
                                    enabled: _selectedCustomer == index, /// Only selected row is active
                                  ),
                            
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              } else if (state is CustomerFailure) {
                return Center(child: Text(state.error));
              }
              return const SizedBox.shrink();
            },
          ),
        ),

        floatingActionButton: widget.isMenu == true
            ? Builder(
          builder: (context) {
            return FloatingActionButton(
              elevation: 1,
              backgroundColor: CustomColor.whiteColor,
              onPressed: () {
                final customerBloc = context.read<CustomerBloc>();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: customerBloc,
                      child: AddCustomerScreen(userId: userSession.userId),
                    ),
                  ),
                );
              },
              child: Icon(Icons.person, color: CustomColor.appColor),
            );
          },
        )
            : SizedBox.shrink(),

      ),
    );
  }
}

Widget chatInputField(
    BuildContext context, {
      required TextEditingController controller,
      required VoidCallback onSend,
      required bool enabled,
    }) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      10.height,
      Text('Tell us your requirement (Optional)',style: TextStyle(fontSize: 12),),
      10.height,
      Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              enabled: enabled,
              maxLines: null,
              style: textStyle14(
                context,
                color: enabled ? CustomColor.descriptionColor : Colors.grey, // Optional faded text
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                hintText: 'Notes for your query',
                hintStyle: textStyle14(
                  context,
                  color: Colors.grey,
                  fontWeight: FontWeight.w400,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
            ),
          ),
          20.width,
          CustomContainer(
            border: true,
            margin: EdgeInsets.zero,
            color: enabled ? CustomColor.appColor : Colors.transparent,
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            onTap: enabled ? onSend : null,
            child: Center(
              child: Text(
                'Add Now',
                style: textStyle14(
                  context,
                  color: enabled ? Colors.white : Colors.black45,
                ),
              ),
            ),
          )
        ],
      ),
    ],
  );
}


String normalize(String text) {
  return text
      .toLowerCase()
      .replaceAll(RegExp(r'\s+'), '');
}
