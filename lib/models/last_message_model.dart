import 'package:stegmessage/constants.dart';

class LastMessageModel {
  final String senderUID;
  final String contactUID;
  final String contactName;
  final String contactImage;
  final String message;
  final MESSAGEENUM messageType;
  final DateTime timeSent;
  final bool isSeen;

  LastMessageModel({
    required this.senderUID,
    required this.contactUID,
    required this.contactName,
    required this.contactImage,
    required this.messageType,
    required this.message,
    required this.timeSent,
    required this.isSeen,
  });

  // to map
  Map<String, dynamic> toMap() {
    return {
      Constants.senderUID: senderUID,
      Constants.contactUID: contactUID,
      Constants.contactName: contactName,
      Constants.contactImage: contactImage,
      Constants.messageType: messageType.index,
      Constants.message: message,
      Constants.timeSent: timeSent.microsecondsSinceEpoch,
      Constants.isSeen: isSeen,
    };
  }

  // from map
  factory LastMessageModel.fromMap(Map<String, dynamic> map) {
    return LastMessageModel(
      senderUID: map[Constants.senderUID] ?? '',
      contactUID: map[Constants.contactUID],
      contactName: map[Constants.contactName],
      contactImage: map[Constants.contactImage],
      message: map[Constants.message] ?? '',
      messageType: map[Constants.messageType].toString().toMessageEnum(),
      timeSent: DateTime.fromMicrosecondsSinceEpoch(
        map[Constants.timeSent],
      ),
      isSeen: map[Constants.isSeen] ?? false,
    );
  }

  copyWith({
    required String contactUID,
    required String contactName,
    required String contactImage,
  }) {
    return LastMessageModel(
      senderUID: senderUID,
      contactUID: contactUID,
      contactName: contactName,
      contactImage: contactImage,
      messageType: messageType,
      message: message,
      timeSent: timeSent,
      isSeen: isSeen,
    );
  }
}
