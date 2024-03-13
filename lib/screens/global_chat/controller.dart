import 'package:am_chat/models/message.dart';
import 'package:am_chat/screens/global_chat/model.dart';
import 'package:am_state/am_state.dart';
import 'package:signalr_core/signalr_core.dart';

class ScreenControllerGlobalChat extends AmController<ScreenModelGlobalChat> {
  ScreenControllerGlobalChat(super.model);
  final connection = HubConnectionBuilder()
      .withUrl("https://localhost:7013/globalChat")
      .build();
  // use the command 'refresh();' inside functions to update the view widget
  // ---------------------------------------------------------------------------

  void connectBtn() async {
    if (state.userName.isEmpty) {
      return;
    }
    connection.on("recieveMessage", (args) {
      recieveMessage(
        args?[0].toString() ?? "",
        args?[1].toString() ?? "",
        args?[2] ?? false,
      );
    });
    await connection.start();
    state.connectionState = connection.state == HubConnectionState.connected;
    if (state.connectionState) {
      await connection.invoke("connected", args: [state.userName]);
    }
  }

  void sendBtn() async {
    await connection
        .invoke('sendMessage', args: [state.userName, state.message, false]);
  }

  // =============================[Client side functions]=======================
  void recieveMessage(String userName, String message, bool isFile) {
    state.msgList.add(ChatMessage(
      userName: userName,
      body: message,
      isFile: isFile,
    ));
    refresh();
  }
  //----------------------------------------------------------------------------

  @override
  void onDispose() {
    connection.stop();
  }

  @override
  void onInit() {}
}
