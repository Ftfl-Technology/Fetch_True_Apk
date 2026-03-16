import 'package:fetchtrue/core/costants/dimension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/costants/custom_color.dart';
import '../../../core/costants/custom_icon.dart';
import '../../../core/costants/text_style.dart';
import '../../../core/widgets/custom_container.dart';
import '../../../helper/Contact_helper.dart';
import '../model/lead_model.dart';

Widget customerDetails(BuildContext context, LeadModel lead){

  final phoneNumber = lead.serviceCustomer!.phone.toString();
  final message = 'Hello, I am contacting you from Fetch True.';

  return CustomContainer(
    border: true,
    color: Colors.white,
    margin: EdgeInsets.zero,
    width: double.infinity,
    child: Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Customer Details', style: textStyle12(context),),
            5.height,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name : ${lead.serviceCustomer!.fullName}', style:  textStyle12(context, fontWeight: FontWeight.w400)),
                Text('Phone : ${lead.serviceCustomer!.phone}',  style:  textStyle12(context, fontWeight: FontWeight.w400)),
                // Text('Email Id : ${lead.serviceCustomer!.email}',  style: textStyle12(context, color: CustomColor.descriptionColor, fontWeight: FontWeight.w400),),
                // Text('Address: ${lead.serviceCustomer.a}, ${lead.serviceCustomer!.city}, ${lead.serviceCustomer!.state}',  style:  textStyle12(context, fontWeight: FontWeight.w400)),

                if(lead.notes!.isNotEmpty)
                Text('Note : ${lead.notes}', style: textStyle12(context, fontWeight: FontWeight.w400)),
              ],
            ),
          ],
        ),

        Positioned(
            top: 20,right: 20,
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(onTap: () => ContactHelper.whatsapp('+91$phoneNumber', message),
                    child: Image.asset(CustomIcon.whatsappIcon, height: 25, )),
                40.width,
                InkWell(onTap: () => ContactHelper.call('+91$phoneNumber'),
                    child: Image.asset(CustomIcon.phoneIcon, height: 25, color: CustomColor.appColor,)),
              ],
            ))
      ],
    ),
  );
}
