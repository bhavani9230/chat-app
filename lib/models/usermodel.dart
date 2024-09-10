import 'package:cloud_firestore/cloud_firestore.dart';

class ChatUser {
  ChatUser({
    required this.about,
    required this.createdAt,
    required this.email,
    required this.id,
    required this.image,
    required this.isonline,
    required this.lastActive,
    required this.name,
    required this.pushToken,
    required this.isBlocked

    // required this.lastMessageTimestamp,
  });
  late  String about;
  late String createdAt;
  late String email;
  late String id;
  late String image;
  late  bool isonline;
  late  String lastActive;
  late  String name;
  late String pushToken;
  late bool isBlocked;
  // late Timestamp? lastMessageTimestamp,
  
  ChatUser.fromJson(Map<String, dynamic> json){
    about = json['about']?? "";
    createdAt = json['created_at']?? "";
    email = json['email'] ?? "";
    id = json['id'] ?? "";
    image = json['image'] ?? "";
    isonline = json['isonline'] ?? "";
    lastActive = json['last_active'] ?? "";
    name = json['name']?? "";
    pushToken = json['push_token']??"";
    isBlocked = json['isBlocked'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['about'] = about;
    data['created_at'] = createdAt;
    data['email'] = email;
    data['id'] = id;
    data['image'] = image;
    data['isonline'] = isonline;
    data['last_active'] = lastActive;
    data['name'] = name;
    data['push_token'] = pushToken;
    data['isBlocked,'] = isBlocked;
    return data;
  }
}