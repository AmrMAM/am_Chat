import 'dart:async';
import 'dart:convert';

import 'package:am_state/am_state.dart';
import 'package:flutter/foundation.dart';
import 'package:signalr_netcore/signalr_client.dart';

class GlobalChatEngine {
  // final _serverUrl = "https://localhost:7013/globalChat";
  final _serverUrl = "https://amapis.somee.com/globalChat";

  late final _connection = HubConnectionBuilder()
      .withUrl(_serverUrl, transportType: HttpTransportType.LongPolling)
      .build();

  final _recieveMessageEvents =
      <void Function(Uint8List username, Uint8List message, bool isFile)>[];

  HubConnectionState get connectionState =>
      _connection.state ?? HubConnectionState.Disconnected;

  set addOnRecieveMessage(
      void Function(Uint8List username, Uint8List message, bool isFile) v) {
    var i = _recieveMessageEvents.indexWhere((element) => element == v);
    if (i == -1) {
      _recieveMessageEvents.add(v);
    } else {
      _recieveMessageEvents[i] = v;
    }
  }

  set deleteOnRecieveMessage(
      void Function(Uint8List username, Uint8List message, bool isFile) v) {
    _recieveMessageEvents.removeWhere((element) => element == v);
  }

  GlobalChatEngine() {
    _connection.on("recieveMessage", (args) {
      var username =
          Uint8List.fromList((args?[0] ?? [] as dynamic).cast<int>().toList());
      var message =
          Uint8List.fromList((args?[1] ?? [] as dynamic).cast<int>().toList());

      for (var element in _recieveMessageEvents) {
        element(
          username,
          message,
          args?[2].toString().toBool() ?? false,
        );
      }
    });
  }

  Future<void> connect(String username) async {
    if (username.isEmpty) {
      return;
    }
    if (connectionState == HubConnectionState.Disconnected) {
      await _connection.start();
      if (connectionState == HubConnectionState.Connected) {
        await _connection.invoke(
          "connected",
          args: [const Utf8Encoder().convert(username)],
        );
      }
    }
  }

  Future<void> stop() async => await _connection.stop();

  Future<void> sendMessage(String username, String message, bool isFile) async {
    await _connection.invoke('sendMessage', args: [
      const Utf8Encoder().convert(username),
      const Utf8Encoder().convert(message),
      false
    ]);
  }
}
