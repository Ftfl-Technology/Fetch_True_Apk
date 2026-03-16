import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../costants/custom_color.dart';
import '../costants/text_style.dart';

Widget CustomLabelFormField(
    BuildContext context,
    String label,
    {
      bool isRequired = false,
      bool enabled = true,
      int maxLines = 1,
      int? maxLength,
      String? hint,
      String? prefixText,
      Widget? suffixIcon,
      IconData? icon,
      bool obscureText = false,
      required TextInputType  keyboardType,
      final TextEditingController? controller,
      String? Function(String?)? validator,
      VoidCallback? onTap,
      Iterable<String>? autofillHints,
    }) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          if (icon != null)
            Icon(icon, size: 16, color: Colors.grey),

          if (icon != null) const SizedBox(width: 6),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: label,
                style: const TextStyle(color: Colors.black, fontSize: 14),
                children: isRequired
                    ? const [
                  TextSpan(text: ' *', style: TextStyle(color: Colors.red))]
                    : [],
              ),
            ),
          ),
        ],
      ),
      5.height,
      TextFormField(
        onTap: onTap,
        controller: controller,
        enabled: enabled,
        maxLines: maxLines,
        obscureText: obscureText,
        style: textStyle14(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),
        decoration: InputDecoration(
          hintText: hint,
          prefixText: prefixText,
          suffixIcon: suffixIcon,
          hintStyle: textStyle14(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300)
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color:Colors.grey.shade300)
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300)
          ),
          disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300)
          ),
          filled: true,
          fillColor: enabled ? Colors.white : Colors.grey.shade200,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
        validator: validator,
        autofillHints: autofillHints,
      ),
    ],
  );
}



Widget CustomFormField(
    BuildContext context,
    {
      bool isRequired = false,
      bool enabled = true,
      int maxLines = 1,
      int? maxLength,
      String? hint,
      String? prefixText,
      Widget? suffixIcon,
      bool obscureText = false,
      required TextInputType  keyboardType,
      final TextEditingController? controller,
      String? Function(String?)? validator,
      VoidCallback? onTap,
      Iterable<String>? autofillHints,
    }) {
  return TextFormField(
    onTap: onTap,
    controller: controller,
    enabled: enabled,
    obscureText: obscureText,
    keyboardType: keyboardType,
    style: textStyle14(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),
    decoration: InputDecoration(
      hintText: hint,
      prefixText: prefixText,
      suffixIcon: suffixIcon,
      hintStyle: textStyle14(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),
      border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300)
      ),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color:Colors.grey.shade300)
      ),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300)
      ),
      disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300)
      ),
      filled: true,
      fillColor: enabled ? Colors.white : Colors.grey.shade200,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    ),
    validator: validator,
    autofillHints: autofillHints,
    maxLength: maxLength,
    maxLines: maxLines,
    // autofillHints: const [AutofillHints.telephoneNumber],
    buildCounter: (
        BuildContext context, {
          required int currentLength,
          required bool isFocused,
          required int? maxLength,
        }) {
      return null;
    },

    inputFormatters: [
      FilteringTextInputFormatter.digitsOnly,
      if (maxLength != null) LengthLimitingTextInputFormatter(maxLength),
    ],
  );
}


Widget CustomDescriptionField(BuildContext context,
    String label, {
      required TextEditingController controller,
      bool isRequired = false,
      bool enabled = true,
      int maxLines = 5,
      String? hint,
      Function(String)? onChanged,
      String? Function(String?)? validator,
    }) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      RichText(
        text: TextSpan(
          text: label,
          style: const TextStyle(color: Colors.black, fontSize: 14),
          children: isRequired
              ? const [
            TextSpan(text: ' *', style: TextStyle(color: Colors.red))
          ]
              : [],
        ),
      ),
      const SizedBox(height: 5),
      TextFormField(
        controller: controller,
        enabled: enabled,
        maxLines: maxLines,
        style: textStyle14(
          context,
          color: CustomColor.descriptionColor,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          hintText: hint ?? 'Write a detailed description...',
          hintStyle: textStyle14(
            context,
            color: CustomColor.descriptionColor,
            fontWeight: FontWeight.w400,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: enabled ? Colors.white : Colors.grey.shade200,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
        ),
        onChanged: onChanged,
        validator: validator ??
            (isRequired
                ? (val) {
              if (val == null || val
                  .trim()
                  .isEmpty) {
                return 'Description is required';
              }
              return null;
            }
                : null),
      ),
    ],
  );
}