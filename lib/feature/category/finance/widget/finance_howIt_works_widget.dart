import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:flutter/material.dart';

import '../model/finance_service_details_model.dart';


class FinanceHowItWorksWidget extends StatelessWidget {
  final List<HowItWorksItem> items;

  const FinanceHowItWorksWidget({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemBuilder: (context, index) {
        return _TimelineItem(
          item: items[index],
          isLast: index == items.length - 1,
        );
      },
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final HowItWorksItem item;
  final bool isLast;

  const _TimelineItem({
    required this.item,
    required this.isLast,
  });

  static  Color gold = CustomColor.finance;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// LEFT TIMELINE
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration:  BoxDecoration(
                  color: gold,
                  shape: BoxShape.circle,
                ),
              ),

              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: gold,
                  ),
                ),
            ],
          ),

          const SizedBox(width: 16),

          /// RIGHT CONTENT
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(item.icon, height: 26),
                  const SizedBox(height: 6),
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
