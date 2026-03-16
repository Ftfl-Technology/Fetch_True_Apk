import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/costants/custom_color.dart';
import '../../../../core/widgets/custom_network_mage.dart';
import '../../../../core/widgets/shimmer_box.dart';
import '../../bloc/category/category_bloc.dart';
import '../../bloc/category/category_event.dart';
import '../../bloc/category/category_state.dart';
import '../../repository/category_repository.dart';

class ItServiceCategoryWidget extends StatelessWidget {
  final String? moduleId;
  ItServiceCategoryWidget({super.key, this.moduleId});


  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return BlocProvider(
      create: (_) => CategoryBloc(CategoryRepository())..add(GetCategories()),
      child: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoading) {
            return _ShimmerGrid();
          } else if (state is CategoryLoaded) {
            // final categories = state.categories;
            final categories = state.categories.where((moduleCategory) =>
            moduleCategory.module.id == moduleId).toList();

            return  Column(
              children: [
                // 10.height,
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Category', style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600, color: CustomColor.blackColor),),
                      10.width,
                      // Expanded(child: Divider(color: CustomColor.greyColor,))
                    ],
                  ),
                ),
                15.height,
                SizedBox(
                  height:  categories.length == 8 ? 230: 115,
                  child: GridView.builder(
                    itemCount: categories.length,
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: categories.length == 8 ?2:1,
                        childAspectRatio: 1 / 0.8,
                        crossAxisSpacing: 0,
                        mainAxisSpacing: 0
                    ),
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFEEF2F6),
                              // border: Border.all(color: Colors.grey,width: 0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: CustomNetworkImage(
                              height: dimensions.screenHeight*0.075,
                              width: dimensions.screenHeight*0.075,
                              borderRadius: BorderRadius.circular(10),
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
                            ),
                          ),
                          5.height,
                          Text(category.name, style: TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis,maxLines: 2,textAlign: TextAlign.center,),
                        ],
                      );
                    },),
                ),
              ],
            );
          } else if (state is CategoryError) {
            print("Error: ${state.message}");
          }
          return const SizedBox();
        },
      ),
    );
  }
}


class _ShimmerGrid extends StatelessWidget {
  const _ShimmerGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShimmerBox(width: 80,height: 10,),
              ],
            ),
          ),
        ),

        SizedBox(
          height: 230,
          child: GridView.builder(
            itemCount: 10,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1 / 0.8,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10
            ),
            itemBuilder: (context, index) {
              return  Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ShimmerBox(height: 80, width: 80,),
                    10.height,

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ShimmerBox(height: 8, width: 50,),
                        5.height,
                        // ShimmerBox(height: 8, width: 80,),
                      ],
                    )
                  ],
                ),
              );
            },),
        ),
      ],
    );
  }
}