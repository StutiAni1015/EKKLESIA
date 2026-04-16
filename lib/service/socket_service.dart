import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static IO.Socket? socket;

  static void connect(String userId) {
    socket = IO.io(
      // 'http://10.0.2.2:4000', // ⚠️ Android emulator
      'http://127.0.0.1:4000', // ⚠️ iOS simulator
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket!.connect();

    socket!.onConnect((_) {
      print("✅ Socket Connected");

      // register user room
      socket!.emit("register", userId);
    });

    socket!.onDisconnect((_) {
      print("❌ Socket Disconnected");
    });
  }

  static void listenNotifications(Function(String) callback) {
    socket?.on("newNotification", (data) {
      print("🔔 Notification received: $data");

      callback(data["message"]);
    });
  }

  static void disconnect() {
    socket?.disconnect();
  }
}