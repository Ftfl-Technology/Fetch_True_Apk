import 'package:flutter/material.dart';

class CustomDropdownField extends StatelessWidget {
  final String headline;
  final String label;
  final List<String> items;
  final ValueNotifier<String> selectedValue;
  final bool isRequired;

  const CustomDropdownField({
    super.key,
    required this.label,
    required this.headline,
    required this.items,
    required this.selectedValue,
    this.isRequired = true,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: selectedValue,
      builder: (context, value, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 Headline with * if required
            RichText(
              text: TextSpan(
                text: headline,
                style: const TextStyle(color: Colors.black, fontSize: 14),
                children: isRequired
                    ? const [TextSpan(text: ' *', style: TextStyle(color: Colors.red))]
                    : [],
              ),
            ),
            const SizedBox(height: 5),

            /// 🔹 Dropdown Field
            DropdownButtonFormField<String>(
              value: items.contains(value) ? value : null,
              icon: const Icon(Icons.arrow_drop_down_outlined),
              style: const TextStyle(fontSize: 14, color: Colors.black),
              decoration: InputDecoration(
                hintText: label,
                hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                filled: true,
                fillColor: Colors.white,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
              items: items.toSet().map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: IntrinsicWidth(child: Text(item)),
                );
              }).toList(),
              onChanged: (newValue) {
                if (newValue != null) {
                  selectedValue.value = newValue;
                }
              },
            ),
          ],
        );
      },
    );
  }
}
