import 'package:fetchtrue/core/costants/custom_color.dart';
import 'package:flutter/material.dart';
import '../../../core/widgets/custom_container.dart';
import '../model/checkout_model.dart';


class CompleteStep extends StatelessWidget {
  final CheckOutModel checkoutModel;
  const CompleteStep({super.key, required this.checkoutModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 56,
                width: 56,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 30,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Your Lead has been\nSuccessfully placed',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff2563EB),
                ),
              ),

              const SizedBox(height: 10),

              Text(
                'Thank you for your order with us',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Lead ID',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                   Text(
                    '${checkoutModel.bookingId}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Date & Time',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                   Text(
                    '${checkoutModel.createdAt}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
        Spacer(),

        CustomContainer(
          color: CustomColor.appColor,
          margin: EdgeInsets.symmetric(horizontal: 50,vertical: 50),
          child: Center(
            child: Text("Go Back To Home",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          onTap: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
      ],
    );
  }
}
