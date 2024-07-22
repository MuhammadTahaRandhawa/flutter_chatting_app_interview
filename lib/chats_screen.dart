import 'package:flutter/material.dart';
import 'package:flutter_chatting_app_interview/messages_screen.dart';
import 'package:flutter_chatting_app_interview/models/group.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key, required this.groups, required this.userId});

  final List<Group> groups;
  final int userId;
  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chatting App'),
      ),
      body: widget.groups.isNotEmpty
          ? ListView.builder(
              itemBuilder: (context, index) => ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MessagesScreen(
                        group: widget.groups[index], userId: widget.userId),
                  ));
                },
                leading: CircleAvatar(
                  child: Text(widget.groups[index].name[0]),
                ),
                title: Text(widget.groups[index].name),
                // subtitle: Text(widget.groups[index].lastMessage),
              ),
              itemCount: widget.groups.length,
            )
          : const Center(
              child: Text("No Groups found for this user"),
            ),
    );
  }
}
