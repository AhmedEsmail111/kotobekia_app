import 'package:flutter/material.dart';
import 'package:kotobekia/shared/styles/colors.dart';

// ignore: camel_case_types, constant_identifier_names
enum gender { Female, Male,Other }

// Row for choose gender

class BuildGenderRow extends StatelessWidget {
  final BuildContext context;
  final String text;
  final gender character;
  final gender genderValue;
  final void Function(gender?) onChange;

  const BuildGenderRow(
      {super.key,
      required this.onChange,
      required this.context,
      required this.text,
      required this.genderValue,
      required this.character});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<gender>(
          value: genderValue,
          groupValue: character,
          onChanged: onChange,
          activeColor: ColorConstant.primaryColor,
        ),
        Text(
          text,
          style: Theme.of(context)
              .textTheme
              .displayMedium!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
