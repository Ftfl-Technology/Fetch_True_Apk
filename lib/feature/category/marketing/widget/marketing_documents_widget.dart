
import 'package:flutter/material.dart';
import '../../../../core/costants/custom_color.dart';
import '../model/marketing_service_details_model.dart';

class MarketingDocumentsWidget extends StatefulWidget {

  final List<WeRequired> weRequired;
  final List<WeDeliver> weDeliver;
  const MarketingDocumentsWidget({
    super.key,
    required this.weRequired,
    required this.weDeliver,
  });

  @override
  State<MarketingDocumentsWidget> createState() => _MarketingDocumentsWidgetState();
}

class _MarketingDocumentsWidgetState extends State<MarketingDocumentsWidget> {
  bool isRequiredSelected = true;

  @override
  Widget build(BuildContext context) {
    final currentList =
    isRequiredSelected ? widget.weRequired : widget.weDeliver;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey.shade200,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
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

        /// 🔥 DATA-DRIVEN LIST
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border(
              top: BorderSide(
                color: CustomColor.marketing,
                width: 1.5,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),

            ],
          ),
          padding: EdgeInsets.all(15),
          child: Column(
            children: List.generate(currentList.length, (index) {
              final item = currentList[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      size: 18,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        item.title, // ✅ FIXED
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}


class _ToggleItem extends StatelessWidget {
  final String title;
  final bool isSelected;

  const _ToggleItem({
    required this.title,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ?  CustomColor.marketing: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      alignment: Alignment.center,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: isSelected
              ? CustomColor.whiteColor
              : CustomColor.marketing,
        ),
      ),
    );
  }
}

