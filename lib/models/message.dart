class ChatMessage {
  String userName;
  String body;
  bool isFile;

  ChatMessage({
    required this.userName,
    required this.body,
    this.isFile = false,
  });
}
