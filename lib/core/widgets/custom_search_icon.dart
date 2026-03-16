import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../costants/custom_color.dart';
import '../costants/custom_icon.dart';

Widget CustomSearchIcon({VoidCallback? onTap}){
  return InkWell(
      onTap: onTap,
      child: Image.asset(CustomIcon.searchIcon, color: Colors.grey.shade700,height: 18,));
}