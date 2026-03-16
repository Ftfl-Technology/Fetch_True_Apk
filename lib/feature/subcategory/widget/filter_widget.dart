import 'package:fetchtrue/core/costants/text_style.dart';
import 'package:flutter/material.dart';
import '../../../core/costants/custom_color.dart';
import '../../../core/costants/dimension.dart';
import '../../../core/widgets/custom_container.dart';

class FilterWidget extends StatefulWidget {
  final Dimensions dimensions;
  final ValueChanged<String>? onFilterSelected;

  const FilterWidget({super.key, required this.dimensions, this.onFilterSelected});

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  final List<String> serviceOptions = [
    'All', 'Low to High', 'High to Low', 'Recommended', 'Most Popular', 'Top Rated', 'Best Seller',
  ];

  String selectedOption = 'All';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomColor.whiteColor,
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(serviceOptions.length, (index) {
            final option = serviceOptions[index];
            final isSelected = option == selectedOption;
            return Padding(
              padding: EdgeInsets.only(right: index == serviceOptions.length - 1 ? 0 : 10),
              child: CustomContainer(
                color: isSelected ? CustomColor.appColor.withOpacity(0.1) : CustomColor.appColor.withOpacity(0.03),
                margin: EdgeInsets.zero,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Center(
                  child: Text(option, style: textStyle12(context, color: isSelected ? CustomColor.appColor : Colors.black,fontWeight: FontWeight.w400)),
                ),
                onTap: () {
                  setState(() {
                    selectedOption = option;
                  });
                  widget.onFilterSelected?.call(option);
                },
              ),
            );
          }),
        ),
      ),
    );
  }
}
