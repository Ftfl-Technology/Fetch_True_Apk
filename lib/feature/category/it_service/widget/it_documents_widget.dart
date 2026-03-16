
import 'package:flutter/material.dart';
import '../../../../core/costants/custom_color.dart';
import '../../franchise/screen/franchise_service_details_screen.dart';
import '../model/it_service_details_model.dart';

class ItDocumentsWidget extends StatefulWidget {
  final ItServiceDetailsModel service;

  const ItDocumentsWidget({
    super.key,
    required this.service,
  });

  @override
  State<ItDocumentsWidget> createState() => _ItDocumentsWidgetState();
}

class _ItDocumentsWidgetState extends State<ItDocumentsWidget> {
  bool isRequiredSelected = true;

  @override
  Widget build(BuildContext context) {
    final weRequired = widget.service.serviceDetails.weRequired;
    final weDeliver = widget.service.serviceDetails.weDeliver;

    if (weRequired.isEmpty && weDeliver.isEmpty) {
      return const SizedBox();
    }
    final currentList = isRequiredSelected ? weRequired : weDeliver;


    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipPath(
            clipper: RightTrapeziumClipper(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
              color: Colors.black,
              child: Text("Documents",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: CustomColor.whiteColor,
                ),
              ),
            ),
          ),
          SizedBox(height: 10,),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
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

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            padding: EdgeInsets.all(16),
            child: Column(
              children: List.generate(currentList.length, (index) {
                final item = currentList[index];

                return Padding(
                  padding:  EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Icon(
                        Icons.check_circle_outline,
                        size: 16,
                        color: Colors.green,
                      ),
                       SizedBox(width: 6),
                      Expanded(
                        child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if(item.description.isNotEmpty)
                          Text(
                            item.description,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
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
        color: isSelected ?   Colors.grey.shade700 : Colors.white,
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
              : Colors.grey.shade700,
        ),
      ),
    );
  }
}

abstract class ServiceDocument {
  String get title;
  String get description;
}
