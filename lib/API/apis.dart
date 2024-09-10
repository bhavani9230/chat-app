import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:we_chat_app/models/groupmodell.dart';
import 'package:we_chat_app/models/groupmsgmodel.dart';
import 'package:we_chat_app/models/message_model.dart';
import 'package:we_chat_app/models/usermodel.dart';



class APIs {
   
  static FirebaseAuth auth = FirebaseAuth.instance;

  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  //firebase storage to store files or photos
  static FirebaseStorage storage = FirebaseStorage.instance;

  
  static User get user => FirebaseAuth.instance.currentUser!;
   

   static  ChatUser? me ;
  //  =  ChatUser(
  //   about:firestore.collection('users').doc(user.uid).get().about, 
  //   createdAt:"", email:"", id: "", 
  //   image:"", isonline:false,
  //    lastActive:"", name:"", pushToken:"");
  

  //for checking if user exists or not ?
  static Future<bool> userExists() async {
   return (await firestore.collection('users').
   doc(user.uid)
   .get()).exists;
  }

  // static Future<void> getSelfInfo() async {
  //   await firestore.collection('users').doc(user.uid).get().then((user) {
  //     if(user.exists) {
  //       me = ChatUser.fromJson(user.data()!);

  //      print(user.data());
  //     }
  //     else {
  //       createUser(name: me.name ?? "", email: me.email ?? "").then((value) => getSelfInfo());
  //     }

  //   }) ;
  // }

  static Future<ChatUser?> getUserDetailsByUid(String uid) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (userDoc.exists) {
      return ChatUser.fromJson(userDoc.data() as Map<String, dynamic>);
    } else {
      return null;
    }}

static Future<void> getSelfInfo() async {
  
  final userSnapshot = await firestore.collection('users').doc(user.uid).get();

  if (userSnapshot.exists) {
    me = ChatUser.fromJson(userSnapshot.data()!);
    print(userSnapshot.data());
  } else {
    createUser(name: user.displayName ?? "", email: user.email ?? "").then((_) => getSelfInfo());
  }
}
  //for creating a new user 
   static Future<void> createUser({required String name, required String email}) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
     
    final chatuser = ChatUser(about:"Hey i'm using wechat", 
    createdAt:time, 
    email:email,
    // email,
     id:user.uid , 
    image:user.photoURL.toString(),
     isonline: false, 
     lastActive: time,
      name:name,
      pushToken:'',
      isBlocked: false);
   return await firestore.collection('users').doc(user.uid)
   .set(chatuser.toJson());
  }

   //for creating a new user 
   static Future<void> createGroup({required String name,
    required List<String> members, required String admin, String? profilephoto}) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    
     
    final groupmodel = GroupModel(
      about:"We are group", 
      id:firestore.collection('groups').doc().id , 
      name: name, 
      profilephoto: profilephoto ?? "", 
      admin: admin,
      members:members,
      allowMessaging: false
      );
   return await firestore.collection('groups').doc(groupmodel.id)
   .set(groupmodel.toJson());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore.collection('users')
    .where('id', isNotEqualTo: user.uid)
    .snapshots();
  }


 static Stream<QuerySnapshot<Map<String, dynamic>>> getAllGroups() {
    if (user == null) return const Stream.empty();

    // Query Firestore for groups where the current user is a member
    return  firestore
 .collection('groups')
 .where('members', arrayContains: user.uid)
 .snapshots();


    
    
    // firestore
    //     .collection('groups').where('id',isEqualTo: user!.uid).snapshots();
        
        
  }
  //update profile picture of user future usage still im not implementing
 static Future<void> updateUserInfo({required String name, required String about}) async {
  try {
    // Update the user document in Firestore
    await firestore.collection('users').doc(user.uid).update({
      'name': name,
      'about': about,
    });
    print('User info updated successfully.');
  } catch (e) {
    // Handle errors (e.g., network issues, Firestore errors)
    print('Error updating user info: $e');
    // You can also rethrow the error if you want to handle it further up the call stack
    // rethrow;
  }
}

