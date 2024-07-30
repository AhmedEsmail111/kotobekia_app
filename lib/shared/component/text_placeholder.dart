import 'package:flutter/material.dart';

class BuildTextPlaceHolder extends StatelessWidget {
  final String text;

  const BuildTextPlaceHolder({super.key, required this.text});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        maxLines: 2,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w700,
            ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
