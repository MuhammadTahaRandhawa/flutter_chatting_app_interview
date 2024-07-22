class Group {
  final int id;
  final String name;
  final String lastMessage;
  final List<int> participants;

  Group(
      {required this.id,
      required this.name,
      required this.lastMessage,
      required this.participants});
}
