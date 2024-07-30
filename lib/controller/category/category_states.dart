abstract class CategoryStates {}

class InitialCategoryState extends CategoryStates {}

class ChangeLayoutCategoryState extends CategoryStates {}

class GetCategoryDataSuccessState extends CategoryStates {}

class GetCategoryDataLoadingState extends CategoryStates {
  final bool isFirstFetch;

  GetCategoryDataLoadingState({this.isFirstFetch = false});
}

class GetCategoryDataFailureState extends CategoryStates {}

class GetCategoryDataInternetFailureState extends CategoryStates {
  final String message;

  GetCategoryDataInternetFailureState({required this.message});
}


class ChangeBoxFilterSuccessState extends CategoryStates {}


class GetEducationLevelSuccessState extends CategoryStates {}

class GetEducationLevelLoadingState extends CategoryStates {
  final bool isFirstFetch;

  GetEducationLevelLoadingState({this.isFirstFetch = false});
}

class GetEducationLevelFailureState extends CategoryStates {}
