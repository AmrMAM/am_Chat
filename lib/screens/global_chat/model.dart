import 'package:am_chat/models/message.dart';

class ScreenModelGlobalChat {
  String userName = "";
  String message = "";
  List<ChatMessage> msgList = <ChatMessage>[];
  bool connectionState = false;
}
