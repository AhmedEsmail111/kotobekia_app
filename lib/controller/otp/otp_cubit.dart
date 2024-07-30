import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kotobekia/models/otp_model/otp_model.dart';
import 'package:kotobekia/shared/constants/app/app_constant.dart';
import 'package:kotobekia/shared/helper/functions.dart';
import 'package:kotobekia/shared/network/remote/remote.dart';
import '../../shared/constants/api/api_constant.dart';
part 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  OtpCubit() : super(OtpInitial());

  static OtpCubit get(context) => BlocProvider.of(context);

  var firstNumberController = TextEditingController();
  var secondNumberController = TextEditingController();
  var thirdNumberController = TextEditingController();
  var fourNumberController = TextEditingController();
  String otpResult = '';

  void otpResultCollect() {
    otpResult = '';
    otpResult = firstNumberController.text.toString() +
        secondNumberController.text.toString() +
        thirdNumberController.text.toString() +
        fourNumberController.text.toString();
    emit(OtpCollectResultState());
  }

  OtpModel? otpModel;

  void verifyOtp({
    String? email,
    String? phone,
    required String otp,
  }) async {
    emit(LoadingVerifyOtpState());
    if (await HelperFunctions.hasConnection()) {
      try {
        final response = await DioHelper.postData(
            lang: AppConstant.lang,
            url: ApiConstant.verifyOtp,
            data: {'email': email, 'phoneNumber': phone, 'OTP': otp});
        Map<String, dynamic> responseData = response.data;
        otpModel = OtpModel.fromJson(responseData);
        emit(SuccessVerifyOtpState(otpModel!));
      } catch (error) {
        if (error is DioError) {
          Map<String, dynamic> responseData = error.response!.data;
          otpModel = OtpModel.fromJson(responseData);
          emit(FailedVerifyOtpState(otpModel!.message.toString()));
        } else {
          emit(FailedVerifyOtpState(error.toString()));
        }
      }
    } else {
      emit(FailedNoInternetConnectionOtpState());
    }
  }

  void resendOtp({String? email, String? phone}) async {
    if (await HelperFunctions.hasConnection()) {
      try {
        final response = await DioHelper.postData(
            lang: AppConstant.lang,
            url: ApiConstant.resendOtp,
            data: {'email': email, 'phoneNumber': phone});

        Map<String, dynamic> responseData = response.data;
        otpModel = OtpModel.fromJson(responseData);
        emit(SuccessResendOtpState(otpModel!));
      } catch (error) {
        if(error is DioError){
          emit(FailedResendOtpState(error.response!.data['msgError']));
        }else{
          emit(FailedResendOtpState(error.toString()));
        }
      }
    } else {
      emit(FailedNoInternetConnectionOtpState());
    }
  }

  void sendCodeOtp({String? email, String? phone}) async {
    emit(LoadingResendOtpState());
    if (await HelperFunctions.hasConnection()) {
      try {
        final response = await DioHelper.patchData(
            lang: AppConstant.lang,
            url: ApiConstant.sendCodeOtp,
            data: {'email': email, 'phoneNumber': phone});
        Map<String, dynamic> responseData = response.data;
        otpModel = OtpModel.fromJson(responseData);
        emit(SuccessResendOtpState(otpModel!));
      } catch (error) {
        if(error is DioError){
          emit(FailedResendOtpState(error.response!.data['msgError']));
        }else{
          emit(FailedResendOtpState(error.toString()));
        }
      }
    } else {
      emit(FailedNoInternetConnectionOtpState());
    }
  }

  int secondsRemaining = 30;
  bool enableResend = true;
  Timer? timer;

  void resendOtpTimer() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining != 0) {
        enableResend = false;
        secondsRemaining--;
      } else {
        secondsRemaining = 30;
        enableResend = true;
        timer.cancel();
      }
      emit(SuccessResendOtpAndStartTimerState());
    });
  }

  void verifyForgetCode(
      {String? email, String? phone, required String forgetCode}) async {
    emit(LoadingVerifyForgetOtpState());
    if (await HelperFunctions.hasConnection()) {
      DioHelper.postData(
          lang: AppConstant.lang,
          url: ApiConstant.verifyForgetCode,
          data: {
            'email': email,
            'phoneNumber': phone,
            'forgetCode': forgetCode
          }).then((value) {
        Map<String, dynamic> responseData = value.data;
        otpModel = OtpModel.fromJson(responseData);
        emit(SuccessVerifyForgetOtpState(otpModel!));
      }).catchError((error) {
        if(error is DioError){
          emit(FailedVerifyForgetOtpState(error.response!.data['msgError']));
        }else{
          emit(FailedVerifyForgetOtpState(error.toString()));
        }

      });
    } else {
      emit(FailedNoInternetConnectionOtpState());
    }
  }
}
