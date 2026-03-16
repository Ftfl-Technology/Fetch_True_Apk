import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:fetchtrue/core/widgets/custom_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/costants/custom_color.dart';
import '../../../../core/widgets/custom_network_mage.dart';
import '../../../../core/widgets/shimmer_box.dart';
import '../../bloc/category/category_bloc.dart';
import '../../bloc/category/category_state.dart';


class MarketingCategoryWidget extends StatelessWidget {
  final String? moduleId;
   MarketingCategoryWidget({super.key, this.moduleId});
 

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return BlocBuilder<CategoryBloc, CategoryState>(
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
                padding:  EdgeInsets.symmetric(horizontal: dimensions.screenWidth*0.03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Category', style: TextStyle(fontSize: 16, color: CustomColor.blackColor, fontWeight: FontWeight.w600),),
                  ],
                ),
              ),
              10.height,
              SizedBox(
                height: categories.length <= 5 ? dimensions.screenHeight*0.15 : dimensions.screenHeight*0.3,
                child: GridView.builder(
                  itemCount: categories.length,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: categories.length <= 5 ? 1 : 2,
                      childAspectRatio: 0.995,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15
                  ),
                  itemBuilder: (context, index) {
                    final category = categories[index];

                    String formattedText(String text) {
                      final words = text.trim().split(RegExp(r'\s+'));

                      if (words.length <= 1) {
                        return text;
                      }

                      return '${words.first}\n${words.sublist(1).join(' ')}';
                    }


                    return CustomContainer(
                      padding: EdgeInsets.zero,
                      margin: EdgeInsets.zero,
                      child: CustomNetworkImage(
                        borderRadius: BorderRadius.circular(10),
                        imageUrl: category.image,
                        fit: BoxFit.fill,
                        onTap: () {
                          print(category.name);
                          context.push(
                            '/subcategory/${category.id}'
                                '?categoryName=${Uri.encodeComponent(category.name)}'
                                '&moduleName=${Uri.encodeComponent(category.module.name.toString())}',
                          );
                        },
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding:  EdgeInsets.all(dimensions.screenHeight*0.012),
                              child: Text(formattedText(category.name), style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),overflow: TextOverflow.ellipsis,maxLines: 2,textAlign: TextAlign.start,),
                            )),
                      ),
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
    );
  }
}


class _ShimmerGrid extends StatelessWidget {
  final int itemCount;
  const _ShimmerGrid({super.key, this.itemCount = 10});

  @override
  Widget build(BuildContext context) {
    final bool isSingleRow = itemCount > 4;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Title shimmer
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: ShimmerBox(width: 120, height: 12),
          ),
        ),

        SizedBox(
          height: isSingleRow ? 150 : 300,
          child: GridView.builder(
            itemCount: itemCount,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isSingleRow ? 1 : 2,
              childAspectRatio: 1 / 0.82,
              crossAxisSpacing: 0,
              mainAxisSpacing: 0,
            ),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(5),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Stack(
                      children: [
                        /// Image shimmer
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),

                        /// Text shimmer (top-right like original)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              ShimmerBox(height: 8, width: 60),
                              const SizedBox(height: 4),
                              ShimmerBox(height: 8, width: 40),
                            ],
                          ),
                        ),
                      ],
                    ),
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
