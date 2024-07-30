import 'package:kotobekia/models/identity_user_model/identity_user_model.dart';

abstract class ProfileStates {}

class InitialProfileState extends ProfileStates {}

class SignOutState extends ProfileStates {}

class SetUserState extends ProfileStates {}

class SuccessGetIdentityUserState extends ProfileStates {
  final IdentityUserModel identityUserModel;

  SuccessGetIdentityUserState(this.identityUserModel);
}

class ToggleDarkModeState extends ProfileStates {}

class GetUserDataLoadingState extends ProfileStates {}

class GetUserDataSuccessState extends ProfileStates {}

class GetUserDataFailureState extends ProfileStates {}

class UserChangingGenderState extends ProfileStates {}


class LoadingUpdateUserDataState extends ProfileStates {}

class SuccessUpdateUserDataState extends ProfileStates {
  final String message;

  SuccessUpdateUserDataState(this.message);
}

class FailureUpdateUserDataState extends ProfileStates {
  final String error;

  FailureUpdateUserDataState(this.error);
}



