import 'dart:convert';
import 'dart:typed_data';
import 'package:am_chat/models/message.dart';
import 'package:am_chat/screens/global_chat/model.dart';
import 'package:am_chat/services/global_chat_engine.dart';
import 'package:am_state/am_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:signalr_netcore/signalr_client.dart';

class ScreenControllerGlobalChat extends AmController<ScreenModelGlobalChat> {
  ScreenControllerGlobalChat(super.model);
  // use the command 'refresh();' inside functions to update the view widget
  // ---------------------------------------------------------------------------

  final globalChat = GlobalChatEngine();

  bool get showConnect =>
      globalChat.connectionState != HubConnectionState.Connected;

  void toggleCreateJoin() {
    state.createOrJoin = !state.createOrJoin;
    refresh();
  }

  void toggleLTR() {
    state.ltr = !state.ltr;
    refresh();
  }

  void connectBtn() async {
    if (state.userName.isEmpty) {
      return;
    }
    if (globalChat.connectionState == HubConnectionState.Disconnected) {
      await globalChat.connect(state.userName);
    }
    refresh();
  }

  void sendBtn() async {
    var ltr = "ltr:${state.ltr ? 1 : 0}";
    await globalChat.sendMessage(
        state.userName, ltr + state.msgBodyTextController.text, false);
    state.msgBodyTextController.clear();
  }

  // =============================[Client side functions]=======================
  void _recieveMessageEvent(
      Uint8List userName, Uint8List message, bool isFile) async {
    var convert = const Utf8Decoder().convert;
    var username = convert(userName);
    var msg = convert(message);
    bool ltr = msg.substring(0, 5) == "ltr:1";

    if (username == "amAPIs") {
      ltr = true;
    } else {
      msg = msg.substring(5);
    }
    state.msgList.add(ChatMessage(
      userName: username,
      body: msg,
      isFile: isFile,
      ltr: ltr,
    ));
    refresh();
    Future.delayed(const Duration(milliseconds: 100))
        .then((value) => state.msgScrollerController.position.moveTo(
              state.msgScrollerController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            ));
  }

  //----------------------------------------------------------------------------
  @override
  void onDispose() {
    globalChat.stop();
  }

  @override
  void onInit() {
    globalChat.addOnRecieveMessage = _recieveMessageEvent;
  }
}
