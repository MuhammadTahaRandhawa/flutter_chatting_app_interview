import 'package:flutter/material.dart';
import 'package:flutter_chatting_app_interview/helpers/chat_helper.dart';
import 'package:flutter_chatting_app_interview/models/message.dart';
import 'package:flutter_chatting_app_interview/models/user.dart';

class TextMessagesBubble extends StatelessWidget {
  final Message message;
  final int id;
  final User user;

  const TextMessagesBubble(
      {super.key, required this.message, required this.id, required this.user});

  @override
  Widget build(BuildContext context) {
    return message.senderId == id
        ? _buildSenderBubble(context)
        : _buildReceiverBubble(context);
  }

  Widget _buildSenderBubble(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
                textAlign: TextAlign.left,
                message.messageText,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer)),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(ChatHelpers.convertChatDateTimeToString(message.sentTime),
                    textAlign: TextAlign.right,
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        color:
                            Theme.of(context).colorScheme.onPrimaryContainer)),
                const SizedBox(
                  width: 4,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiverBubble(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                textAlign: TextAlign.left,
                user.name,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                    fontWeight: FontWeight.bold)),
            Text(
                textAlign: TextAlign.left,
                message.messageText,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSecondaryContainer)),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(ChatHelpers.convertChatDateTimeToString(message.sentTime),
                    textAlign: TextAlign.right,
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        color:
                            Theme.of(context).colorScheme.onPrimaryContainer)),
                const SizedBox(
                  width: 4,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
