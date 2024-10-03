import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stegmessage/models/message_model.dart';
import 'package:stegmessage/utilities/global_methods.dart';

class MyMessageWidget extends StatelessWidget {
  final MessageModel message;
  final bool isMe;
  final bool showImage;
  final bool isPreviousMessageFromSameSender;
  final String viewerImageUrl;
  final bool isLastMessage;
  final bool isSeen;

  const MyMessageWidget({
    super.key,
    required this.message,
    required this.isMe,
    required this.isSeen,
    required this.showImage,
    required this.isLastMessage,
    required this.isPreviousMessageFromSameSender,
    required this.viewerImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!isMe)
          if (showImage)
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
                left: 8.0,
              ),
              child: userImageWidget(
                imageUrl: message.senderImage,
                radius: 15,
                onTap: () {},
              ),
            )
          else
            const SizedBox(
              width: 35,
            ),
        Flexible(
          child: Container(
            margin: const EdgeInsets.symmetric(
              vertical: 3,
              horizontal: 10,
            ),
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, left: 14, right: 14),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 1),
                ),
              ],
              color:
                  isMe ? Colors.blue : const Color.fromARGB(255, 242, 242, 242),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  message.message,
                  style: GoogleFonts.openSans(
                    fontWeight: FontWeight.w500,
                    color: isMe
                        ? Theme.of(context).cardColor
                        : const Color.fromARGB(255, 35, 35, 35),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
        ),
        if (isMe && isLastMessage)
          Padding(
            padding: const EdgeInsets.only(right: 8.0, top: 30.0),
            child: userImageWidget(
              imageUrl: viewerImageUrl,
              radius: 8,
              onTap: () {},
            ),
          ),
      ],
    );
  }
}
