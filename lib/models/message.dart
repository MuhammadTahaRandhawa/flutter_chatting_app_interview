class Message {
  final int senderId;
  final DateTime sentTime;
  final String messageText;

  Message(
      {required this.senderId,
      required this.sentTime,
      required this.messageText});
}
