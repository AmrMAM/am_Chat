import 'package:am_chat/models/message.dart';
import 'package:flutter/material.dart';

class ScreenModelGlobalChat {
  String userName = "";
  String roomID = "";
  final msgBodyTextController = TextEditingController();
  final msgScrollerController = ScrollController();

  /// create = true;
  bool createOrJoin = true;
  List<ChatMessage> msgList = <ChatMessage>[];
  bool connectionState = false;

  bool ltr = true;
}
