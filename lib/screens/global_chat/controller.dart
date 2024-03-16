import 'dart:convert';
import 'package:am_chat/models/message.dart';
import 'package:am_chat/screens/global_chat/model.dart';
import 'package:am_state/am_state.dart';
import 'package:signalr_netcore/signalr_client.dart';

class ScreenControllerGlobalChat extends AmController<ScreenModelGlobalChat> {
  ScreenControllerGlobalChat(super.model);

  // final serverUrl = "https://localhost:7013/globalChat";
  final serverUrl = "https://amapis.somee.com/globalChat";

  late final connection = HubConnectionBuilder()
      .withUrl(serverUrl, transportType: HttpTransportType.LongPolling)
      .build();

  // use the command 'refresh();' inside functions to update the view widget
  // ---------------------------------------------------------------------------
  void toggleCreateJoin() {
    state.createOrJoin = !state.createOrJoin;
    refresh();
  }

  void connectBtn() async {
    if (state.userName.isEmpty) {
      return;
    }
    if (!state.connectionState) {
      await connection.start();
      state.connectionState = connection.state == HubConnectionState.Connected;
      if (state.connectionState) {
        await connection.invoke("connected", args: [state.userName]);
      }
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
      body: const Utf8Decoder().convert(message.codeUnits),
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
  void onInit() {
    connection.on("recieveMessage", (args) {
      recieveMessage(
        args?[0].toString() ?? "",
        args?[1].toString() ?? "",
        args?[2].toString().toBool() ?? false,
      );
    });
  }
}
