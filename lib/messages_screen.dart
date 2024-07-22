import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatting_app_interview/models/group.dart';
import 'package:flutter_chatting_app_interview/models/message.dart';
import 'package:flutter_chatting_app_interview/models/user.dart';
import 'package:flutter_chatting_app_interview/widgets/message_bubble.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key, required this.group, required this.userId});
  final Group group;
  final int userId;

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final TextEditingController _controller = TextEditingController();
  List<User> users = [];
  bool isLoadingParticpants = true;

  @override
  void initState() {
    getParticipantsData();
    super.initState();
  }

  getParticipantsData() async {
    try {
      final futures = widget.group.participants.map((userId) async {
        final res = await _firebaseFirestore
            .collection('users')
            .where('id', isEqualTo: userId)
            .get();
        return res.docs.map((doc) => User(id: doc['id'], name: doc['name']));
      }).toList();

      final usersList = await Future.wait(futures);
      users = usersList.expand((element) => element).toList();
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() {
        isLoadingParticpants = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.group.name),
      ),
      body: Column(
        children: [
          StreamBuilder(
            stream: _firebaseFirestore
                .collection('groups')
                .doc(widget.group.id.toString())
                .collection('messages')
                .orderBy('sentTime', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData) {
                return const Center(
                  child: Text("No Messages"),
                );
              }
              final data = snapshot.data!.docs;
              if (data.isEmpty) {
                return const Expanded(child: Text("No Message in the group"));
              }
              return Expanded(
                child: !isLoadingParticpants
                    ? ListView.builder(
                        reverse: true,
                        itemCount: data.length,
                        itemBuilder: (context, index) => TextMessagesBubble(
                            user: users.firstWhere(
                              (element) =>
                                  element.id == data[index]['senderId'],
                            ),
                            message: Message(
                                senderId: data[index]['senderId'],
                                sentTime: data[index]['sentTime'].toDate(),
                                messageText: data[index]['messageText']),
                            id: widget.userId),
                      )
                    : const Center(
                        child: CircularProgressIndicator(),
                      ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                    ),
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: "Type a message...",
                        contentPadding: EdgeInsets.all(16),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.primaryContainer),
                  child: IconButton(
                    onPressed: () {
                      if (_controller.text.isEmpty) {
                        return;
                      }
                      sendMessage();
                    },
                    icon: Icon(
                      Icons.send,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  void sendMessage() async {
    try {
      final time = DateTime.now();
      var batch = FirebaseFirestore.instance.batch();

      var conversationDocRef = FirebaseFirestore.instance
          .collection('groups')
          .doc(widget.group.id.toString());

      batch.set(
          conversationDocRef,
          {"lastMessage": _controller.text, "lastMessageTime": time},
          SetOptions(merge: true));

      var messagesCollectionRef =
          conversationDocRef.collection('messages').doc();

      batch.set(
        messagesCollectionRef,
        {
          'senderId': widget.userId,
          'sentTime': time,
          'messageText': _controller.text,
        },
      );

      await batch.commit();
      setState(() {
        _controller.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
