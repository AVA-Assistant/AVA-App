import 'package:socket_io_client/socket_io_client.dart';

late Socket socket;

Socket initSocket() {
  socket = io("http://localhost:2500", <String, dynamic>{
    'force new connection': true,
    "transports": ['websocket']
  });
  return socket;
}
