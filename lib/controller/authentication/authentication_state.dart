part of 'authentication_cubit.dart';

@immutable
abstract class AuthenticationState {}

class AuthenticationInitial extends AuthenticationState {}

class LoadingUserCreateAccountState extends AuthenticationState {}

class SuccessUserCreateAccountState extends AuthenticationState {
  final UserModel userModel;

  SuccessUserCreateAccountState(this.userModel);
}
class SuccessSendFcmTokenState extends AuthenticationState {
}
class FailedSendFcmTokenState extends AuthenticationState {
  final String error;
  FailedSendFcmTokenState(this.error);
}



class FailedUserCreateAccountState extends AuthenticationState {
  final String error;

  FailedUserCreateAccountState(this.error);
}

class LoadingUserLoginState extends AuthenticationState {}

class SuccessUserLoginState extends AuthenticationState {
  final UserModel userModel;

  SuccessUserLoginState(this.userModel);
}

class FailedUserLoginState extends AuthenticationState {
  final String error;

  FailedUserLoginState(this.error);
}

class SuccessChangeGenderState extends AuthenticationState {}

class SuccessChangeVisibilityPasswordState extends AuthenticationState {}

class ChangeDefaultLanguageAuthenticationState extends AuthenticationState {}


class LoadingChangePasswordState extends AuthenticationState {}

class SuccessChangePasswordState extends AuthenticationState {
  final String message;

  SuccessChangePasswordState(this.message);
}

class FailedChangePasswordState extends AuthenticationState {
  final String error;
  FailedChangePasswordState(this.error);
}

class FailedNoInternetConnectionState extends AuthenticationState {}

class LoadingDeleteAccountState extends AuthenticationState {}

class SuccessDeleteAccountState extends AuthenticationState {}

class FailedDeleteAccountState extends AuthenticationState {
  final String error;
  FailedDeleteAccountState(this.error);
}


class LoadingSignInWithGoogleState extends AuthenticationState {}

class SuccessSignInWithGoogleState extends AuthenticationState {
  final String name;
  final String email;
  SuccessSignInWithGoogleState({required this.name, required this.email});
}

class FailedSignInWithGoogleState extends AuthenticationState {
  final String error;
  FailedSignInWithGoogleState(this.error);
}

class LoadingUserAuthWithGoogleState extends AuthenticationState {}

class SuccessUserAuthWithGoogleState extends AuthenticationState {
  final UserModel userModel;

  SuccessUserAuthWithGoogleState(this.userModel);
}

class FailedUserAuthWithGoogleState extends AuthenticationState {
  final String error;

  FailedUserAuthWithGoogleState(this.error);
}