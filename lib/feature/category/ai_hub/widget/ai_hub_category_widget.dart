import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/costants/custom_color.dart';
import '../../../../core/costants/dimension.dart';
import '../../../../core/widgets/custom_container.dart';
import '../../../../core/widgets/custom_network_mage.dart';
import '../../../../core/widgets/shimmer_box.dart';
import '../../bloc/category/category_bloc.dart';
import '../../bloc/category/category_state.dart';


class AiHubCategoryWidget extends StatelessWidget {
  final String moduleId;
  AiHubCategoryWidget({super.key,  required this.moduleId});

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
                    Text('Category', style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600, color: CustomColor.blackColor),),
                    10.width,
                    // Expanded(child: Divider(color: CustomColor.greyColor,))
                  ],
                ),
              ),
              15.height,
              Container(
                height: 326,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1 /0.65,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 15,
                  ),
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return  Column(
                      children: [
                        Container(
                          height: 108,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: CustomColor.aiHub,width: 0.6)
                          ),
                          child: CustomNetworkImage(
                            borderRadius: BorderRadius.circular(10),
                            imageUrl: category.image ?? '',
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
                          child: Text(
                            category.name ?? '',
                            style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                            maxLines: 2,overflow: TextOverflow.ellipsis,
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
    return Container(
      height: 326,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 6,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1 / 0.65,
          crossAxisSpacing: 10,
          mainAxisSpacing: 15,
        ),
        itemBuilder: (context, index) {
          return Column(
            children: [
              /// Image Shimmer
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  height: 108,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              /// Title Shimmer (2 lines)
              Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Column(
                  children: [
                    Container(
                      height: 10,
                      width: 70,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 10,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
