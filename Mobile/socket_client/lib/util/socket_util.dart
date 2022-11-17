import 'dart:io';
import 'dart:convert';

class SocketUtil {
  late Socket _socket;
  static const String SERVER_IP = '';
  static const int SERVER_PORT = 6000;

  Future<bool> sendMessage(String message) async {
    try {
      _socket = await Socket.connect(SERVER_IP, SERVER_PORT);
      _socket.listen((List<int> event) {
        String message = utf8.decode(event);
        print('message: $message');
      });
      _socket.add(utf8.encode(message));
      _socket.close();
    } catch (e) {
      return false;
    }
    return true;
  }

  void cleanUp() {
    if (_socket != null) {
      _socket.destroy();
    }
  }
}
