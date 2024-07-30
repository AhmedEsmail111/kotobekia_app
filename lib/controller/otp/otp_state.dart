part of 'otp_cubit.dart';

@immutable
abstract class OtpState {}

class OtpInitial extends OtpState {}

class OtpCollectResultState extends OtpState {}

class LoadingVerifyOtpState extends OtpState {}

class SuccessVerifyOtpState extends OtpState {
  final OtpModel otpModel;

  SuccessVerifyOtpState(this.otpModel);
}

class FailedVerifyOtpState extends OtpState {
  final String error;

  FailedVerifyOtpState(this.error);
}


class SuccessResendOtpAndStartTimerState extends OtpState {}

class LoadingResendOtpState extends OtpState {}


class FailedResendOtpState extends OtpState {
  final String error;

  FailedResendOtpState(this.error);
}

class SuccessResendOtpState extends OtpState {
  final OtpModel otpModel;

  SuccessResendOtpState(this.otpModel);
}


class LoadingVerifyForgetOtpState extends OtpState {}

class SuccessVerifyForgetOtpState extends OtpState {
  final OtpModel otpModel;

  SuccessVerifyForgetOtpState(this.otpModel);
}

class FailedVerifyForgetOtpState extends OtpState {
  final String error;

  FailedVerifyForgetOtpState(this.error);
}
class FailedNoInternetConnectionOtpState extends OtpState {}