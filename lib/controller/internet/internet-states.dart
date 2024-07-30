abstract class InternetStates {}

class InitialInternetState extends InternetStates {}

class InternetConnected extends InternetStates {
  final bool isFirst;

  InternetConnected({this.isFirst = false});
}

class InternetNotConnected extends InternetStates {}
