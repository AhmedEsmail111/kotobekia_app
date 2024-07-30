import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildSmallLoadingIndicator extends StatelessWidget {
  const BuildSmallLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 15.w,
      height: 15.w,
      child: const CircularProgressIndicator(
          color: Colors.red,
          strokeWidth: 2),
    );
  }
}
