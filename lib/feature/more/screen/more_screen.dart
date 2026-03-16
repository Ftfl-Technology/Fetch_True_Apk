import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/feature/auth/sharedPref/intro_sharedpref.dart';
import 'package:fetchtrue/feature/five_x/screen/five_x_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:fetchtrue/feature/about_us/screen/aboutus_screen.dart';
import 'package:fetchtrue/feature/customer/screen/customer_screen.dart';
import 'package:fetchtrue/feature/more/widget/profile_card_widget.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/custom_url_launch.dart';
import '../../auth/screen/auth_screen.dart';
import '../../auth/user_notifier/user_notifier.dart';
import '../../coupon/screen/all_coupon_screen.dart';
import '../../coupon/screen/coupon_screen.dart';
import '../../delete_account/screen/delete_account_screen.dart';
import '../../favorite/screen/favorite_screen.dart';
import '../../help_support/screen/help_support_screen.dart';
import '../../internet/network_wrapper_screen.dart';
import '../../my_wallet/screen/wallet_screen.dart';
import '../../notification/screen/notification_screen.dart';
import '../../package/screen/package_screen.dart';
import '../../profile/bloc/user/user_bloc.dart';
import '../../profile/bloc/user/user_event.dart';
import '../../profile/screen/profile_screen.dart';
import '../../provider/screen/provider_screen.dart';
import '../../rating_review/screen/ratting_review_screen.dart';
import '../../settings/screen/setting_screen.dart';
import '../../team_build/screen/team_build_screen.dart';


class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> with WidgetsBindingObserver {

  @override
  Widget build(BuildContext context) {
    final userSession = Provider.of<UserSession>(context);
    final isLoggedIn = userSession.isLoggedIn;

    Dimensions dimensions = Dimensions(context);

    return NetworkWrapper(
      child: Scaffold(
        appBar: AppBar(toolbarHeight: 20,),

        body:Container(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                toolbarHeight: dimensions.screenHeight*0.26,
                backgroundColor:Colors.transparent,
                flexibleSpace: FlexibleSpaceBar(
                  background: ProfileCardWidget(),
                ),
              ),

              SliverToBoxAdapter(
                child: Column(
                  children: [

                    _buildSection(context, "Services", [
                      if(userSession.isLoggedIn)
                      _buildTile(context, Icons.person_outline, "Profile", () async{
                        Navigator.push(context, MaterialPageRoute(builder: (_) =>  ProfileScreen(userId: userSession.userId!,)));
                       }),

                      if(userSession.isLoggedIn)
                      _buildTile(context, Icons.favorite_border, "Favorite", () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) =>
                            FavoriteScreen(userId: userSession.userId, status: 'service',)));
                      }),

                      if(userSession.isLoggedIn)
                      _buildTile(context, Icons.wallet_outlined, "Wallet", () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) =>  WalletScreen(userId: userSession.userId ?? '',)));
                      }),


                      _buildTile(context, Icons.card_giftcard, "Package", () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) =>  PackageScreen()));
                      }),

                      // _buildTile(context, Icons.card_giftcard, "Rating", () {
                      //   Navigator.push(context, MaterialPageRoute(builder: (_) =>  RatingReviewScreen()));
                      // }),

                      if(userSession.isLoggedIn)
                      _buildTile(context, Icons.verified_outlined, "5X Guarantee", () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) =>  FiveXScreen()));
                      }),


                      _buildTile(context, Icons.escalator_warning_outlined, "Refer And Earn", () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) =>  TeamBuildScreen()));
                      }),

                      if(userSession.isLoggedIn)
                      _buildTile(context, Icons.local_offer_outlined, "Coupon", () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) =>  AllCouponScreen(userId: userSession.userId.toString(),)));
                      }),


                      _buildTile(context, Icons.person_4_outlined, "Provider", () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const ProviderScreen()));
                      }),

                      if(userSession.isLoggedIn)
                      _buildTile(context, Icons.person_4, "Customer", () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) =>  CustomerScreen(userId: userSession.userId.toString(), isMenu: true)));
                      }),
                    ]),


                    _buildSection(context, "Preferences", [
                      _buildTile(context, Icons.description_outlined, "About Us", () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutUsScreen()));
                      }),

                      if(userSession.isLoggedIn)
                      _buildTile(context, Icons.notifications_active_outlined, "Notifications", () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationScreen()));
                      }),


                      _buildTile(context, Icons.settings_outlined, "Settings", () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingScreen()));
                      }),


                      _buildTile(context, Icons.support_agent, "Help & Support", () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpSupportScreen()));
                      }),


                      _buildTile(context, Icons.security, "Privacy & Policy", () {
                        CustomUrlLaunch('https://www.fetchtrue.com/privacypolicy');
                        // Navigator.push(context, MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()));
                      }),


                      _buildTile(context, Icons.rule, "Terms And Conditions", () {
                        CustomUrlLaunch('https://www.fetchtrue.com/termscondition');
                        // Navigator.push(context, MaterialPageRoute(builder: (_) => const TermsConditionsScreen()));
                      }),

                      _buildTile(context, Icons.receipt_long, "Refund Policy", () {
                        CustomUrlLaunch('https://www.fetchtrue.com/returnpolicy');
                        // Navigator.push(context, MaterialPageRoute(builder: (_) => const RefundPolicyScreen()));
                      }),

                      // _buildTile(context, Icons.cancel_outlined, "Cancellation Policy", () {
                      //   Navigator.push(context, MaterialPageRoute(builder: (_) => const CancellationPolicyScreen()));
                      // }),
                    ]),

                    _buildSection(context, "Others", [

                      if(userSession.isLoggedIn)
                      _buildTile(context, Icons.delete_outline, "Delete Account", () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) =>  DeleteAccountScreen(userId: userSession.userId ?? '',)));
                      }),


                      _buildTile(context, isLoggedIn ? Icons.logout : Icons.login,
                          isLoggedIn ? 'Sign Out' : 'Sign In', () {
                            if (isLoggedIn) {
                              showLogoutDialog(context, () async {
                                await IntroSharedpref.clearIntro();
                                await userSession.logout();

                                if (!context.mounted) return;

                                context.read<UserBloc>().add(ResetUser());
                                Navigator.pop(context);
                                // context.go('/splash');
                              });
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const AuthScreen()),
                              );
                            }
                          }),

                    ]),

                    10.height,
                    FutureBuilder(
                      future: PackageInfo.fromPlatform(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final version = snapshot.data!.version;
                          return Text('Version $version');
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    30.height
                  ],
                ),
              )
            ],
          ),
        )
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15.0,top: 10),
          child: Text(title, style: textStyle12(context)),
        ),
        CustomContainer(
          border: false,
          color: Colors.white,
          padding: EdgeInsets.zero,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildTile(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 15),
      leading: Icon(icon, color: Colors.black54, size: 20),
      title: Text(title, style: textStyle12(context,)),
      trailing: Icon(Icons.arrow_forward_ios, size: 14, color: CustomColor.iconColor),
      onTap: onTap,
    );
  }
}

void showLogoutDialog(BuildContext context, VoidCallback onConfirmLogout) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: CustomColor.whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text("Log Out", style: textStyle20(context, color: CustomColor.appColor)),
      content: const Text("Are you sure you want to log out?"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel", style: textStyle14(context, color: Colors.red)),
        ),
        TextButton(
          onPressed: onConfirmLogout,
          child: Text("Log Out", style: textStyle14(context, color: CustomColor.appColor)),
        )
      ],
    ),
  );
}
