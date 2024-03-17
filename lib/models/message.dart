class ChatMessage {
  String userName;
  String body;
  bool isFile;
  bool ltr;

  ChatMessage({
    required this.userName,
    required this.body,
    this.isFile = false,
    this.ltr = true,
  });
}
