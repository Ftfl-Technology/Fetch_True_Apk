import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/costants/custom_color.dart';
import '../../../../core/costants/text_style.dart';
import '../../../../core/widgets/custom_container.dart';
import '../../../../core/widgets/custom_network_mage.dart';
import '../../../../core/widgets/shimmer_box.dart';
import '../../bloc/category/category_bloc.dart';
import '../../bloc/category/category_event.dart';
import '../../bloc/category/category_state.dart';
import '../../repository/category_repository.dart';

class EducationCategoryWidget extends StatelessWidget {
  final String moduleId;
  const EducationCategoryWidget({super.key, required this.moduleId});


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
                      Text('Category', style: TextStyle(fontSize: 16, color: CustomColor.blackColor,fontWeight: FontWeight.w600),),
                    ],
                  ),
                ),
                15.height,
                SizedBox(
                  height: 220,
                  child: GridView.builder(
                    itemCount:categories.length,
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:  2 ,
                        childAspectRatio: 1 / 1,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10
                    ),
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return CustomContainer(
                        border: true,
                        padding: EdgeInsets.zero,
                        margin: EdgeInsets.zero,
                        child: CustomNetworkImage(
                          imageUrl: category.image,
                          borderRadius: BorderRadius.circular(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(category.name, style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500),overflow: TextOverflow.ellipsis,maxLines: 2,),
                              ),
                            ],
                          ),
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ShimmerBox(width: 80,height: 10,),
              ],
            ),
          ),
        ),


        SizedBox(
          height: 220,
          child: GridView.builder(
            itemCount: 15,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1 / 1,
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
                    mainAxisAlignment: MainAxisAlignment.start,
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