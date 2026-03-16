import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/feature/category/business/screen/business_screen.dart';
import 'package:fetchtrue/feature/category/education/screen/education_screen.dart';
import 'package:fetchtrue/feature/category/finance/screen/finance_service_screen.dart';
import 'package:fetchtrue/feature/category/franchise/screen/franchise_screen.dart';
import 'package:fetchtrue/feature/category/it_service/screen/it_service_screen.dart';
import 'package:fetchtrue/feature/category/legal_service/screen/legal_service_screen.dart';
import 'package:fetchtrue/feature/category/marketing/screen/marketing_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/costants/dimension.dart';
import '../ai_hub/screen/ai_hub_screen.dart';
import '../ondemand/screen/ondemand_screen.dart';


class CategoryScreen extends StatefulWidget {
  final String title;
  final String? moduleId;
  final String? imageUrl;
  final int selectedIndex;
  final void Function(int)? onTabChanged;

  const CategoryScreen({
    super.key,
    required this.title,
    this.moduleId,
    this.imageUrl,
    required this.selectedIndex,
    this.onTabChanged,
  });

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {


  Future<bool> _onWillPop(BuildContext context) async {
    if (widget.onTabChanged != null) widget.onTabChanged!(0);
    return true;
  }

  Widget _resolveCategoryScreen() {
    final moduleId = widget.moduleId ?? '';
    final title = widget.title;

    final Map<String, Widget Function()> screenMap = {
      'Franchise': () => FranchiseScreen(
        moduleId: moduleId,
        moduleName: title,
      ),
      'Marketing': () => MarketingScreen(
        moduleId: moduleId,
        moduleName: title,
      ),
      'Business': () => BusinessScreen(
        moduleId: moduleId,
        moduleName: title,
      ),
      'Education': () => EducationScreen(
        moduleId: moduleId,
        moduleName: title,
      ),
      'Legal Services': () => LegalServiceScreen(
        moduleId: moduleId,
        moduleName: title,
      ),
      'Finance': () => FinanceServiceScreen(
        moduleId: moduleId,
        moduleName: title,
      ),
      'AI Hub': () => AiHubScreen(
        moduleId: moduleId,
        moduleName: title,
      ),
      'On-Demand': () => OnDemandScreen(
        moduleId: moduleId,
        moduleName: title,
      ),
      'It Services': () => ItServiceScreen(
        moduleId: moduleId,
        moduleName: title,
      ),
    };

    return screenMap[title]?.call() ??
        const Center(child: Text('Module not found'));
  }


  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: Scaffold(
        backgroundColor: CustomColor.whiteColor,
        body: _resolveCategoryScreen(),

        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            elevation: 1,
            backgroundColor: CustomColor.whiteColor,
            currentIndex: widget.selectedIndex,
            onTap: (index) {
              if (widget.onTabChanged != null) {
                widget.onTabChanged!(index);
              }
              Navigator.pop(context);
            },
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
