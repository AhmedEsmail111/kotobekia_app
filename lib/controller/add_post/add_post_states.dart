abstract class AddPostStates {}

class InitialAddPostState extends AddPostStates {}

class UserSelectingImagesAddPostState extends AddPostStates {}

class UserChangingEducationLevelAddPostState extends AddPostStates {}

class UserChangingTitleAddPostState extends AddPostStates {}

class UserChangingDescriptionAddPostState extends AddPostStates {}

class UserChangingPriceAddPostState extends AddPostStates {}

class UserChangingBooksCountAddPostState extends AddPostStates {}

class UserChangingGradeAddPostState extends AddPostStates {}

class UserChangingEducationTypeAddPostState extends AddPostStates {}

class UserChangingSemesterAddPostState extends AddPostStates {}

class UserChangingBookEditionAddPostState extends AddPostStates {}

class UserChangingRegionAddPostState extends AddPostStates {}

class TogglePriceButton extends AddPostStates {}

class SendNewPostSuccess extends AddPostStates {}

class SendNewPostLoading extends AddPostStates {}

class SendNewPostFailure extends AddPostStates {
  String message;

  SendNewPostFailure(this.message);
}

class SendNewPostInternetFailure extends AddPostStates {
  final String message;

  SendNewPostInternetFailure({required this.message});
}

class ResetDataOnPop extends AddPostStates {}

class HasErrorState extends AddPostStates {}
