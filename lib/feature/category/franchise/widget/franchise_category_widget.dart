import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/widgets/custom_container.dart';
import '../../../../core/widgets/custom_network_mage.dart';
import '../../../../core/widgets/shimmer_box.dart';
import '../../bloc/category/category_bloc.dart';
import '../../bloc/category/category_state.dart';


class FranchiseCategoryWidget extends StatefulWidget {
  final String? moduleIndexId;
   const FranchiseCategoryWidget({super.key, this.moduleIndexId});

  @override
  State<FranchiseCategoryWidget> createState() => _FranchiseCategoryWidgetState();
}

class _FranchiseCategoryWidgetState extends State<FranchiseCategoryWidget> {

  final ScrollController _scrollController = ScrollController();
  double _indicatorPosition = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    setState(() {
      _indicatorPosition = _scrollController.offset;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

   @override
   Widget build(BuildContext context) {

     return BlocBuilder<CategoryBloc, CategoryState>(
       builder: (context, state) {
         if (state is CategoryLoading) {
           return _ShimmerGrid();
         } else if (state is CategoryLoaded) {
           // final categories = state.categories;
          final categories = state.categories.where((moduleCategory) => moduleCategory.module.id == widget.moduleIndexId).toList();

           return  Column(
             children: [
               15.height,
               SizedBox(
                 height: 350,
                 child: GridView.builder(
                   controller: _scrollController, // 👈 important
                   itemCount: categories.length,
                   scrollDirection: Axis.horizontal,
                   padding: const EdgeInsets.symmetric(horizontal: 10),
                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                     crossAxisCount: 3,
                     crossAxisSpacing: 15,
                     mainAxisSpacing: 15,
                   ),
                   itemBuilder: (context, index) {
                     final category = categories[index];
                     return Container(
                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(8),
                         border: Border.all(color: CustomColor.greyColor, width: 0.2),
                       ),
                       child: CustomNetworkImage(
                         borderRadius: BorderRadius.circular(8),
                         imageUrl: category.image,
                         onTap: () {
                           context.push(
                             '/subcategory/${category.id}'
                                 '?categoryName=${Uri.encodeComponent(category.name)}'
                                 '&moduleName=${Uri.encodeComponent(category.module.name.toString())}',
                           );
                           // context.push(
                           //   '/subcategory/${category.id}?name=${Uri.encodeComponent(category.name)}',
                           // );
                         },
                         child: Column(
                           mainAxisAlignment: MainAxisAlignment.end,
                           children: [
                             Padding(
                               padding: const EdgeInsets.all(8),
                               child: Text(
                                 category.name,
                                 style: const TextStyle(fontSize: 12),
                                 maxLines: 2,
                                 overflow: TextOverflow.ellipsis,
                               ),
                             ),
                           ],
                         ),
                       ),
                     );
                   },
                 ),
               ),

               /// 🔹 Scroll Indicator
               Container(
                 height: 6,
                 margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                 decoration: BoxDecoration(
                   color: Colors.grey.shade100,
                   borderRadius: BorderRadius.circular(10),
                 ),
                 child: LayoutBuilder(
                   builder: (context, constraints) {
                     final maxScroll = _scrollController.position.maxScrollExtent;
                     final indicatorWidth = constraints.maxWidth * 0.25;

                     double leftPosition = 0;
                     if (maxScroll > 0) {
                       leftPosition =
                           (_indicatorPosition / maxScroll) *
                               (constraints.maxWidth - indicatorWidth);
                     }

                     return Stack(
                       children: [
                         AnimatedPositioned(
                           duration: const Duration(milliseconds: 200),
                           curve: Curves.easeInOut,
                           left: leftPosition,
                           child: Container(
                             width: indicatorWidth,
                             height: 6,
                             decoration: BoxDecoration(
                               color: Color(0xFF2164F4),
                               borderRadius: BorderRadius.circular(10),
                             ),
                           ),
                         ),
                       ],
                     );
                   },
                 ),
               ),

             ],
           );
         } else if (state is CategoryError) {
           print("Error: ${state.message}");
         }
         return const SizedBox();
       },
     );
   }
}


class _ShimmerGrid extends StatelessWidget {
  const _ShimmerGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 350,
          child: GridView.builder(
            itemCount: 15,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                // childAspectRatio: 1 / 0.9,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10
            ),
            itemBuilder: (context, index) {
              return CustomContainer(
                margin: EdgeInsets.zero,
                child:  Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ShimmerBox(height: 10,width: 50,)
                    ],
                  ),
                ),
              );
            },),
        ),
      ],
    );
  }
}