import 'package:fetchtrue/core/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class MonthlyEarningScreen extends StatefulWidget {
  const MonthlyEarningScreen({super.key});

  @override
  State<MonthlyEarningScreen> createState() => _MonthlyEarningScreenState();
}

class _MonthlyEarningScreenState extends State<MonthlyEarningScreen> {
  // States for the sliders
  double areaIndex = 2; // Tier 3
  double populationIndex = 3; // 75,000
  double audienceIndex = 1; // Middle Class

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: 'Monthly Earning Potential', showBackButton: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 1. Top Earning Banner
            _buildEarningBanner(),
            const SizedBox(height: 30),

            // 2. Area Slider
            _buildStepSlider(
              icon: Icons.location_on_outlined,
              title: "Area",
              currentLabel: _getAreaLabel(areaIndex),
              steps: ["Rural", "Tier 2", "Tier 3", "Metro"],
              value: areaIndex,
              onChanged: (val) => setState(() => areaIndex = val),
            ),

            // 3. Population Slider
            _buildStepSlider(
              icon: Icons.groups_outlined,
              title: "Population",
              currentLabel: _getPopLabel(populationIndex),
              steps: ["10,000", "25,000", "50,000", "75,000", "1,00,000"],
              value: populationIndex,
              onChanged: (val) => setState(() => populationIndex = val),
            ),

            // 4. Audience Type Slider
            _buildStepSlider(
              icon: Icons.assignment_ind_outlined,
              title: "Audience Type",
              currentLabel: _getAudienceLabel(audienceIndex),
              steps: ["Budget Class", "Middle Class", "Premium Class"],
              value: audienceIndex,
              onChanged: (val) => setState(() => audienceIndex = val),
            ),

            const SizedBox(height: 40),

            // 5. Disclaimer
             Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("• ", style: TextStyle(color: Colors.grey, fontSize: 18)),
                Expanded(
                  child: Text(
                    "Figures vary based on market trends & local demands.",
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEarningBanner() {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [Colors.blue.shade100.withOpacity(0.5), Colors.blue.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.network('https://cdn-icons-png.flaticon.com/512/2489/2489756.png', width: 60), // Sack icon
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Monthly Earning", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black54)),
              Text("Potential", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black54)),
            ],
          ),
          const Text("₹ 1L - 3L", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF1B5E62))),
        ],
      ),
    );
  }

  Widget _buildStepSlider({
    required IconData icon,
    required String title,
    required String currentLabel,
    required List<String> steps,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: const Color(0xFF6200EE)),
                  const SizedBox(width: 8),
                  Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(8)),
                child: Text(currentLabel, style: const TextStyle(fontWeight: FontWeight.w500)),
              )
            ],
          ),
          const SizedBox(height: 10),
          SliderTheme(
            data: SliderThemeData(
              trackHeight: 4,
              activeTrackColor: const Color(0xFF6200EE),
              inactiveTrackColor: Colors.grey.shade300,
              thumbColor: const Color(0xFF6200EE),
              overlayColor: const Color(0xFF6200EE).withOpacity(0.2),
              tickMarkShape: const RoundSliderTickMarkShape(tickMarkRadius: 4),
              activeTickMarkColor: const Color(0xFF6200EE),
              inactiveTickMarkColor: Colors.grey.shade400,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: steps.map((s) => Text(s, style:  TextStyle(fontSize: 12, color: Colors.grey.shade700))).toList(),
                ),
                Slider(
                  value: value,
                  min: 0,
                  max: (steps.length - 1).toDouble(),
                  divisions: steps.length - 1,
                  onChanged: onChanged,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Label helpers
  String _getAreaLabel(double i) => ["Rural", "Tier 2", "Tier 3", "Metro"][i.toInt()];
  String _getPopLabel(double i) => ["10k", "25k", "50k", "75k", "1 Lakhs"][i.toInt()];
  String _getAudienceLabel(double i) => ["Budget", "Middle Class", "Premium"][i.toInt()];
}