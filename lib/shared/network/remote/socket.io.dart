
import 'package:kotobekia/shared/constants/app/app_constant.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketIO {
  static io.Socket? socket;
  static void connect() {
    socket = io.io(AppConstant.socketURL, <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    socket!.connect();
    socket!.onError((data) {
      print(data);
    });
    socket!.onDisconnect((_) {
      print('Disconnected from the socket server');
    });

  }


}