import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chatting_app_interview/chats_screen.dart';
import 'package:flutter_chatting_app_interview/models/group.dart';

class EnteryScreen extends StatefulWidget {
  const EnteryScreen({super.key});

  @override
  State<EnteryScreen> createState() => _EnteryScreenState();
}

class _EnteryScreenState extends State<EnteryScreen> {
  final TextEditingController _controller = TextEditingController();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Welcome to Chat App',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 50),
              TextFormField(
                controller: _controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter your ID',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  try {
                    log("Hello");
                    final id = int.tryParse(_controller.text);
                    if (id == null) {
                      throw Exception('ID must be a number');
                    }
                    final response = await _firebaseFirestore
                        .collection('groups')
                        .where("participants", arrayContains: id)
                        .get();
                    final groups = response.docs.map((e) {
                      print(e['participants']);
                      return Group(
                        id: e['id'],
                        name: e['name'],
                        lastMessage: '',
                        participants: (e['participants'] as List)
                            .map((item) => item as int)
                            .toList(),
                      );
                    }).toList();
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ChatsScreen(
                        groups: groups,
                        userId: id,
                      ),
                    ));
                  } catch (e) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(e.toString())));
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text("Enter Chat"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
