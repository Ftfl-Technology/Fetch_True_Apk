import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_container.dart';
import '../../my_wallet/bloc/wallet/wallet_bloc.dart';
import '../../my_wallet/bloc/wallet/wallet_event.dart';
import '../../my_wallet/bloc/wallet/wallet_state.dart';
import '../../my_wallet/repository/wallet_repository.dart';

class WalletCardWidget extends StatefulWidget {
  final String userId;
  final Function(double walletAmount)? onWalletApplied;

  const WalletCardWidget({
    super.key,
    required this.userId,
    this.onWalletApplied,
  });

  @override
  State<WalletCardWidget> createState() => _WalletCardWidgetState();
}

class _WalletCardWidgetState extends State<WalletCardWidget> {
  bool isWalletApplied = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WalletBloc(WalletRepository())..add(FetchWalletByUserId(widget.userId)),
      child: BlocBuilder<WalletBloc, WalletState>(
        builder: (context, state) {
          if (state is WalletLoading) {
            return Center(child: const CircularProgressIndicator());
          } else if (state is WalletLoaded) {
            final wallet = state.wallet;

            return CustomContainer(
              color: CustomColor.whiteColor,
              margin: EdgeInsets.zero,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('₹ ${wallet.balance.toStringAsFixed(2)}', style: textStyle16(context, color: CustomColor.appColor, fontWeight: FontWeight.w600),),
                      Text(
                        'Wallet Balance',
                        style: textStyle14(
                          context,
                          color: CustomColor.descriptionColor,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  Checkbox(
                    activeColor: CustomColor.appColor,
                    value: isWalletApplied,
                    onChanged: (value) {
                      setState(() {
                        isWalletApplied = value ?? false;
                      });

                      if (isWalletApplied) {
                        widget.onWalletApplied?.call(wallet.balance);
                      } else {
                        widget.onWalletApplied?.call(0);
                      }
                    },
                  ),
                ],
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
