import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


Widget vertical (double height) {
  return SizedBox(
    height: height.h,
  );
}
Widget horizontal (double width) {
  return SizedBox(
    width: width.w,
  );
}
