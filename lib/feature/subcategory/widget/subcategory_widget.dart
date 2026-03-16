import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../core/widgets/shimmer_box.dart';
import '../bloc/module_subcategory/subcategory_bloc.dart';
import '../bloc/module_subcategory/subcategory_event.dart';
import '../bloc/module_subcategory/subcategory_state.dart';
import '../repository/subcategory_repository.dart';

class SubcategoryWidget extends StatefulWidget {
  final String categoryId;
  final String subcategoryId;
  final ValueChanged<String>? onChanged;

  const SubcategoryWidget({
    super.key,
    required this.categoryId,
    required this.subcategoryId,
    this.onChanged,
  });

  @override
  State<SubcategoryWidget> createState() => _SubcategoryWidgetState();
}

class _SubcategoryWidgetState extends State<SubcategoryWidget> {

  late String _selectedId;

  @override
  void initState() {
    super.initState();
    _selectedId = widget.subcategoryId;
  }

  @override
  Widget build(BuildContext context) {
    Dimensions dimensions = Dimensions(context);
    return BlocProvider(
      create: (_) => SubcategoryBloc(SubcategoryRepository())..add(FetchSubcategories()),
      child: BlocBuilder<SubcategoryBloc, SubcategoryState>(
        builder: (context, state) {
          if (state is SubcategoryLoading) {
            return const ShimmerList();
          } else if (state is SubcategoryLoaded) {

            final subcategories = state.subcategories.where((sub) => sub.category.id == widget.categoryId).toList();

            if (subcategories.isEmpty) {
              return SizedBox.shrink();
            }


            if (_selectedId.isEmpty && subcategories.isNotEmpty) {
              _selectedId = subcategories.first.id;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                widget.onChanged?.call(_selectedId);
                setState(() {});
              });
            }

            return  SizedBox(
              height: dimensions.screenHeight*0.145,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.all(dimensions.screenHeight*0.005),
                children: List.generate(subcategories.length, (index) {
                  final sub = subcategories[index];
                  final isSelected = sub.id == _selectedId;
                  return Container(
                    width: dimensions.screenHeight*0.09,
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomContainer(
                          border: true,
                          height: dimensions.screenHeight*0.08,
                          networkImg: sub.image,
                          margin: EdgeInsets.zero,
                          onTap: () {
                            setState(() => _selectedId = sub.id);
                            widget.onChanged?.call(sub.id);
                          },
                        ),
                        5.height,
                        Text(sub.name,
                          style: textStyle12(context, color: isSelected ? CustomColor.appColor : Colors.black, fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,),
                          textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis,),
                      ],
                    ),
                  );
                },),
              ),
            );
          } else if (state is SubcategoryError) {
            print('Dio Error: ${state.message}');
            // return Center(child: Text('Dio Error: ${state.message}'));
          }
          return const SizedBox();
        },
      ),
    );
  }
}


class ShimmerList extends StatelessWidget {
  const ShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(4, (index) =>
            Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  spacing: 10,
                  children: [
                    ShimmerBox(height: 80,width: 80,),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ShimmerBox(height: 6, width: 50,),
                        5.height,
                        ShimmerBox(height: 6, width: 80,),
                      ],
                    )
                  ],
                ),
              ),
            ),),
      ),
    );
  }
}