static Future<void> updateGroupName({
    required String groupId,
    required String newName,
  }) async {
    try {
      // Update the group document in Firestore
      await firestore.collection('groups').doc(groupId).update({
        'name': newName,
      });
      print('Group name updated successfully.');
    } catch (e) {
      // Handle errors (e.g., network issues, Firestore errors)
      print('Error updating group name: $e');
      // You can also rethrow the error if you want to handle it further up the call stack
      // rethrow;
    }
  }


  //storage file ref with path for future usage still im not implementing 
  // static Future<void> updateProfilePicture(File file) async {
  //   final ext = file.path.split('.').last;
  //   // storage file ref with path 
  //   final ref = storage.ref().child('profile_picture/${user.uid}.$ext');
  //   //upload image 
  //   await ref.putFile(file,SettableMetadata(contentType: 'image/$ext')).then((p0) {
  //     print('Data Transfferred: ${p0.bytesTransferred/1000} kb');
  //   });
  //   me!.image = await ref.getDownloadURL();
  //   await firestore.collection('users').doc(user.uid).update({'image':me!.image});

  // }

  static Future<void> updateProfilePicture(String imageUrl) async {
    try {
      // Assuming the user is already authenticated and you have the user ID
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Update the user's profile picture URL in Firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'image': imageUrl,
      });
    } catch (e) {
      print('Failed to update profile picture: $e');
    }
  }
     static Stream<QuerySnapshot> messagesStream(ChatUser user) {
    return firestore
        .collection('messages')
        .doc(user.id)
        .collection('chats')
        .snapshots();
  
  }

  
  
  
  static String getConversationId(String id) => user.uid.hashCode <= id.hashCode ? 
  '${user.uid}_$id': '${id}_${user.uid}';

 static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(ChatUser chatuser) {
    return firestore.collection('chats/${getConversationId(chatuser.id)}/messages/').snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getMyUsers(ChatUser chatuser) {
    
    return firestore.collection('users').doc(user.uid).collection('my_users').snapshots();
  }

  // static Future<void> sendMessages(ChatUser chatuser, String msg, Type type) async {
  //   final time = DateTime.now().microsecondsSinceEpoch.toString();
  //   final Messages message = Messages(
  //     fromId: user.uid, 
  //     toId: chatuser.id, 
  //     msg: msg, 
  //     sent: time, 
  //     read: '', 
  //     type: _typeToString(type),
  //   );

  //   try {
  //     final ref = firestore.collection('chats/${getConversationId(chatuser.id)}/messages');
  //     await ref.doc(time).set(message.toJson());
  //     print('Message sent successfully: ${message.toJson()}');
  //   } catch (e) {
  //     print('Failed to send message: $e');
  //   }
  // }

  // static _typeToString(Type type) {
  //   return type.toString().split('.').last;
  // }

  static Future<void> sendMessages(ChatUser chatuser, String msg, MessageType type) async {
  final time = DateTime.now().microsecondsSinceEpoch.toString();
  final Messages message = Messages(
    fromId: user.uid,
    toId: chatuser.id,
    msg: msg,
    sent: time,
    read: '',
    type: type  // Convert enum to string
  );
 try {
    final ref = firestore.collection('chats/${getConversationId(chatuser.id)}/messages');
    await ref.doc(time).set(message.toJson());
    print('Message sent successfully: ${message.toJson()}');
  } catch (e) {
    print('Failed to send message: $e');
  }
}
static String getGroupConversationId(String groupId) => 'group_$groupId';




  //  static Future<void> updateMessageReadStatus(Messages message) async  { my code
  //   firestore.collection('chat/${getConversationId(message.fromId)}/messages').doc(message.sent)
  //   .update({'read':DateTime.now().microsecondsSinceEpoch.toString()});
  // }
 static Future<void> updateMessageReadStatus(Messages message) async {
    try {
      String conversationId = getConversationId(message.fromId);
      String documentId = message.sent.toString(); // Ensure `message.sent` is a string

      DocumentReference docRef = firestore.collection('chats/$conversationId/messages').doc(documentId);

      // Log the document reference path for debugging
      print("Document Reference Path: ${docRef.path}");

      DocumentSnapshot docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        await docRef.update({'read': DateTime.now().microsecondsSinceEpoch.toString()});
        print("Message read status updated successfully.");
      } else {
        print("No document to update: $documentId");
      }
    } catch (e) {
      print("Error updating message read status: $e");
    }
  }

  //get only last msg
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessages(ChatUser user)  {
     return firestore.collection('chats/${getConversationId(user.id)}/messages/')
     .orderBy('sent', descending: true)
     .limit(1).snapshots();
  }
