// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:rankah/core/utils/app_font.dart';
// import 'package:rankah/core/utils/app_padding.dart';

// class HistoryItem extends StatelessWidget {
//   const HistoryItem({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//         margin: const EdgeInsets.all(AppPadding.p8),
//         elevation: 1,
//         child: Container(
//           // height: MediaQuery.of(context).size.height * 0.4,
//           padding: const EdgeInsets.all(AppPadding.p8),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             spacing: 10.h,
//             children: [
//               Row(
//                 children: [
//                   Text("Parking Spot #1",
//                       style: defaultAppTextStyle(
//                           fontSize: AppFontSize.s16,
//                           fontWeight: FontWeight.bold)),
//                   const Spacer(),
//                   Icon(Icons.check_circle, color: Colors.green, size: 24.sp),
//                 ],
//               ),
//               ListTile(
//                 leading: Icon(Icons.location_on_sharp),
//                 title: Text("data"),
//               ),
//             ],
//           ),
//         ));
//   }
// }
