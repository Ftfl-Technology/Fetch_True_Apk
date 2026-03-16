import 'package:flutter/material.dart';
import '../../../../core/costants/custom_color.dart';

/// CommonItem to represent each document item
class CommonItem {
  final String title;
  final String description;

  CommonItem({required this.title, required this.description});
}

class OnDemandDocumentsWidget extends StatefulWidget {
  final List<CommonItem> weRequired;
  final List<CommonItem> weDeliver;

  const OnDemandDocumentsWidget({
    super.key,
    required this.weRequired,
    required this.weDeliver,
  });

  @override
  State<OnDemandDocumentsWidget> createState() =>
      _OnDemandDocumentsWidgetState();
}

class _OnDemandDocumentsWidgetState extends State<OnDemandDocumentsWidget> {
  bool isRequiredSelected = true;

  @override
  Widget build(BuildContext context) {
    final currentList =
    isRequiredSelected ? widget.weRequired : widget.weDeliver;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          // Text(
          //   "Documents",
          //   style: TextStyle(
          //     fontSize: 16,
          //     fontWeight: FontWeight.w600,
          //     color: CustomColor.legal,
          //   ),
          // ),
          // const SizedBox(height: 12),

          // Toggle
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
              // border: Border.all(color: CustomColor.legal),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => isRequiredSelected = true),
                    child: _ToggleItem(
                      title: "We Required",
                      isSelected: isRequiredSelected,
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => isRequiredSelected = false),
                    child: _ToggleItem(
                      title: "We Deliver",
                      isSelected: !isRequiredSelected,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Document list
          Container(
            padding: EdgeInsets.all(16),
            // margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              spacing: 5,
              children: List.generate(currentList.length, (index) {
                final item = currentList[index];
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 3.0),
                      child: const Icon(size: 16,
                        Icons.check_circle_outline_outlined,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style:  TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade700
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Text(
                          //   item.description,
                          //   style: TextStyle(
                          //     fontSize: 13,
                          //     color: Colors.grey.shade700,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

/// Toggle button for "We Required" / "We Deliver"
class _ToggleItem extends StatelessWidget {
  final String title;
  final bool isSelected;

  const _ToggleItem({required this.title, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected ? CustomColor.onDemand : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: isSelected ? CustomColor.whiteColor : CustomColor.onDemand,
        ),
      ),
    );
  }
}
