import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/costants/custom_color.dart';
import '../../../../core/widgets/custom_container.dart';
import '../../../../core/widgets/custom_network_mage.dart';
import '../../../../core/widgets/shimmer_box.dart';
import '../../bloc/category/category_bloc.dart';
import '../../bloc/category/category_event.dart';
import '../../bloc/category/category_state.dart';
import '../../repository/category_repository.dart';


class LegalCategoryWidget extends StatelessWidget {
  final String? moduleId;
   const LegalCategoryWidget({super.key, this.moduleId});

  @override
  Widget build(BuildContext context) {
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
                10.height,
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Category', style: TextStyle(fontSize: 16, color: CustomColor.blackColor, fontWeight: FontWeight.w600),),
                      // 10.width,
                      // Expanded(child: Divider(color: CustomColor.greyColor,))
                    ],
                  ),
                ),
                15.height,
                SizedBox(
                  height: categories.length > 4 ? 147:284,
                  child: GridView.builder(
                    itemCount: categories.length,
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: categories.length > 4 ?1:2,
                        childAspectRatio: 1 / 0.8,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 15
                    ),
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              // border: Border.all(color: Colors.grey.shade600, width: 0.15),
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(image: NetworkImage(category.image),fit: BoxFit.fill)
                            ),
                            child: InkWell(

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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(category.name, style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),overflow: TextOverflow.ellipsis,maxLines: 2,textAlign: TextAlign.center,),
                          ),
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
    const int shimmerCount = 6; // 👈 assume loading data

    final bool isSingleRow = shimmerCount > 4;

    final double gridHeight = isSingleRow ? 147 : 284;
    final int crossAxisCount = isSingleRow ? 1 : 2;
    final double aspectRatio = 1 / 0.8;

    return Column(
      children: [
        /// Title shimmer
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              height: 14,
              width: 90,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),

        /// Grid shimmer
        SizedBox(
          height: gridHeight,
          child: GridView.builder(
            itemCount: shimmerCount,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              childAspectRatio: aspectRatio,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              return Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