//  //send chat image
//  static Future<void> sendChatImage(ChatUser chatuser, File file) async { // my code
//   final ext = file.path.split('.').last;
//     // storage file ref with path 
//     final ref = storage.ref().child('images/${getConversationId(chatuser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');
//     //upload image 
//     await ref.putFile(file,SettableMetadata(contentType: 'image/$ext')).then((p0) {
//       print('Data Transfferred: ${p0.bytesTransferred/1000} kb');
//     });
//     final imageUrl = await ref.getDownloadURL();
//     await sendMessages(chatuser, imageUrl, MessageType.image);


// static Future<void> sendChatImage(ChatUser chatUser, File file) async {//chat code
//     try {
//       final ext = file.path.split('.').last;
//       // Storage file ref with path
//       final ref = storage.ref().child('images/${getConversationId(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');
//       // Upload image
//       await ref.putFile(file, SettableMetadata(contentType: 'image/$ext')).then((p0) {
//         print('Data Transferred: ${p0.bytesTransferred / 1000} kb');
//       });
//       final imageUrl = await ref.getDownloadURL();
//       await sendMessages(chatUser, imageUrl, MessageType.image);
//     } catch (e) {
//       print('Error sending chat image: $e');
//       throw Exception('Error sending chat image: $e');
//     }
//   }

