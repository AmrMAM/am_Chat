import 'package:am_chat/models/message.dart';

class ScreenModelGlobalChat {
  String userName = "";
  String roomID = "";
  String message = "";

  /// create = true;
  bool createOrJoin = true;
  List<ChatMessage> msgList = <ChatMessage>[];
  bool connectionState = false;
}
