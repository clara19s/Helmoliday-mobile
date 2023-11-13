import 'dart:io';

import 'package:flutter/material.dart';
import 'package:helmoliday/service/messaging_service.dart';
import 'package:helmoliday/theme.dart';
import 'package:helmoliday/util/date_util.dart';
import 'package:image_picker/image_picker.dart';

class MessageWidget extends StatelessWidget {
  final Message message;

  final String currentUserId;

  const MessageWidget({super.key, required this.message, required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    final isSender = message.from.id == currentUserId;
    final msgData = message.data;
    final images = msgData.images ?? msgData.localImages;
    final hasText = msgData.text != null && msgData.text!.isNotEmpty;
    final hasImages = images != null && images.isNotEmpty;

    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!isSender)
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(
                      'https://picsum.photos/seed/${message.from.id}/200'),
                ),
              ),
            Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                color:
                    isSender ? HelmolidayTheme.primaryColor : Colors.grey.shade200,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(8),
                  topRight: const Radius.circular(8),
                  bottomLeft: isSender ? const Radius.circular(8) : Radius.zero,
                  bottomRight: isSender ? Radius.zero : const Radius.circular(8),
                ),
              ),
              child:
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                if (hasText)
                  Text(
                    msgData.text!,
                    style: TextStyle(
                      color: isSender ? Colors.white : Colors.black,
                    ),
                  ),
                if (hasImages && hasText) const SizedBox(height: 8),
                if (hasImages)
                  GridView.count(
                      crossAxisCount: images.length > 1 ? 2 : 1,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: images
                          .map<Widget>((e) => ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: e is XFile
                                    ? Image.file(
                                        File(e.path),
                                        fit: BoxFit.cover,
                                      )
                                    : Image.network('$e', fit: BoxFit.cover),
                              ))
                          .toList()),
                    const SizedBox(height: 8),
                    _getStatus(message, isSender, context)
              ]),
            ),
            if (isSender)
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: CircleAvatar(
                  radius: 16,
                  backgroundImage: NetworkImage(
                      'https://picsum.photos/seed/${message.from.id}/200'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _getStatus(Message message, bool isSender, BuildContext context) {
    switch (message.status) {
      case MessageStatus.sending:
        return SizedBox.square(
          dimension: 10,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: isSender ? Colors.white : Colors.black,
          ),
        );
      case MessageStatus.sent:
        return Row(
          children: [
            if (isSender)
              const Icon(
                Icons.done_all,
                size: 10,
                color: Colors.white,
              ),
            if (isSender) const SizedBox(width: 10),
            Text(
              DateUtility.toFormattedString(message.sentAt),
              style: TextStyle(
                color: isSender ? Colors.white : Colors.black,
                fontSize: 10,
              ),
            )
          ],
        );
      case MessageStatus.failed:
        return const Icon(
          Icons.error_outline,
          size: 10,
          color: Colors.redAccent,
        );
    }
  }
}