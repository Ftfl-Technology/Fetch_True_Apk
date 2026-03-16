import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class EarningComparisonWidget extends StatefulWidget {
  const EarningComparisonWidget({super.key});

  @override
  State<EarningComparisonWidget> createState() =>
      _EarningComparisonWidgetState();
}

class _EarningComparisonWidgetState extends State<EarningComparisonWidget> {
  bool isHighEarning = true;

  /// Dummy data
  final highEarningData = [20.0, 65.0, 35.0, 70.0, 58.0];
  final lowInvestmentData = [40.0, 30.0, 50.0, 25.0, 45.0];

  @override
  Widget build(BuildContext context) {
    final barData = isHighEarning ? highEarningData : lowInvestmentData;

    return Column(
      children: [
        50.height,
        Text('Our Best Franchise Investment\nOffer for you ', style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),textAlign: TextAlign.center,),
        10.height,
        /// 🔹 Toggle Tabs
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              _ToggleTab(
                title: "High earning",
                selected: isHighEarning,
                onTap: () => setState(() => isHighEarning = true),
              ),
              _ToggleTab(
                title: "Low Investment",
                selected: !isHighEarning,
                onTap: () => setState(() => isHighEarning = false),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        /// 🔹 Chart Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Year Chips
              Row(
                children: const [
                  _YearChip(title: "Year 2025", selected: true),
                  _YearChip(title: "Year 2024"),
                  _YearChip(title: "Year 2023"),
                ],
              ),

              const SizedBox(height: 16),

              /// Chart
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  /// Y Axis
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("High",
                          style: TextStyle(
                              color: Colors.teal,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text("60%"),
                      Text("50%"),
                      Text("40%"),
                      Text("30%"),
                      Text("20%"),
                      Text("10%"),
                      Text("0"),
                    ],
                  ),

                  const SizedBox(width: 16),

                  /// Bars
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(
                        barData.length,
                            (index) => _BarItem(
                          value: barData[index],
                          color: index.isOdd
                              ? Colors.teal
                              : Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              /// Brands
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: const [
                  _BrandCircle(text: "Food"),
                  _BrandCircle(text: "BK"),
                  _BrandCircle(text: "Nest"),
                  _BrandCircle(text: "Pizza"),
                  _BrandCircle(text: "McD"),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
class _ToggleTab extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _ToggleTab({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 5),
          margin: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: selected ? CustomColor.franchise : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: selected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class _YearChip extends StatelessWidget {
  final String title;
  final bool selected;

  const _YearChip({required this.title, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? const Color(0xffF1F3FF) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(title,
            style: TextStyle(
                fontSize: 12,
                fontWeight:
                selected ? FontWeight.bold : FontWeight.normal)),
      ),
    );
  }
}

class _BarItem extends StatelessWidget {
  final double value;
  final Color color;

  const _BarItem({
    required this.value,
    this.color = Colors.teal,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text("${value.toInt()}%"),
        const SizedBox(height: 6),
        Container(
          height: value * 2, // scale
          width: 18,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ],
    );
  }
}

class _BrandCircle extends StatelessWidget {
  final String text;

  const _BrandCircle({required this.text});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 16,
      backgroundColor: Colors.grey.shade200,
      child: Text(
        text,
        style:  TextStyle(fontSize: 10, color: CustomColor.franchise),
      ),
    );
  }
}
