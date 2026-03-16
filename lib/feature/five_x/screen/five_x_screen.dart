import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:fetchtrue/core/widgets/formate_price.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../auth/user_notifier/user_notifier.dart';
import '../../lead/bloc/lead/lead_bloc.dart';
import '../../lead/bloc/lead/lead_state.dart';
import '../../lead/model/lead_model.dart';
import '../../my_wallet/bloc/wallet/wallet_bloc.dart';
import '../../my_wallet/bloc/wallet/wallet_event.dart';
import '../../my_wallet/bloc/wallet/wallet_state.dart';
import '../../my_wallet/model/wallet_model.dart';
import '../../my_wallet/repository/wallet_repository.dart';
import '../../profile/bloc/user/user_bloc.dart';
import '../../profile/bloc/user/user_state.dart';
import '../../profile/model/user_model.dart';
import '../bloc/five_x/fivex_bloc.dart';
import '../bloc/five_x/fivex_event.dart';
import '../bloc/five_x/fivex_state.dart';
import '../model/FiveXModel.dart';
import '../repository/fivex_repository.dart';


class FiveXScreen extends StatelessWidget {
  const FiveXScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userSession = Provider.of<UserSession>(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => WalletBloc(WalletRepository())..add(FetchWalletByUserId(userSession.userId!))),
        BlocProvider(create: (_) => FiveXBloc(FiveXRepository())..add(FetchFiveX())),
      ],
      child: Scaffold(
        appBar: CustomAppBar(title: '5X Guarantee',showBackButton: true,),

        body:BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if(state is UserLoading){return  CircularProgressIndicator();}
            else if (state is UserLoaded) {
              final user = state.user;
              return MultiBlocListener(
                listeners: [
                  BlocListener<LeadBloc, LeadState>(listener: (context, state) {
                    if (state is LeadError) debugPrint('Lead Error: ${state.message}');
                  },),
                  BlocListener<WalletBloc, WalletState>(listener: (context, state) {
                    if (state is WalletError) debugPrint('Wallet Error: ${state.message}');
                  },),
                  BlocListener<FiveXBloc, FiveXState>(listener: (context, state) {
                    if (state is FiveXError) debugPrint('FiveX Error: ${state.message}');
                  },),
                ],
                child: Builder(
                  builder: (context) {
                    final fiveXState = context.watch<FiveXBloc>().state;
                    final leadState = context.watch<LeadBloc>().state;
                    final walletState = context.watch<WalletBloc>().state;

                    if (fiveXState is FiveXLoading || leadState is LeadLoading || walletState is WalletLoading) {
                      return  Center(child: CircularProgressIndicator(color: CustomColor.appColor,));
                    }

                    if(fiveXState is FiveXLoaded && leadState is LeadLoaded && walletState is WalletLoaded){
                      final fiveX = fiveXState.data;
                      final lead = leadState.allLeads;
                      final wallet = walletState.wallet;

                      return SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              CustomContainer(
                                border: true,
                                color: Colors.blue.withOpacity(0.1),
                                child:  Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('📅  Package Activated:', style: textStyle12(context, fontWeight: FontWeight.w400, color: CustomColor.appColor),),5.width,
                                    Text('${formatDateTime(user.packageActivateDate)}', style: textStyle12(context, fontWeight: FontWeight.w400,color: CustomColor.blackColor),),
                                  ],
                                ),
                              ),
                              CustomContainer(
                                color: CustomColor.whiteColor,
                                margin: EdgeInsets.zero,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    20.height,

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        _buildLevelProgressCard(context,fiveX.first, lead,user),
                                        _buildEarningProgressCard(context,fiveX.first, lead,user, wallet),
                                      ],
                                    ),
                                    10.height,

                                    _buildEligible(context,fiveX.first, user),
                                  ],
                                ),
                              ),

                              10.height,

                              _buildLEL(context, fiveX.first,lead,wallet)
                            ],
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }
                ),
              );
            } else if (state is UserError) {
              debugPrint('Error: ${state.massage}');

            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildLevelProgressCard(BuildContext context, FiveXModel? fiveX, List<LeadModel> completedLeads, UserModel user) {

    final lead = completedLeads.length; // Actual leads count
    final target = fiveX?.leadcount ?? 1; // Target leads
    final progress = (lead / target).clamp(0.0, 1.0);
    final percentage = ((lead / target) * 100).clamp(0, 100).toStringAsFixed(1);
    final xLevel = (progress * 5).round().clamp(0, 5);

    return Column(
      children: [
        Text('Level Progress', style: textStyle12(context, fontWeight: FontWeight.w400, color: CustomColor.greenColor),),
        20.height,

        Stack(
          alignment: Alignment.center,
          children: [
            HalfCircleProgress(
              progress: progress,
              size: 140,
              backgroundColor: Colors.grey.shade300,
              progressColor: Colors.green,
            ),
            Text('${xLevel == 0 ? "1":xLevel}X', style: textStyle12(context,color: CustomColor.greenColor),)
          ],
        ),

        Center(child: Text('Progress: $percentage%', style: textStyle12(context, fontWeight: FontWeight.w400, color: CustomColor.descriptionColor))),

      ],
    );
  }
  Widget _buildEarningProgressCard(BuildContext context, FiveXModel? fiveX, List<LeadModel> completedLeads, UserModel user,  WalletModel wallet) {
    final earning = wallet.balance ?? 0;
    final target = fiveX?.fixearning ?? 1;

    final progress = (earning / target).clamp(0.0, 1.0);

    final percentage = ((earning / target) * 100).clamp(0, 100).toStringAsFixed(1);

    return Column(
      children: [
        Text('Earning Progress', style: textStyle12(context, fontWeight: FontWeight.w400, color: CustomColor.appColor),),
        20.height,

        Stack(
          alignment: Alignment.center,
          children: [
            HalfCircleProgress(
              progress: progress,
              size: 140,
              backgroundColor: Colors.grey.shade300,
              progressColor: CustomColor.appColor,
            ),
            Text('₹ ${wallet.totalCredits}', style: textStyle12(context,color: CustomColor.appColor),)
          ],
        ),

        Center(child: Text('Progress: $percentage%', style: textStyle12(context, fontWeight: FontWeight.w400))),

      ],
    );
  }

  Widget _buildEligible(BuildContext context, FiveXModel? fiveX, UserModel user) {
    DateTime? createdAt;
    try {
      createdAt = DateTime.parse(user.createdAt.toString());
    } catch (e) {
      createdAt = DateTime.now();
    }

    final targetMonths = fiveX?.months ?? 0;
    final now = DateTime.now();

    // Full months calculation (partial months ignored)
    int completedMonths = (now.year - createdAt.year) * 12 + (now.month - createdAt.month);

    // If day of month not reached yet, reduce completedMonths by 1
    if (now.day < createdAt.day) {
      completedMonths--;
    }

    int remainingMonths = targetMonths - completedMonths;
    if (remainingMonths < 0) remainingMonths = 0;

    // Remaining days calculation
    DateTime completionDate = DateTime(createdAt.year, createdAt.month + targetMonths, createdAt.day);
    int remainingDays = completionDate.difference(now).inDays;
    if (remainingDays < 0) remainingDays = 0;

    return CustomContainer(
      border: true,
      color: CustomColor.whiteColor,
      child: Text(
        remainingMonths > 0
            ? '⏳ Are you eligible? — Yes, Remaining $remainingMonths months'
            : '✅ Eligibility period completed',
        style: const TextStyle(fontSize: 14),
      ),
    );
  }

  // Widget _buildEligible(BuildContext context, FiveXModel? fiveX, UserModel user) {
  //   final createdAt = DateTime.parse(user.createdAt.toString());
  //   final targetMonths = fiveX?.months ?? 0;
  //   final now = DateTime.now();
  //   int completedMonths = (now.year - createdAt.year) * 12 + (now.month - createdAt.month);
  //   int remainingMonths = targetMonths - completedMonths;
  //   if (remainingMonths < 0) remainingMonths = 0;
  //
  //   return CustomContainer(
  //     border: true,
  //     color: CustomColor.whiteColor,
  //     child: Text('⏳ Are you eligible? — Yes, Remaining $remainingMonths Months'),
  //   );
  // }


  Widget _buildLEL(BuildContext context, FiveXModel? fiveX, List<LeadModel> completedLeads, WalletModel wallet){
    final count = completedLeads.length ?? 0; // actual count
    final maxCount = fiveX?.leadcount ?? 1;
    final progress = (count / maxCount).clamp(0.0, 1.0);
    final percentage = (progress * 100).round();

    final xLevel = (progress * 5).round().clamp(0, 5);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildCard(context,'Current Level', '${xLevel==0?'1':xLevel}X', Colors.blue.shade50),
        _buildCard(context,'Total Earnings', '₹ ${wallet.balance}/${fiveX!.fixearning}', Colors.green.shade50),
        _buildCard(context,'Total Leads', '${completedLeads.length}/${fiveX.leadcount}', Colors.amber.shade50),
      ],
    );
  }

  Widget _buildCard(BuildContext context,String headline, String value, Color cardColor){
    return  CustomContainer(
      border: true,
      margin: EdgeInsets.zero,
      color: cardColor,
      child: Column(
        children: [
          Text(headline, style: textStyle12(context, fontWeight: FontWeight.w400),),
          Text(value, style: textStyle12(context),)
        ],
      ),
    );
  }
}

class HalfCircleProgress extends StatelessWidget {
  final double progress; // 0.0 - 1.0
  final double size;
  final Color backgroundColor;
  final Color progressColor;

  const HalfCircleProgress({
    super.key,
    required this.progress,
    this.size = 80,
    this.backgroundColor = Colors.grey,
    this.progressColor = Colors.green,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size / 2, // Half circle
      child: CustomPaint(
        painter: _HalfCirclePainter(
          progress: progress,
          backgroundColor: backgroundColor,
          progressColor: progressColor,
        ),
      ),
    );
  }
}

class _HalfCirclePainter extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final Color progressColor;

  _HalfCirclePainter({
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height * 2);
    final startAngle = -3.14; // start from left
    final sweepAngle = 3.14; // 180 degree half circle

    // Background
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10;
    canvas.drawArc(rect, startAngle, sweepAngle, false, bgPaint);

    // Progress
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, startAngle, sweepAngle * progress, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
