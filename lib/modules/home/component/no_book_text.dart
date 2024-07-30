import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kotobekia/shared/styles/colors.dart';

class BuildNoBookText extends StatelessWidget{
  const BuildNoBookText({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final font=Theme.of(context)
        .textTheme;
    return SizedBox(
      height: 150.h,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.library_books,color: ColorConstant.dangerColor,size: 30.r,),
            SizedBox(height: 5.h,),
            Text(locale.noBooks,style: font.bodyLarge!
                .copyWith(fontWeight: FontWeight.w500,fontSize: 15.sp),),
            SizedBox(height: 5.h,),
            Text(locale.createFirstBook,style: font.headlineMedium!
                .copyWith(color: Colors.grey,fontSize: 17.sp),),
          ],
        ),
      ),
    );
  }
}