import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/costants/custom_color.dart';
import '../../../../core/widgets/custom_container.dart';
import '../../../../core/widgets/custom_network_mage.dart';
import '../../../../core/widgets/shimmer_box.dart';
import '../../bloc/category/category_bloc.dart';
import '../../bloc/category/category_state.dart';


class FinanceCategoryWidget extends StatelessWidget {
  final String? moduleId;
   FinanceCategoryWidget({super.key, this.moduleId});


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
                padding:  EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Category', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,color: CustomColor.blackColor),),
                    10.width,
                    // Expanded(child: Divider(color: CustomColor.greyColor,))
                  ],
                ),
              ),
              15.height,
              SizedBox(
                height: categories.length > 5
                    ? dimensions.screenHeight * 0.33
                    : dimensions.screenHeight * 0.16,
                child: GridView.builder(
                  itemCount:categories.length,
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.zero,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: categories.length > 5 ? 2 : 1,
                      childAspectRatio: 1 / 0.75,
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 10
                  ),
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 16),
                          height: dimensions.screenHeight*0.1,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey,width: 0.2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: CustomNetworkImage(
                            imageUrl: category.image,
                            borderRadius: BorderRadius.circular(8),
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
                          child: Text(category.name, style: TextStyle(fontSize: 12),overflow: TextOverflow.ellipsis,maxLines: 2,textAlign: TextAlign.center,),
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
    );
  }
}


class _ShimmerGrid extends StatelessWidget {
  const _ShimmerGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Title shimmer
        Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                ShimmerBox(width: 80, height: 10),
                ShimmerBox(width: 20, height: 10),
              ],
            ),
          ),
        ),

        /// Grid shimmer
        SizedBox(
          height: 250,
          child: GridView.builder(
            itemCount: 8,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Expanded(
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: const CustomContainer(
                        margin: EdgeInsets.zero,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  ShimmerBox(height: 10, width: 50),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
