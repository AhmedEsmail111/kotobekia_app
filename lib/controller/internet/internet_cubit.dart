import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:kotobekia/controller/internet/internet-states.dart';

class InternetCubit extends Cubit<InternetStates> {
  InternetCubit() : super(InitialInternetState());
  static InternetCubit get(context) => BlocProvider.of(context);

  var isDeviceConnected = false;
  // to prevent showing the snack bar of internet connected the first time the user open the app
  var isFirst = true;
  StreamSubscription? subscription;

  void checkConnectivity() {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      if (result != ConnectivityResult.none) {
        isDeviceConnected = await InternetConnectionChecker().hasConnection;
        if (isDeviceConnected) {
          emit(InternetConnected(isFirst: isFirst));
        }
      } else {
        // the first time the user lose connection will set the var to false so when he reconnect anytime after he will see the snackbar message
        isFirst = false;
        emit(InternetNotConnected());
      }
    });
  }
}
