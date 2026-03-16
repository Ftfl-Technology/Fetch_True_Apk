import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/costants/text_style.dart';
import '../../dashboard/screen/dashboard_screen.dart';
import '../bloc/module_bloc.dart';
import '../bloc/module_event.dart';
import '../bloc/module_state.dart';
import '../model/module_model.dart';
import '../repository/module_repository.dart';

class ModuleWidget extends StatelessWidget implements BottomNavScreen{
  final int? selectedIndex;
  final void Function(int)? onTabChanged;

  const ModuleWidget({super.key, this.selectedIndex, this.onTabChanged,});

  ModuleWidget copyWith({int? selectedIndex, void Function(int)? onTabChanged}) {
    return ModuleWidget(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      onTabChanged: onTabChanged ?? this.onTabChanged,
    );
  }
  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return BlocBuilder<ModuleBloc, ModuleState>(
      builder: (context, state) {
        if (state is ModuleLoading) {
          return ModuleShimmer();
        }
        else if (state is ModuleLoaded) {
          final modules = state.modules;

          ModuleModel? getModule(String name) {
            try {
              return modules.firstWhere((m) => m.name?.toLowerCase() == name.toLowerCase());
            } catch (e) {
              return null;
            }
          }

          void openModule(ModuleModel module) {
            context.push(
              '/category',
              extra: {
                'title': module.name,
                'moduleId': module.id,
                'image': module.image,
                'selectedIndex': selectedIndex ?? 0,
                'onTabChanged': onTabChanged,
              },
            );
          }

          final franchise = getModule("Franchise");
          final business = getModule("Business");
          final legal = getModule("Legal Services");
          final marketing = getModule("Marketing");
          final education = getModule("Education");
          final finance = getModule("Finance");
          final aiHub = getModule("AI Hub");
          final onDemand = getModule("On-Demand");
          final itService = getModule("It Services");


          return Container(
            height: 408,
            margin: EdgeInsets.symmetric(horizontal: 10),

            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      if (aiHub != null)
                      shadowCard(flex: 1,imageUrl: aiHub.image, moduleName: aiHub.name,
                      onTap: () => openModule(aiHub),),

                      if (finance != null)
                      shadowCard(height: 114,imageUrl: finance.image, moduleName: finance.name,
                        onTap: () => openModule(finance),),

                      if (education != null)
                        shadowCard(height: 114,imageUrl: education.image, moduleName: education.name,
                          onTap: () => openModule(education),),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      if (marketing != null)
                      shadowCard(height: 104,imageUrl: marketing.image, moduleName: marketing.name,
                        onTap: () => openModule(marketing),),

                      if (franchise != null)
                      shadowCard(flex: 1,imageUrl: franchise.image, moduleName: franchise.name,
                        onTap: () => openModule(franchise),),

                      if (itService != null)
                      shadowCard(flex: 1, imageUrl: itService.image,moduleName: itService.name,
                        onTap: () => openModule(itService),),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      if (legal != null)
                        shadowCard(flex: 1,imageUrl: legal.image, moduleName: legal.name,
                          onTap: () => openModule(legal),),

                      if (business != null)
                      shadowCard(height: 114,imageUrl: business.image, moduleName: business.name,
                        onTap: () => openModule(business),),

                      if (onDemand != null)
                      shadowCard(height: 114,imageUrl: onDemand.image, moduleName: onDemand.name,
                        onTap: () => openModule(onDemand),),
                    ],
                  ),
                ),
              ],
            ),

          );
        }

        else if (state is ModuleError) {
          print("Modules Error: ${state.message}");
          return SizedBox.shrink();
        }
        return Container();
      },
    );
  }
}


Widget shadowCard({
  int? flex,
  double? height,
  String? imageUrl,
  String? moduleName,
  VoidCallback? onTap,
}) {
  final card = InkWell(
    onTap: onTap,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    hoverColor: Colors.transparent,
    child: Container(
      height: height,
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        image: DecorationImage(image: NetworkImage(imageUrl!),fit: BoxFit.fill),
        color: Colors.white,
        border: Border.all(color: Colors.grey,width: 0.08),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),

      child: Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('${moduleName}',style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),),
          )),
    ),
  );

  if (flex != null) {
    return Expanded(
      flex: flex,
      child: card,
    );
  }

  return card;
}

class ModuleShimmer extends StatelessWidget {
  const ModuleShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 408,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          /// ---------- COLUMN 1 ----------
          Expanded(
            child: Column(
              children: [
                _shimmerExpandedCard(flex: 1),
                _shimmerFixedCard(height: 114),
                _shimmerFixedCard(height: 114),
              ],
            ),
          ),

          /// ---------- COLUMN 2 ----------
          Expanded(
            child: Column(
              children: [
                _shimmerFixedCard(height: 104),
                _shimmerExpandedCard(flex: 1),
                _shimmerExpandedCard(flex: 1),
              ],
            ),
          ),

          /// ---------- COLUMN 3 ----------
          Expanded(
            child: Column(
              children: [
                _shimmerExpandedCard(flex: 1),
                _shimmerFixedCard(height: 114),
                _shimmerFixedCard(height: 114),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// For Expanded cards (same as real UI)
  Widget _shimmerExpandedCard({required int flex}) {
    return Expanded(
      flex: flex,
      child: _shimmerCard(),
    );
  }

  /// For fixed height cards
  Widget _shimmerFixedCard({required double height}) {
    return Container(
      height: height,
      child: _shimmerCard(),
    );
  }

  /// Actual shimmer card
  Widget _shimmerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        margin: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

