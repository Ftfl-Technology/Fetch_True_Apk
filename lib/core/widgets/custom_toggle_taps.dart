import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomToggleTabs extends StatelessWidget {
  final List<String> labels;
  final int selectedIndex;
  final Function(int index) onTap;

  const CustomToggleTabs({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Stack(
        children: [
          // Animated sliding indicator
          AnimatedAlign(
            duration: const Duration(milliseconds: 300),
            alignment: selectedIndex == 0 ? Alignment.centerLeft : Alignment.centerRight,
            child: FractionallySizedBox(
              widthFactor: 1 / labels.length,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ),
          // Label buttons
          Row(
            children: List.generate(labels.length, (index) {
              return Expanded(
                child: InkWell(
                  onTap: () => onTap(index),
                  borderRadius: BorderRadius.circular(5),
                  child: Center(
                    child: Text(
                      labels[index],
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: selectedIndex == index ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
