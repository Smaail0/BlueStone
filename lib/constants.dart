class Constants {
// screen's routs
  static const String landingScreen = '/landingScreen';
  static const String loginScreen = '/loginScreen';
  static const String otpScreen = '/otpScreen';
  static const String homeScreen = '/homeScreen';
  static const String chatScreen = '/chatScreen';
  static const String profileScreen = '/profileScreen';
  static const String editProfileScreen = '/editProfileScreen';
  static const String searchScreen = '/searchScreen';
  static const String friendsScreen = '/friendsScreen';
  static const String friendRequestScreen = '/friendRequestScreen';
  static const String settingsScreen = '/settingsScreen';
  static const String aboutAppScreen = '/aboutAppScreen';
  static const String termsAndConditionsScreen = '/termsAndConditionsScreen';
  static const String privacyPolicyScreen = '/privacyPolicyScreen';
  static const String userInformationScreen = '/userInformationScreen';

  static const String uid = 'uid';
  static const String image = 'image';
  static const String name = 'name';
  static const String phoneNumber = 'phoneNumber';
  static const String token = 'token';
  static const String status = 'status';
  static const String aboutMe = 'aboutMe';
  static const String lastSeen = 'lastSeen';
  static const String createdAt = 'createdAt';
  static const String isOnline = 'isOnline';
  static const String friendsUIDs = 'friendsUIDs';
  static const String friendRequestsUIDs = 'friendRequestsUIDs';
  static const String sentFriendRequestsUIDs = 'sentFriendRequestsUIDs';

  static const String verificationId = 'verificationId';
  static const String users = 'users';
  static const String userImages = 'userImages';

  static const String userModel = 'userModel';

  static const String contactUID = 'contactUID';
  static const String contactName = 'contactName';
  static const String contactImage = 'contactImage';
  static const String groupID = 'groupID';
  static const String groups = 'groups';

  static const String senderUID = 'senderUID';
  static const String senderName = 'senderName';
  static const String senderImage = 'senderImage';
  static const String message = 'message';
  static const String messageType = 'messageType';
  static const String timeSent = 'timeSent';
  static const String messageUID = 'messageUID';
  static const String isSeen = 'isSeen';
  static const String repliedMessage = 'repliedMessage';
  static const String repliedTo = 'repliedTo';
  static const String repliedMessageType = 'repliedMessageType';
  static const String isMe = 'isMe';

  static const String lastMessage = 'lastMessage';
  static const String chats = 'chats';
  static const String messages = 'messages';

  static const String addresss = 'address';
  static const String entryDate = 'entryDate';
  static const String maintenanceDate = 'maintenanceDate';
  static const String lastMaintenanceDate = 'lastMaintenanceDate';
  static const String voltage = 'voltage';
  static const String current = 'current';
  static const String power = 'power';
  static const String latitude = 'latitude';
  static const String longitude = 'longitude';

  static const String stations = 'stations';
  static const String stationID = 'stationID';
}

enum FRIENDVIEWTYPE {
  friends,
  friendRequests,
  groupView,
}

enum MESSAGEENUM {
  text,
  image,
  audio,
  video,
}

// extension convertMessageEnumToString on string
extension MESSAGEENUMEXTENSION on String {
  MESSAGEENUM toMessageEnum() {
    switch (this) {
      case 'text':
        return MESSAGEENUM.text;
      case 'image':
        return MESSAGEENUM.image;
      case 'audio':
        return MESSAGEENUM.audio;
      case 'video':
        return MESSAGEENUM.video;
      default:
        return MESSAGEENUM.text;
    }
  }
}