static Future<void> sendChatImage(ChatUser chatUser, XFile file) async {
  try {
    final ext = file.name.split('.').last;
    // Storage file ref with path
    final ref = storage.ref().child('images/${getConversationId(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');
    // Upload image
    await ref.putFile(File(file.path), SettableMetadata(contentType: 'image/$ext')).then((p0) {
      print('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });
    final imageUrl = await ref.getDownloadURL();
    await sendMessages(chatUser, imageUrl, MessageType.image);
  } catch (e) {
    print('Error sending chat image: $e');
    throw Exception('Error sending chat image: $e');
  }
}

//online or last seen detects
static Stream<QuerySnapshot<Map<String, dynamic>>> getUserInfo (ChatUser chatuser)  {
  
     return firestore.collection('users').where('id', isEqualTo: chatuser.id).snapshots();
  }
 
 static Future<void> updateActiveStatus(bool isOnline) async {
  try {
    await firestore.collection('users').doc(user.uid).update({
      "isonline": isOnline,
      'last_active': DateTime.now().millisecondsSinceEpoch.toString(),
    });
  } catch (e) {
    print("Error updating active status: $e");
 }


 }

 static Future<bool> addChatUser(String email) async {
  final data = await firestore.collection('users').where('email',isEqualTo: email).get();
  print('data:${data.docs}');
  if(data.docs.isNotEmpty && data.docs.first.id != user.uid) {
    print("${data.docs.first.data()}");
   firestore.collection('users').doc(user.uid).collection('my_users').doc(data.docs.first.id).set({});
    return true;

  }else {
    return false;
  }

}
static Stream<QuerySnapshot> getAllMessagesStream() {
  final user = FirebaseAuth.instance.currentUser!;
  return APIs.firestore.collection('messages')
    .where('participants', arrayContains: user.uid)
    .snapshots();
}

static Future<void> deleteMessage(Messages message) async {
  try {
    await firestore
        .collection('chats/${getConversationId(message.toId)}/messages/')
        .doc(message.sent)
        .delete();
    if (message.type == MessageType.image) {
      await storage.refFromURL(message.msg).delete();
    }
  } catch (e) {
    print('Error deleting message: $e');
  }
}
static Future<void> UpdateMessage(Messages message, String updateMsg) async {
  print('Updating message with ID: ${message.sent}');
  print('New message content: $updateMsg');
  
  await firestore
      .collection('chats/${getConversationId(message.toId)}/messages/')
      .doc(message.sent)
      .update({'msg': updateMsg})
      .then((_) => print('Message updated successfully'))
      .catchError((error) => print('Failed to update message: $error'));
}

 static Future<void> sendGroupMessages(GroupModel group, String msg, GroupMessageType type) async {
  final time = DateTime.now().microsecondsSinceEpoch.toString();
  final GroupMessages message = GroupMessages(
    fromId: user.uid,
    toId: group.id,
    msg: msg,
    sent: time,
    read: [],
    type: type
  );

  try {
    final ref = firestore.collection('groups/${group.id}/messages');
    await ref.doc(time).set(message.toJson());
    print('Message sent successfully: ${message.toJson()}');
  } catch (e) {
    print('Failed to send message: $e');
  }
}
static Stream<QuerySnapshot<Map<String, dynamic>>> getAllGroupMessages(String groupId) {
  return firestore.collection('groups').doc(groupId).collection('messages').snapshots();
}

static Future<void> deleteGroupMessage(GroupMessages message) async {
  try {
    await firestore
        .collection('groups/${message.toId}/messages')
        .doc(message.sent)
        .delete();
    if (message.type == MessageType.image) {
      await storage.refFromURL(message.msg).delete();
    }
  } catch (e) {
    print('Error deleting message: $e');
  }
}
static Future<void> updateGroupMessage(GroupMessages message, String updateMsg) async {
  try {
    await firestore
        .collection('groups/${message.toId}/messages')
        .doc(message.sent)
        .update({'msg': updateMsg});
    print('Message updated successfully');
  } catch (e) {
    print('Failed to update message: $e');
  }
}
static Stream<QuerySnapshot<Map<String, dynamic>>> getGroupInfo(String groupId) {
  return firestore.collection('groups').where('id', isEqualTo: groupId).snapshots();
}

 static Future<void> updateGroupMessageReadStatus(GroupMessages message) async {
    try {
      String currentUserId = FirebaseAuth.instance.currentUser!.uid;
      String groupId = message.toId;
      String documentId = message.sent; // Ensure `message.sent` is a string

      DocumentReference docRef = firestore.collection('groups/$groupId/messages').doc(documentId);

      // Log the document reference path for debugging
      print("Document Reference Path: ${docRef.path}");

      DocumentSnapshot docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        List<String> readList = List<String>.from(docSnapshot['read'] ?? []);
        if (!readList.contains(currentUserId)) {
          readList.add(currentUserId);
          await docRef.update({'read': readList});
          print("Message read status updated successfully for user $currentUserId.");
        } else {
          print("User $currentUserId has already read the message.");
        }
      } else {
        print("No document to update: $documentId");
      }
    } catch (e) {
      print("Error updating group message read status: $e");
    }
  }
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastGroupMessage(String groupId) {
  return firestore.collection('groups/$groupId/messages')
    .orderBy('sent', descending: true)
    .limit(1)
    .snapshots();
}
static Future<ChatUser> getUserById(String userId) async {
    final userSnapshot = await firestore.collection('users').doc(userId).get();
    if (userSnapshot.exists) {
      return ChatUser.fromJson(userSnapshot.data()!);
    } else {
      throw Exception('User not found');
    }
  }
static Future<String> getUsername(String userId) async {
    DocumentSnapshot userDoc = await firestore.collection('users').doc(userId).get();
    return userDoc['name'];
  }
  static Future<void> removeUserFromGroup(String groupId, String userId, String username) async {
    try {
      // Reference to the group document
      DocumentReference groupRef = firestore.collection('groups').doc(groupId);

      // Update the members array in the group document
      await groupRef.update({
        'members': FieldValue.arrayRemove([userId])
      });
      await sendSystemMessage(groupId, '$username has been removed from the group');

      print('User removed successfully from the group');
    } catch (e) {
      print('Error removing user from group: $e');
      // Handle the error as needed
    }

}
static Future<void> deleteGroup(String groupId) async {
    try {
      // Get the Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Reference to the group document
      DocumentReference groupDoc = firestore.collection('groups').doc(groupId);

      // Deleting all messages related to the group
      QuerySnapshot messagesSnapshot = await groupDoc.collection('messages').get();
      for (QueryDocumentSnapshot doc in messagesSnapshot.docs) {
        await doc.reference.delete();
      }

      // Deleting the group document itself
      await groupDoc.delete();

      print('Group and its related data deleted successfully');
    } catch (e) {
      print('Failed to delete group: $e');
      throw e; // Rethrow the error so it can be caught and handled in the calling function
    }
  }
 static Future<void> updateProfilePictureGroup(String imageUrl, String groupId) async {
    try {
      // Assuming the user is already authenticated and you have the user ID
      // String userId = FirebaseAuth.instance.currentUser!.uid;

      // Update the user's profile picture URL in Firestore
      await FirebaseFirestore.instance.collection('groups').doc(groupId).update({
        'profilephoto': imageUrl,
      });
    } catch (e) {
      print('Failed to update profile picture: $e');
    }
  }
  static Future<void> deleteProfilePhotoGroup(String imageUrl, {String? groupId}) async {
  try {
    // Extract the reference from the image URL (if applicable)
    final reference = FirebaseStorage.instance.refFromURL(imageUrl);

    // Conditional deletion based on groupId
    if (groupId != null) {
      // Delete the profile photo from the specific group storage location
      await reference.delete(); // Assuming Firebase Storage references specific to groups
    } 
    print('Profile photo deleted successfully!');
  } catch (error) {
    print('Failed to delete profile photo: $error');
    // Handle potential errors gracefully (e.g., retry logic, user feedback)
  }
}
static Future<void> updateGroupMessagingStatus(String groupId, bool allowMessaging) async {
    try {
      await firestore.collection('groups').doc(groupId).update({
        'allowMessaging': allowMessaging,
      });
    } catch (e) {
      print('Failed to update messaging status: $e');
      throw e;
    }
  }

   static Future<void> sendSystemMessage(String groupId, String message) async {
    final systemMessage = GroupMessages(
      fromId:'system',
    toId:groupId,
    msg: message,
    sent: DateTime.now().millisecondsSinceEpoch.toString(),
    read: [],
    type:  GroupMessageType.system,
     
    );
    await FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .collection('messages')
        .add(systemMessage.toJson());
  }
  static Future<void> changeGroupAdmin(String groupId, String newAdminId) async {
    try {
      await firestore.collection('groups').doc(groupId).update({
        'admin': newAdminId,
      });
    } catch (e) {
      print("Error changing admin: $e");
    }
  }
 static Stream<QuerySnapshot> getAllUsersAndGroupsStream() {
    return FirebaseFirestore.instance.collection('users').snapshots();
  }

static Future<List<GroupModel>> _getAllGroups() async {
  final groupSnapshots = await FirebaseFirestore.instance
      .collection('groups')
      .get();
  return groupSnapshots.docs
      .map((doc) => GroupModel.fromJson(doc.data()))
      .toList();
}
static Future<void> toggleBlockStatus(String userId, bool isBlocked) async {
    try {
      await firestore.collection('users').doc(userId).update({
        'isBlocked': isBlocked,
      });
    } catch (e) {
      print('Error updating block status: $e');
    }
  }

}