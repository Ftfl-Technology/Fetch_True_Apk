import 'package:flutter/material.dart';
import '../../../../core/costants/custom_color.dart';
import '../../ai_hub/model/ai_hub_service_details_model.dart';

class AiHubDocumentsWidget extends StatefulWidget {
  final ServiceDetails serviceDetails;

  const AiHubDocumentsWidget({
    super.key,
    required this.serviceDetails,
  });

  @override
  State<AiHubDocumentsWidget> createState() => _AiHubDocumentsWidgetState();
}

class _AiHubDocumentsWidgetState extends State<AiHubDocumentsWidget> {
  bool isRequiredSelected = true;

  @override
  Widget build(BuildContext context) {
    final List<WeItem> currentList = isRequiredSelected
        ? widget.serviceDetails.weRequired
        : widget.serviceDetails.weDeliver;

    if (widget.serviceDetails.weRequired.isEmpty &&
        widget.serviceDetails.weDeliver.isEmpty) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Documents",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: CustomColor.aiHub,
            ),
          ),

          const SizedBox(height: 12),

          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.shade200,
              border: Border.all(color: CustomColor.aiHub),
            ),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () => setState(() => isRequiredSelected = true),
                    child: _ToggleItem(
                      title: "We Required",
                      isSelected: isRequiredSelected,
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
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

          const SizedBox(height: 14),

          if (currentList.isNotEmpty)
            Container(
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius:  BorderRadius.circular(10),
                  border: Border.all(color: Colors.white,width: 0.5)
              ),
              padding: const EdgeInsets.all(10),
              // margin: const EdgeInsets.all(10),
              child: Column(
                children: List.generate(currentList.length, (index) {
                  final item = currentList[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_circle_outline,
                            size: 18, color: Colors.green),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                              if (item.description.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Text(
                                    item.description,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }
}

/// 🔹 Toggle Item
class _ToggleItem extends StatelessWidget {
  final String title;
  final bool isSelected;

  const _ToggleItem({
    required this.title,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? CustomColor.aiHub : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
      ),
      alignment: Alignment.center,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color:
          isSelected ? CustomColor.whiteColor : CustomColor.aiHub,
        ),
      ),
    );
  }
}
