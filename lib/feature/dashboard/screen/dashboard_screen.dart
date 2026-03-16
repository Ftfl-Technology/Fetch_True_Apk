import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/feature/home/screen/home_screen.dart';
import 'package:fetchtrue/feature/offer/screen/offers_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../lead/screen/lead_screen.dart';
import '../../academy/screen/academy_screen.dart';
import '../../more/screen/more_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int selectedIndex = 0;

  final List<Widget> screens = [
    HomeScreen(),
    LeadScreen(),
    OfferScreen(),
    AcademyScreen(),
    MoreScreen(),
  ];

  void onTabChanged(int index) {
    setState(() => selectedIndex = index);
  }

  void _showExitBottomSheet() {
    _scaffoldKey.currentState?.showBottomSheet(
          (context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.exit_to_app, color: Colors.red, size: 20),
                SizedBox(width: 6),
                Text(
                  'Exit App?',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text(
              'Do you really want to close the app?',
              style: TextStyle(fontSize: 13, color: Colors.black54),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context); // close sheet
                    },
                    child:  Text('Cancel',style: TextStyle(color: CustomColor.greyColor),),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColor.appColor,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      SystemNavigator.pop();
                    },
                    child:  Text('Exit', style: TextStyle(color: CustomColor.whiteColor),),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;

        if (selectedIndex != 0) {
          setState(() {
            selectedIndex = 0;
          });
          return;
        }

        _showExitBottomSheet();
      },
      child: Scaffold(
        key: _scaffoldKey,
        body: IndexedStack(
          index: selectedIndex,
          children: screens.map((screen) {
            if (screen is BottomNavScreen) {
              return screen.copyWith(selectedIndex: selectedIndex, onTabChanged: onTabChanged);
            }
            return screen;
          }).toList(),
        ),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            elevation: 1,
            backgroundColor: CustomColor.whiteColor,
            currentIndex: selectedIndex,
            onTap: onTabChanged,
            selectedItemColor: CustomColor.appColor,
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w400),
            enableFeedback: false,
            showUnselectedLabels: true,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.leaderboard), label: 'Leads'),
              BottomNavigationBarItem(icon: Icon(Icons.card_giftcard), label: 'Offers'),
              BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Academy'),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------ BottomNavScreen Interface ------------------
abstract class BottomNavScreen extends Widget {
  Widget copyWith({int? selectedIndex, void Function(int)? onTabChanged});
}

