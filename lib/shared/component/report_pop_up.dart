import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kotobekia/controller/category_details/category_details_cubit.dart';
import 'package:kotobekia/controller/category_details/category_details_states.dart';
import 'package:kotobekia/shared/component/default_text_form_in_app.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BuildReportPopUp extends StatelessWidget {
  final String postId;
  final String userId;
  final String postType;

  const BuildReportPopUp({
    super.key,
    required this.postId,
    required this.userId,
    required this.postType,
  });

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    var font = Theme.of(context).textTheme;
    var cubit = context.read<CategoryDetailsCubit>();
    return BlocBuilder<CategoryDetailsCubit,CategoryDetailsStates>(
       builder:  (context, state) {
         return AlertDialog(
           title: Text(locale.reportTitle),
           content: SizedBox(
             width: 500.w,
             child: Column(
               mainAxisSize: MainAxisSize.min,
               children: [
                 BuildDefaultTextField(
                   onChange: (String value) {
                     cubit.changeReportText(value);
                   },
                   controller:  cubit.reportController,
                   inputType: TextInputType.text,
                   withText: true,
                   maxLines: 10,
                   aboveFieldText: locale.writeFeedback,
                   hintText: locale.feedback,
                   backGroundColor: Colors.white,
                   context: context,
                   width: double.infinity,
                   height: 100,
                   maxLenght: 1000,
                   isObscured: false,
                 ),
                 SizedBox(height: 14.h),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     ElevatedButton(
                       onPressed: () {
                         cubit.reportController.clear();
                         Navigator.pop(context); // Close the dialog
                       },
                       child: Text(
                         locale.close,
                         style: font.displayLarge!.copyWith(color: Colors.red),
                       ),
                     ),
                     SizedBox(
                       width: 50.w,
                     ),
                     ElevatedButton(
                       onPressed: cubit.reportController.text.trim().isEmpty?null: ()
                       {
                         cubit.sendReport(
                             reportType: postType,
                             postId: postId,
                             userId: userId,
                             feedback:  cubit.reportController.text.trim());
                         cubit.reportController.clear();

                       },
                       child:Text(
                         locale.send,
                         style: font.displayLarge!
                             .copyWith(color:cubit.reportController.text.trim().isEmpty?Colors.grey: Colors.blueAccent),
                       ),
                     ),
                   ],
                 )
               ],
             ),
           ),
         );
       },
    );
  }
}


