import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kotobekia/controller/category_details/category_details_states.dart';
import 'package:kotobekia/shared/constants/api/api_constant.dart';
import 'package:kotobekia/shared/constants/app/app_constant.dart';
import 'package:kotobekia/shared/network/local/local.dart';
import 'package:kotobekia/shared/network/remote/remote.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class CategoryDetailsCubit extends Cubit<CategoryDetailsStates> {
  CategoryDetailsCubit() : super(InitialCategoryDetailsState());

  static CategoryDetailsCubit get(context) => BlocProvider.of(context);

  void sharePost(String postUrl) {
    final url = Uri.parse('${AppConstant.baseShareUrl}/post/$postUrl');
    Share.shareUri(url);
  }

  void handleCall(String phoneNumber) async {
    final phoneUrl = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(phoneUrl)) {
      await launchUrl(phoneUrl);
    }
  }

  int currentIndex = 0;

  void changeIndexImage(int index) {
    currentIndex = index;
    emit(SuccessChangeIndexImageState());
  }


  void sendReport({
    required String reportType,
    required String postId,
    required String userId,
    required String feedback,
}) {
    emit(LoadingSendReportState());
    DioHelper.postData(
        lang: AppConstant.lang,
        url: ApiConstant.sendReportUrl,
        token: CacheHelper.getData(key: AppConstant.token),
    data: {
      "report_type":reportType,
      "report_id": postId,
      "reported_user_id": userId,
      "user_feedback": feedback
    }
    ).then((value) {
      emit(SuccessSendReportState(message: value.data['message']));
    }).catchError((error){
      if(error is DioError){
        emit(FailureSendReportState(error: error.response!.data['msgError']));
      }else{
        emit(FailureSendReportState(error: error.toString()));
      }

    });
  }
  TextEditingController reportController=TextEditingController();
  void changeReportText(String text){
    reportController.text=text;
    emit(SuccessChangeReportControllerState());
  }
}
