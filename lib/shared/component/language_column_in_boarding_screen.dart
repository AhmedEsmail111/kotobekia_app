import 'package:flutter/material.dart';
import 'package:kotobekia/shared/styles/colors.dart';

// Language Column in boarding screen for choose language

class BuildLanguageColumn extends StatelessWidget {
  final String containerText;
  final String languageText;
  final BuildContext context;
  final VoidCallback onTap;
  final bool check;

  const BuildLanguageColumn(
      {super.key,
      required this.containerText,
      required this.context,
      required this.onTap,
      required this.check,
      required this.languageText});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Card(
            shape: RoundedRectangleBorder(
                side: check
                    ? const BorderSide(color: ColorConstant.primaryColor)
                    : const BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            child: Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height / 10,
              width: MediaQuery.of(context).size.height / 10,
              child: Text(
                containerText,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        Text(
          languageText,
          style: Theme.of(context).textTheme.titleMedium,
        )
      ],
    );
  }
}
