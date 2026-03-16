import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:fetchtrue/core/widgets/formate_price.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_amount_text.dart';
import '../../../core/widgets/no_user_sign_widget.dart';
import '../../auth/user_notifier/user_notifier.dart';
import '../../package/bloc/package/package_bloc.dart';
import '../../package/bloc/package/package_event.dart';
import '../../package/bloc/package/package_state.dart';
import '../../package/model/package_model.dart';
import '../../package/repository/package_repository.dart';
import '../bloc/wallet/wallet_bloc.dart';
import '../bloc/wallet/wallet_event.dart';
import '../bloc/wallet/wallet_state.dart';
import '../model/wallet_model.dart';
import '../repository/wallet_repository.dart';
import 'history_screen.dart';

class WalletScreen extends StatefulWidget {
  final String userId;
  const WalletScreen({super.key, required this.userId});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {

  @override
  Widget build(BuildContext context) {

    final userSession = Provider.of<UserSession>(context);
    if (!userSession.isLoggedIn) {
      return Scaffold(
        appBar: CustomAppBar(
          title: 'Wallet',
          showBackButton: true,
        ),
        body: const Center(child: NoUserSignWidget()),
      );
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => WalletBloc(WalletRepository())..add(FetchWalletByUserId(widget.userId)),),
        BlocProvider(create: (_) => PackageBloc(PackageRepository())..add(FetchPackages()),),
      ],
      child: Scaffold(
        backgroundColor: CustomColor.whiteColor,
        appBar: CustomAppBar(title: 'Wallet', showBackButton: true,),

        body:MultiBlocListener(
            listeners:  [
              BlocListener<WalletBloc, WalletState>(
                listener: (context, state) {
                  if (state is WalletError) debugPrint('Wallet Error: ${state.message}');
                },
              ),
              BlocListener<PackageBloc, PackageState>(
                listener: (context, state) {
                  if (state is PackageError) debugPrint('Package Error: ${state.error}');
                },
              )
            ],
            child: Builder(builder: (context) {
              final walletState = context.watch<WalletBloc>().state;
              final packageState = context.watch<PackageBloc>().state;

              if (walletState is WalletLoading || packageState is PackageLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if(walletState is WalletLoaded && packageState is PackageLoaded){
                final wallet = walletState.wallet;
                final package = packageState.packages.first;
                return DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [

                      _buildStatsCard(context, wallet, package, widget.userId),
                      10.height,

                      Container(
                        color: CustomColor.whiteColor,
                        child:TabBar(
                          isScrollable: true,
                          labelColor: CustomColor.appColor,
                          unselectedLabelColor: CustomColor.descriptionColor,
                          indicatorColor: CustomColor.appColor,
                          physics: AlwaysScrollableScrollPhysics(),
                          tabs: const [
                            Tab(text: "Self Earning"),
                            Tab(text: "Team Build"),
                            Tab(text: "Team Revenue"),
                          ],
                        ),
                      ),

                      Expanded(
                        child: Container(
                          color: CustomColor.whiteColor,
                          child: TabBarView(
                            children: [
                              _buildSelfEarning(context),
                              _buildTeamBuildEarning(context),
                              _buildTeamRevenueEarning(context),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return const SizedBox.shrink();

            },)),
      ),
    );
  }

}

/// wallet card
Widget _buildStatsCard(BuildContext context,WalletModel wallet, PackageModel package, String userId) {

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10.0),
    child: Column(
      children: [
        15.height,
        CustomContainer(
          border: true,
          color: CustomColor.whiteColor,
          margin: EdgeInsets.zero,
          // gradient: LinearGradient(colors: [
          //   Color(0xffE8E8E8),
          //   Color(0xffF2F5FF),
          // ],
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          // ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset('assets/image/walletImg.png',),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('My Earnings', style: textStyle14(context),),
                      Text('Weekly Auto-Withdraw', style: TextStyle(fontSize: 10),),
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  CustomAmountText(
                    amount: '${wallet.balance}',
                    fontWeight: FontWeight.w500,
                    fontSize: 22,
                    color: CustomColor.greenColor
                  ),

                  TextButton.icon(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionHistoryScreen(userId: userId,),)),
                      icon: Icon(Icons.history, color: CustomColor.appColor,),
                      label: Text('History', style: textStyle14(context, color: CustomColor.appColor),))
                ],
              )
            ],
          ),
        ),
        10.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: CustomContainer(
                border: true,
                color: CustomColor.whiteColor,
                margin: EdgeInsets.zero,
                // gradient: LinearGradient(colors: [
                //   Color(0xffE8E8E8),
                //   Color(0xffF2F5FF),
                // ],
                //   begin: Alignment.topCenter,
                //   end: Alignment.bottomCenter,
                // ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Earnings', style: textStyle12(context),),
                        Icon(Icons.currency_rupee, color: CustomColor.appColor,),
                      ],
                    ),
                    CustomAmountText(
                        amount: '${wallet.totalCredits}',
                        fontWeight: FontWeight.w500,
                        fontSize: 22,
                        color: CustomColor.greenColor
                    ),

                  ],
                ),
              ),
            ),
            10.width,
            Expanded(
              child: CustomContainer(
                border: true,
                color: CustomColor.whiteColor,
                margin: EdgeInsets.zero,
                // gradient: LinearGradient(colors: [
                //   Color(0xffE8E8E8),
                //   Color(0xffF2F5FF),
                // ],
                //   begin: Alignment.topCenter,
                //   end: Alignment.bottomCenter,
                // ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Monthly Fix Earnings', style: textStyle12(context),),
                        Icon(Icons.currency_rupee, color: CustomColor.appColor,),
                      ],
                    ),
                    CustomAmountText(
                        amount: '${formatPrice(package.monthlyEarnings)}',
                        fontWeight: FontWeight.w500,
                        fontSize: 22,
                        color: CustomColor.greenColor
                    ),

                  ],
                ),
              ),
            ),
          ],
        )
      ],
    ),
  );
}

