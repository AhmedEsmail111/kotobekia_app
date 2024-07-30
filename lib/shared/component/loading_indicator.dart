import 'package:flutter/material.dart';
import 'package:kotobekia/shared/styles/colors.dart';

class BuildLoadingIndicator extends StatelessWidget {
  const BuildLoadingIndicator({super.key});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 1.4,
      child: const Center(
        child: CircularProgressIndicator(color: ColorConstant.primaryColor),
      ),
    );
  }
}
