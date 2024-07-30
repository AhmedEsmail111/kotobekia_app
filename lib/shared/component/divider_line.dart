import 'package:flutter/material.dart';

import '../styles/colors.dart';

class BuildDividerLine extends StatelessWidget {
  final double thickness;
  const BuildDividerLine({
    super.key,
     this.thickness=1,
  });

  @override
  Widget build(BuildContext context) {
    return Divider(color: Theme.of(context).dividerColor, thickness: thickness);
  }
}