Widget _buildSelfEarning(BuildContext context) {
  final state = context.watch<WalletBloc>().state;

  List<TransactionModel> transactions = [];
  if (state is WalletLoaded) {
    transactions = state.wallet.transactions.where((tx) {
      return tx.description.toLowerCase().contains('self earning');
    }).toList().reversed.toList();
  }

  if (transactions.isEmpty) {
    return const Center(child: Text('No transactions.'));
  }

  return ListView.builder(
    itemCount: transactions.length,
    padding: const EdgeInsets.symmetric(horizontal: 10),
    itemBuilder: (context, index) {
      final tx = transactions[index];
      final isCredit = tx.type == 'credit';

      return Column(
        children: [
          ListTile(
            minLeadingWidth: 0,
            contentPadding: const EdgeInsets.only(top: 10),
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                isCredit
                    ? CupertinoIcons.arrow_turn_left_down
                    : CupertinoIcons.arrow_turn_left_up,
                color: isCredit ? CustomColor.appColor : CustomColor.redColor,
              ),
            ),
            title: Text('Lead Id: ${tx.leadId}', style: textStyle12(context)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tx.description,
                    style: textStyle12(
                      context,
                      color: CustomColor.descriptionColor,
                      fontWeight: FontWeight.w400,
                    )),
                Text(
                  formatDateTime(tx.createdAt),
                  style: textStyle12(
                    context,
                    color: CustomColor.descriptionColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            trailing: Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('₹ ${tx.amount}',
                      style: textStyle12(context, fontWeight: FontWeight.w500)),
                  Text('${tx.type}',
                      style: textStyle12(context, fontWeight: FontWeight.w400)),
                ],
              ),
            ),
          ),
          const Divider(color: Colors.grey, thickness: 0.3),
        ],
      );
    },
  );
}

Widget _buildTeamBuildEarning(BuildContext context) {
  final state = context.watch<WalletBloc>().state;

  List<TransactionModel> transactions = [];
  if (state is WalletLoaded) {
    transactions = state.wallet.transactions.where((tx) {
      return tx.description.toLowerCase().contains('team build');
    }).toList().reversed.toList();
  }

  if (transactions.isEmpty) {
    return const Center(child: Text('No transactions.'));
  }

  return ListView.builder(
    itemCount: transactions.length,
    padding: const EdgeInsets.symmetric(horizontal: 10),
    itemBuilder: (context, index) {
      final tx = transactions[index];
      final isCredit = tx.type == 'credit';

      return Column(
        children: [
          ListTile(
            minLeadingWidth: 0,
            contentPadding: const EdgeInsets.only(top: 10),
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                isCredit
                    ? CupertinoIcons.arrow_turn_left_down
                    : CupertinoIcons.arrow_turn_left_up,
                color: isCredit ? CustomColor.appColor : CustomColor.redColor,
              ),
            ),
            title: Text('Franchise Id: ${tx.commissionFrom}', style: textStyle12(context)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tx.description,
                    style: textStyle12(
                      context,
                      color: CustomColor.descriptionColor,
                      fontWeight: FontWeight.w400,
                    )),
                Text(
                  formatDateTime(tx.createdAt),
                  style: textStyle12(
                    context,
                    color: CustomColor.descriptionColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            trailing: Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('₹ ${tx.amount}',
                      style: textStyle12(context, fontWeight: FontWeight.w500)),
                  Text('${tx.type}',
                      style: textStyle12(context, fontWeight: FontWeight.w400)),
                ],
              ),
            ),
          ),
          const Divider(color: Colors.grey, thickness: 0.3),
        ],
      );
    },
  );
}

Widget _buildTeamRevenueEarning(BuildContext context) {
  final state = context.watch<WalletBloc>().state;

  List<TransactionModel> transactions = [];
  if (state is WalletLoaded) {
    transactions = state.wallet.transactions.where((tx) {
      return tx.description.toLowerCase().contains('team revenue');
    }).toList().reversed.toList();
  }

  if (transactions.isEmpty) {
    return const Center(child: Text('No transactions.'));
  }

  return ListView.builder(
    itemCount: transactions.length,
    padding: const EdgeInsets.symmetric(horizontal: 10),
    itemBuilder: (context, index) {
      final tx = transactions[index];
      final isCredit = tx.type == 'credit';

      return Column(
        children: [
          ListTile(
            minLeadingWidth: 0,
            contentPadding: const EdgeInsets.only(top: 10),
            leading: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(
                isCredit
                    ? CupertinoIcons.arrow_turn_left_down
                    : CupertinoIcons.arrow_turn_left_up,
                color: isCredit ? CustomColor.appColor : CustomColor.redColor,
              ),
            ),
            title: Text('Lead Id: ${tx.leadId}', style: textStyle12(context)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tx.description,
                    style: textStyle12(
                      context,
                      color: CustomColor.descriptionColor,
                      fontWeight: FontWeight.w400,
                    )),
                Text(
                  formatDateTime(tx.createdAt),
                  style: textStyle12(
                    context,
                    color: CustomColor.descriptionColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            trailing: Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('₹ ${tx.amount}',
                      style: textStyle12(context, fontWeight: FontWeight.w500)),
                  Text('${tx.type}',
                      style: textStyle12(context, fontWeight: FontWeight.w400)),
                ],
              ),
            ),
          ),
          const Divider(color: Colors.grey, thickness: 0.3),
        ],
      );
    },
  );
}
