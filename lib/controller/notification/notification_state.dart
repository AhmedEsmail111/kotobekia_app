part of 'notification_cubit.dart';

@immutable
abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class LoadingGetNotificationState  extends NotificationState {}

class SuccessGetNotificationState  extends NotificationState {}

class FailureGetNotificationState  extends NotificationState {}


class ChangeStateNotificationState  extends NotificationState {}

class LoadingReadNotificationState  extends NotificationState {}

class SuccessReadNotificationState extends NotificationState {}

class FailureReadNotificationState extends NotificationState {}

