import 'package:stegmessage/constants.dart';

class MessageReplyModel {
  final String message;
  final String senderName;
  final String senderImage;
  final String senderUID;
  final MESSAGEENUM messageType;
  final bool isMe;

  MessageReplyModel({
    required this.message,
    required this.senderName,
    required this.senderImage,
    required this.senderUID,
    required this.messageType,
    required this.isMe,
  });

  // to map
  Map<String, dynamic> toMap() {
    return {
      Constants.message: message,
      Constants.senderName: senderName,
      Constants.senderImage: senderImage,
      Constants.senderUID: senderUID,
      Constants.messageType: messageType.index,
      Constants.isMe: isMe,
    };
  }

  // from map
  factory MessageReplyModel.fromMap(Map<String, dynamic> map) {
    return MessageReplyModel(
      message: map[Constants.message] ?? '',
      senderName: map[Constants.senderName] ?? '',
      senderImage: map[Constants.senderImage] ?? '',
      senderUID: map[Constants.senderUID] ?? '',
      messageType: map[Constants.messageType].toString().toMessageEnum(),
      isMe: map[Constants.isMe] ?? false,
    );
  }
}
