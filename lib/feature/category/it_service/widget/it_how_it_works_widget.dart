import 'package:flutter/material.dart';
import '../model/it_service_details_model.dart';

class ItHowItWorksWidget extends StatelessWidget {
  final ServiceDetails howItWork;
  const ItHowItWorksWidget({super.key, required this.howItWork});

  static const int itemsPerRow = 2;

  @override
  Widget build(BuildContext context) {
    final int totalItems = howItWork.howItWorks.length;
    final int totalRows = (totalItems / itemsPerRow).ceil();

    return Column(
      children: List.generate(totalRows, (rowIndex) {
        final bool isEvenRow = rowIndex % 2 == 0;

        final int firstIndex = rowIndex * itemsPerRow;
        final int secondIndex = firstIndex + 1;

        return Column(
          children: [
            Row(
              children: isEvenRow
                  ? _buildLeftToRight(firstIndex, secondIndex)
                  : _buildRightToLeft(firstIndex, secondIndex),
            ),

            if (rowIndex != totalRows - 1)
              _downArrow(isEvenRow),
          ],
        );
      }),
    );
  }

  List<Widget> _buildLeftToRight(int first, int second) {
    return [
      _cardIfExists(first),
      _horizontalArrow(show: second < howItWork.howItWorks.length),
      _cardIfExists(second),
    ];
  }

  List<Widget> _buildRightToLeft(int first, int second) {
    return [
      _cardIfExists(second),
      _horizontalArrow(
        show: first < howItWork.howItWorks.length,
        reverse: true,
      ),
      _cardIfExists(first),
    ];
  }

  Widget _cardIfExists(int index) {
    if (index >= howItWork.howItWorks.length) {
      return const Expanded(child: SizedBox(height: 110));
    }

    final item = howItWork.howItWorks[index];

    return Expanded(
      child: Container(
        height: 120,
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              (index + 1).toString().padLeft(2, '0'),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              maxLines: 1,
            ),
            const SizedBox(height: 4),
            Text(
              item.title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              maxLines: 2,
            ),
            const SizedBox(height: 4),
            Text(
              item.description,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
              maxLines: 3,
              overflow: TextOverflow.clip,
            ),
          ],
        ),
      ),
    );
  }

  Widget _horizontalArrow({required bool show, bool reverse = false}) {
    return SizedBox(
      width: 30,
      height: 110,
      child: show
          ? Icon(
        reverse ? Icons.arrow_back : Icons.arrow_forward,
        color: Colors.blue,
      )
          : const SizedBox.shrink(),
    );
  }

  Widget _downArrow(bool isEvenRow) {
    return SizedBox(
      height: 30,
      child: Row(
        children: [
          Expanded(
            child: isEvenRow
                ? const SizedBox.shrink()
                : const Icon(Icons.arrow_downward, color: Colors.blue),
          ),
          Expanded(
            child: isEvenRow
                ? const Icon(Icons.arrow_downward, color: Colors.blue)
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
