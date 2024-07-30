abstract class CategoryDetailsStates {}

class InitialCategoryDetailsState extends CategoryDetailsStates {}

class SuccessChangeIndexImageState extends CategoryDetailsStates {}


class LoadingSendReportState extends CategoryDetailsStates{}

class SuccessSendReportState extends CategoryDetailsStates{
  String message;

  SuccessSendReportState({required this.message});
}

class FailureSendReportState extends CategoryDetailsStates{
  String error;
  FailureSendReportState({required this.error});
}


class SuccessChangeReportControllerState extends CategoryDetailsStates{}