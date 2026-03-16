import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:fetchtrue/core/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/no_user_sign_widget.dart';
import '../../auth/user_notifier/user_notifier.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../profile/bloc/user/user_bloc.dart';
import '../../profile/bloc/user/user_event.dart';
import '../../profile/bloc/user/user_state.dart';
import '../../profile/model/user_model.dart';
import '../../provider/model/service_wise_provider_subscriber_model.dart';
import '../bloc/checkout/checkout_bloc.dart';
import '../bloc/commission/commission_bloc.dart';
import '../bloc/commission/commission_event.dart';
import '../bloc/commission/commission_state.dart';
import '../bloc/payu_gateway/payu_gateway_bloc.dart';
import '../model/checkout_model.dart';
import '../model/commission_model.dart';
import '../repository/checkout_repository.dart';
import '../repository/payu_gateway_repository.dart';
import '../steps/complete_step.dart';
import '../steps/details_step.dart';
import '../steps/payment_step.dart';



class CheckOutScreen extends StatefulWidget {
  final String serviceId;
  final ProviderSubscriberModel? provider;
  final SelectedServiceData? serviceData;
  const CheckOutScreen({super.key, required this.serviceId, this.provider, this.serviceData});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {

  int currentStep = 0;
  CheckOutModel? checkoutModel;

  @override
  Widget build(BuildContext context) {
    final userSession = Provider.of<UserSession>(context, listen: true);


    if (!userSession.isLoggedIn || userSession.userId == null) {
      return Scaffold(
        appBar: CustomAppBar(title: 'Check Out', showBackButton: true),
        body: const Center(child: NoUserSignWidget()),
      );
    }


    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => CommissionBloc()..add(GetCommission())),
        BlocProvider(create: (_) => CheckoutBloc(repository: CheckOutRepository())),
        BlocProvider(create: (_) => PayUGatewayBloc(PayUGatewayRepository()))

      ],
      child: Scaffold(
        backgroundColor: Color(0xFFF9F9F9),
        appBar: CustomAppBar(title: 'Check Out',showBackButton: true,),

        body:BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {

            if (state is UserInitial) {
              context.read<UserBloc>().add(GetUserById(userSession.userId!));
              return  SizedBox.shrink();
            }
            else if(state is UserLoading){
              return  SizedBox.shrink();
            }
            else if (state is UserLoaded) {
              final user = state.user;

              return BlocBuilder<CommissionBloc, CommissionState>(
                builder: (context, state) {
                  if (state is CommissionLoading) {
                    return LinearProgressIndicator(backgroundColor: CustomColor.appColor, color: CustomColor.whiteColor ,minHeight: 2.5,);
                  } else if (state is CommissionLoaded) {
                    final commissionCharge = state.commission;
                    return SafeArea(
                      child: Column(
                        children: [
                          StepHeader(currentStep: currentStep,),
                          Expanded(child: _buildStep(user: user, provider: widget.provider, serviceData: widget.serviceData!, commissionCharge: commissionCharge)),
                        ],
                      ),
                    );
                  } else if (state is CommissionError) {
                    print(state.message);
                  }
                  return Container();
                },
              );


            } else if (state is UserError) {
              print('Error: ${state.massage}');
              return SizedBox.shrink();
            }
            return SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildStep({
    required UserModel user,
    ProviderSubscriberModel? provider,
    required SelectedServiceData serviceData,
    required CommissionModel commissionCharge
  }) {

    switch (currentStep) {
      case 0:
        return DetailsStep(
          key: detailsKey,
          user: user,
          provider: provider,
          serviceData: serviceData,
          commissionCharge: commissionCharge,
          onProceed: (model) {
            setState(() {
              checkoutModel = model;
              currentStep = 1;
            });
          },
        );
      case 1:
        return PaymentStep(
          user: user,
          checkoutModel: checkoutModel!,
          onPaySuccess: (updatedModel) {
            setState(() {
              checkoutModel = updatedModel;
              currentStep = 2;
            });
          },
        );

      case 2:
        return  CompleteStep(
          checkoutModel: checkoutModel!,
        );
      default:
        return const SizedBox();
    }
  }
}


class StepHeader extends StatelessWidget {
  final int currentStep;
  const StepHeader({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _StepItem(title: "Details", index: 0, current: currentStep),
          _Line(),
          _StepItem(title: "Payment", index: 1, current: currentStep),
          _Line(),
          _StepItem(title: "Complete", index: 2, current: currentStep),
        ],
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  final String title;
  final int index;
  final int current;

  const _StepItem({
    required this.title,
    required this.index,
    required this.current,
  });

  IconData get _icon {
    switch (index) {
      case 0:
        return Icons.description_outlined;
      case 1:
        return Icons.account_balance_wallet_outlined;
      case 2:
        return Icons.check_circle_outline;
      default:
        return Icons.circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = current > index;
    final isActive = current == index;

    return Column(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: isCompleted || isActive
              ? CustomColor.appColor
              : Colors.grey.shade300,
          child: Icon(
            isCompleted
                ? Icons.check
                : _icon,
            size: 16,
            color: isCompleted || isActive
                ? Colors.white
                : Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: isCompleted || isActive
                ? CustomColor.appColor
                : Colors.grey,
          ),
        ),
      ],
    );
  }
}

class _Line extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 1,
        color: Colors.grey,
      ),
    );
  }
}


class SelectedServiceData {
  final String serviceId;
  final String serviceThumbnail;
  final String serviceName;
  final String price;
  final String discountPrice;
  final String discount;
  final String serviceGST;
  final String rating;
  final String review;
  final String categoryName;
  final String earnUpTo;

  SelectedServiceData({
    required this.serviceId,
    required this.serviceThumbnail,
    required this.serviceName,
    required this.price,
    required this.discountPrice,
    required this.discount,
    required this.serviceGST,
    required this.rating,
    required this.review,
    required this.categoryName,
    required this.earnUpTo,
  });
}


