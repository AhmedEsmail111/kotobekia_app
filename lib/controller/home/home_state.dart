import 'package:kotobekia/models/identity_user_model/identity_user_model.dart';

abstract class HomeStates {}

class InitialHomeState extends HomeStates {}

class ChangeBottomNavBarHomeState extends HomeStates {
  final int index;

  ChangeBottomNavBarHomeState(this.index);
}
class SuccessGetIdentityUserState extends HomeStates {
  final IdentityUserModel identityUserModel;

  SuccessGetIdentityUserState(this.identityUserModel);
}
class GetHomeDataSuccessHomeState extends HomeStates {}

class GetHomeDataFailureHomeState extends HomeStates {}

class GetHomeDataInternetFailureHomeState extends HomeStates {
  final String message;

  GetHomeDataInternetFailureHomeState({required this.message});
}

class GetHomeDataLoadingHomeState extends HomeStates {}

class ChangeModalBottomSheetHomeState extends HomeStates {}

class LoadingSearchState extends HomeStates{}

class SuccessSearchState extends HomeStates{}

class FailureSearchState extends HomeStates{}


class SuccessChangeCityState extends HomeStates{}




