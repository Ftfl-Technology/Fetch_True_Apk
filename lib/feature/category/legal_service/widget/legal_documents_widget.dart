
import 'package:flutter/material.dart';

import '../../../../core/costants/custom_color.dart';
import '../model/legal_service_details_model.dart';

class LegalDocumentsWidget extends StatefulWidget {
  final List<CommonItem> weRequired;
  final List<CommonItem> weDeliver;

  const LegalDocumentsWidget({
    super.key,
    required this.weRequired,
    required this.weDeliver,
  });

  @override
  State<LegalDocumentsWidget> createState() => _LegalDocumentsWidgetState();
}

class _LegalDocumentsWidgetState extends State<LegalDocumentsWidget> {
  bool isRequiredSelected = true;

  @override
  Widget build(BuildContext context) {
    final currentList = isRequiredSelected ? widget.weRequired : widget.weDeliver;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Documents",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: CustomColor.legal,
            ),
          ),

          const SizedBox(height: 12),

          Container(
            // padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.shade200,
              border: Border.all(color: CustomColor.legal),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() => isRequiredSelected = true);
                    },
                    child: _ToggleItem(
                      title: "We Required",
                      isSelected: isRequiredSelected,
                    ),
                  ),
                ),

                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() => isRequiredSelected = false);
                    },
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

          Column(
            children: List.generate(currentList.length, (index) {
              final item = currentList[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5),
                      child: const Icon(
                        Icons.circle,
                        size: 8,
                        color: Colors.black,
                      ),
                    ),

                    Expanded(
                      child: Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
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
        color: isSelected ?  Color(0xFFBC9958): Colors.transparent,
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
              : CustomColor.legal,
        ),
      ),
    );
  }
}

