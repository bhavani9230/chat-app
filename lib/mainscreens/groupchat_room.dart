import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:image_picker/image_picker.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:we_chat_app/API/apis.dart';
import 'package:we_chat_app/mainscreens/viewgroupDetails.dart';
import 'package:we_chat_app/models/groupmodell.dart';
import 'package:we_chat_app/models/groupmsgmodel.dart';
import 'package:we_chat_app/models/message_model.dart';
import 'package:we_chat_app/widgets/groupmsg_card.dart';
import 'package:we_chat_app/widgets/message_design.dart';

// class GroupChatScreen extends StatefulWidget {
//   final GroupModel group;
//   const GroupChatScreen({super.key, required this.group});

//   @override
//   State<GroupChatScreen> createState() => _GroupChatScreenState();
// }

// class _GroupChatScreenState extends State<GroupChatScreen> {
//   final ScrollController _scrollController = ScrollController();
//   bool _showScrollUpButton = false;
//   String fToken = '';
//   XFile? imageXFile;
//   File? _pickedImage;
//   Uint8List webImage = Uint8List(8);
  
//   Future<void> _getImage() async {
//   final ImagePicker picker = ImagePicker();
//   imageXFile = await picker.pickImage(source: ImageSource.gallery);

//   if (imageXFile != null) {
//     if(!kIsWeb) {
//       String fileName = DateTime.now().millisecondsSinceEpoch.toString() + '.jpg'; // Unique file name
//     try {
//       // Upload the image to Firebase Storage
//       var storageRef = FirebaseStorage.instance.ref().child('groupimages').child(fileName);
//       await storageRef.putFile(File(imageXFile!.path));
      
//       // Get the download URL
//       String downloadURL = await storageRef.getDownloadURL();
      
//       // Update the profile picture URL in the Firestore user document
//       await APIs.sendGroupMessages(widget.group, downloadURL, GroupMessageType.image);
     
//     } catch (e) {
//       print('Failed to upload image: $e');
//     }}
//     else {
//       var f = await imageXFile!.readAsBytes();
//       setState(() {
//         webImage = f;
//         _pickedImage = File('a'); // Dummy file name
//       });
//        String fileName = DateTime.now().millisecondsSinceEpoch.toString() + '.jpg'; 
//       try {
//         var storageRef = FirebaseStorage.instance.ref().child('groupimages').child(fileName);
//         await storageRef.putData(webImage);
//          String downloadURL = await storageRef.getDownloadURL();

//         await APIs.sendGroupMessages(widget.group, downloadURL, GroupMessageType.image);
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Image sent successfully')),
//         );
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to send image: $e')),
//         );
//       }
//     }
//   } else {
//     print('No image selected');
//   }
// }

//   bool _showEmoji = false;
//   List<GroupMessages> _list = [];
//   TextEditingController _controller = TextEditingController();
//   final ImagePicker _picker = ImagePicker();
//    late bool _allowuser;
//    Future<List<String>>? _userNamesFuture;
//    RefreshController _refreshController = RefreshController(initialRefresh: false);

//   @override
//   void initState() {
//     super.initState();
//     _userNamesFuture = _fetchUserNames();
//     _scrollController.addListener(() {
//       setState(() {
//           _showScrollUpButton = _scrollController.offset > 100.0; 
        
//       });

//     });
//     setState(() {
//       _allowuser = widget.group.allowMessaging ?? true;
     
//     });
//     _listenToGroupChanges();
//   }
//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   Future<List<String>> _fetchUserNames() async {
//     try {
//       final snapshot = await APIs.getGroupInfo(widget.group.id).first;
//       final data = snapshot.docs;
//       final groupModel = GroupModel.fromJson(data.first.data());

//       if (groupModel.members.isEmpty) {
//         return [];
//       }

//       final futures = groupModel.members.map((userId) => APIs.getUsername(userId)).toList();
//       final userNames = await Future.wait(futures);

//       return userNames;
//     } catch (e) {
//       print('Error fetching user names: $e');
//       return [];
//     }
//   }
//   void _listenToGroupChanges() {
//     APIs.getGroupInfo(widget.group.id).listen((snapshot) {
//       final data = snapshot.docs;
//       if (data.isNotEmpty) {
//         final groupModel = GroupModel.fromJson(data.first.data());
//         setState(() {
//           _allowuser  = widget.group.allowMessaging!;
//         });
//       }
//     });
//   }

//   Future<void> _onRefresh() async {
//     _userNamesFuture = _fetchUserNames();
//     setState(() {});
//     _refreshController.refreshCompleted();}
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 2,
//         backgroundColor: Colors.blue,
//         leading:Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: widget.group.profilephoto.isNotEmpty ? CircleAvatar( 
//             radius: 30,backgroundImage: NetworkImage(widget.group.profilephoto),
//           ):
//            Container(
//             width: 15,
//             height: 15,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(20),
//               color: Colors.blue,
//             ),
//             child: Center(
//               child: Text(
//                 widget.group.name[0].toUpperCase(),
//                 style: const TextStyle(color: Colors.white, fontSize: 20),
//               ),
//             ),
//           ),
//         ),
//         title: FutureBuilder<List<String>>(
//           future: _userNamesFuture,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const CircularProgressIndicator();
//             } else if (snapshot.hasError) {
//               return Text('Error: ${snapshot.error}');
//             } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//               return const Text('No members');
//             } else {
//               final names = snapshot.data!;
//               return Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(widget.group.name, style: const TextStyle(color: Colors.white, fontSize: 20),),
//                   Text(names.join(', '), style: const TextStyle(color: Colors.white, fontSize: 20),),
//                 ],
//               );
//             }
//           },
//         ),
//         actions: [
//           IconButton(
//             onPressed: () {
//               Navigator.push(context,MaterialPageRoute(builder: (context)=> ViewDetailsGroup(group: widget.group,)));
//             },
//             icon: const Icon(Icons.more_vert,color: Colors.white,),
//           ),
//         ],
//       ),
//       body:Column( children: [ 
//        Flexible(
//   child: StreamBuilder(
//     stream: APIs.getAllGroupMessages(widget.group.id),
//     builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//       switch (snapshot.connectionState) {
//         case ConnectionState.waiting:
//         case ConnectionState.none:
//           return const Center(child: CircularProgressIndicator());
//         case ConnectionState.active:
//         case ConnectionState.done:
//           if (snapshot.hasData) {
//             final data = snapshot.data?.docs;
//             _list = data?.map((e) => GroupMessages.fromJson(e.data() as Map<String, dynamic>)).toList() ?? [];
            
//             // Sort messages by timestamp
//             _list.sort((a, b) => a.sent.compareTo(b.sent));
            
//             if (_list.isNotEmpty) {
//               return ListView.builder(
//                 physics: const BouncingScrollPhysics(),
//                 itemCount: _list.length,
//                 itemBuilder: (context, index) {
//                   final message = _list[index];
//                   if (message.type == GroupMessageType.system) {
//                     return Center(
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: Colors.grey[100],
//                           borderRadius: BorderRadius.circular(10) 

//                         ),
//                         padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                        
//                         child: Text(
//                           message.msg,
//                           style: const TextStyle(color: Colors.black),
//                         ),
//                       ),
//                     );
//                   } else {
//                     return GroupMessageCard(groupMessage: message);
//                   }
//                 },
//               );
//             } else {
//               return const Center(
//                 child: Text(
//                   "Say Hi",
//                   style: TextStyle(fontSize: 35),
//                 ),
//               );
//             }
//           } else {
//             return const Center(
//               child: Text(
//                 "No messages found",
//                 style: TextStyle(fontSize: 20),
//               ),
//             );
//           }
//       }
//     },
//   ),
// ),

//           APIs.user.uid == widget.group.admin ? keypad(context):_allowuser ? 
//           keypad(context):Text("Admin can only send Messages"),
          
        
   
//           if(_showEmoji)
//         SizedBox(
//           height:MediaQuery.of(context).size.height*0.5,
//           child: EmojiPicker(
//         onEmojiSelected: (category, emoji) {
//           _controller.text += emoji.emoji;
//         },
//         onBackspacePressed: () {
//           _controller
//       ..text = _controller.text.characters.skipLast(1).toString()
//       ..selection = TextSelection.fromPosition(
//         TextPosition(offset: _controller.text.length),
//       );
//         },
//         textEditingController: _controller,
//         config:const Config(
//          emojiViewConfig: EmojiViewConfig(
//       // Try different values if updating Flutter doesn't help
//       emojiSizeMax:28.0,
//         ),
//       )
//         ),
//       )],)
//     );
//   }

//   void _showBottomsheet() {
//     showModalBottomSheet(
//       context: context,
//        builder:(context) {
//         return Container(
//           child:  Row( 
//             children: [ 
//               TextButton(onPressed: (){

//               }, child:const Card( child: Center(child: Text("Choose from Gallery"),),)),
//                TextButton(onPressed: (){

//               }, child:const Card( child: Center(child: Text("Choose from Camera"),),))
//             ],
//           ),
//         );
//        });
//   }
//   Widget keypad(BuildContext context) {
//     return   Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 IconButton(onPressed: (){
//                   setState(() {
//                     _showEmoji = !_showEmoji;
//                   });
//                 }, icon:const Icon(Icons.emoji_emotions)),
//              InkWell(
//                 onTap: () {
//                  _getImage();
//                 },
//                 child:const Icon(Icons.camera_alt)),
//                 Expanded(
//                   child: TextField(
//                     controller: _controller,
//                     decoration:const InputDecoration(
//                       hintText: 'Enter your message...',
//                     ),
//                     onTap:(){
//                       if(_showEmoji)  setState(() {
//                         _showEmoji = !_showEmoji;
//                       });
//                     }
//                   ),
//                 ),
//                 IconButton(
//                   icon:const Icon(Icons.send),
//                   onPressed: () async {
//                     print("Dssss");
//                     try {
//                     if(_controller.text.isNotEmpty) {
//                      await APIs.sendGroupMessages(widget.group, _controller.text, GroupMessageType.text).then((value) => print("something"));
//                       _controller.clear();
                    
//                     }}catch(e){
//                         print(e);
//                     } },
//                 ),
//               ],
//             ),
//           );
//   }
  

  
// }


class GroupChatScreen extends StatefulWidget {
  final GroupModel group;
  const GroupChatScreen({super.key, required this.group});

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showScrollUpButton = false;
  String fToken = '';
  XFile? imageXFile;
  File? _pickedImage;
  Uint8List webImage = Uint8List(8);
  
  Future<void> _getImage() async {
    final ImagePicker picker = ImagePicker();
    imageXFile = await picker.pickImage(source: ImageSource.gallery);

    if (imageXFile != null) {
      if(!kIsWeb) {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString() + '.jpg'; // Unique file name
        try {
          // Upload the image to Firebase Storage
          var storageRef = FirebaseStorage.instance.ref().child('groupimages').child(fileName);
          await storageRef.putFile(File(imageXFile!.path));
          
          // Get the download URL
          String downloadURL = await storageRef.getDownloadURL();
          
          // Send the image message
          await APIs.sendGroupMessages(widget.group, downloadURL, GroupMessageType.image);
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Image sent successfully')),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to send image: $e')),
          );
        }
      } else {
        var f = await imageXFile!.readAsBytes();
        setState(() {
          webImage = f;
          _pickedImage = File('a'); // Dummy file name
        });
        String fileName = DateTime.now().millisecondsSinceEpoch.toString() + '.jpg'; 
        try {
          var storageRef = FirebaseStorage.instance.ref().child('groupimages').child(fileName);
          await storageRef.putData(webImage);
          String downloadURL = await storageRef.getDownloadURL();

          await APIs.sendGroupMessages(widget.group, downloadURL, GroupMessageType.image);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Image sent successfully')),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to send image: $e')),
          );
        }
      }
    } else {
      print('No image selected');
    }
  }

  bool _showEmoji = false;
  List<GroupMessages> _list = [];
  TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();
   bool _allowuser = false;
  Future<List<String>>? _userNamesFuture;
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    _userNamesFuture = _fetchUserNames();
    _scrollController.addListener(() {
      setState(() {
        _showScrollUpButton = _scrollController.offset > 100.0;
      });
    });
    _listenToGroupChanges();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<List<String>> _fetchUserNames() async {
    try {
      final snapshot = await APIs.getGroupInfo(widget.group.id).first;
      final data = snapshot.docs;
      final groupModel = GroupModel.fromJson(data.first.data());

      if (groupModel.members.isEmpty) {
        return [];
      }

      final futures = groupModel.members.map((userId) => APIs.getUsername(userId)).toList();
      final userNames = await Future.wait(futures);

      return userNames;
    } catch (e) {
      print('Error fetching user names: $e');
      return [];
    }
  }

  void _listenToGroupChanges() {
    APIs.getGroupInfo(widget.group.id).listen((snapshot) {
      final data = snapshot.docs;
      if (data.isNotEmpty) {
        final groupModel = GroupModel.fromJson(data.first.data());
        setState(() {
          _allowuser = groupModel.allowMessaging ?? true;
        });
      }
    });
  }

  Future<void> _onRefresh() async {
    _userNamesFuture = _fetchUserNames();
    setState(() {});
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.blue,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: widget.group.profilephoto.isNotEmpty ? CircleAvatar( 
            radius: 30, backgroundImage: NetworkImage(widget.group.profilephoto),
          ) :
          Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.blue,
            ),
            child: Center(
              child: Text(
                widget.group.name[0].toUpperCase(),
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ),
        title:  Text(widget.group.name, style: const TextStyle(color: Colors.white, fontSize: 20),),
        // FutureBuilder<List<String>>(
        //   future: _userNamesFuture,
        //   builder: (context, snapshot) {
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       return const CircularProgressIndicator();
        //     } else if (snapshot.hasError) {
        //       return Text('Error: ${snapshot.error}');
        //     } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        //       return const Text('No members');
        //     } else {
        //       final names = snapshot.data!;
        //       return Column(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           Text(widget.group.name, style: const TextStyle(color: Colors.white, fontSize: 20),),
        //           Text(names.join(', '), style: const TextStyle(color: Colors.white, fontSize: 20),),
        //         ],
        //       );
        //     }
        //   },
        // ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ViewDetailsGroup(group: widget.group)));
            },
            icon: const Icon(Icons.more_vert, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [ 
          Flexible(
            child: StreamBuilder(
              stream: APIs.getAllGroupMessages(widget.group.id),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return const Center(child: CircularProgressIndicator());
                  case ConnectionState.active:
                  case ConnectionState.done:
                    if (snapshot.hasData) {
                      final data = snapshot.data?.docs;
                      _list = data?.map((e) => GroupMessages.fromJson(e.data() as Map<String, dynamic>)).toList() ?? [];
                      
                      // Sort messages by timestamp
                      _list.sort((a, b) => a.sent.compareTo(b.sent));
                      
                      if (_list.isNotEmpty) {
                        return ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: _list.length,
                          itemBuilder: (context, index) {
                            final message = _list[index];
                            if (message.type == GroupMessageType.system) {
                              return Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(10) 
                                  ),
                                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                                  child: Text(
                                    message.msg,
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ),
                              );
                            } else {
                              return GroupMessageCard(groupMessage: message);
                            }
                          },
                        );
                      } else {
                        return const Center(
                          child: Text(
                            "Say Hi",
                            style: TextStyle(fontSize: 35),
                          ),
                        );
                      }
                    } else {
                      return const Center(
                        child: Text(
                          "No messages found",
                          style: TextStyle(fontSize: 20),
                        ),
                      );
                    }
                }
              },
            ),
          ),
          APIs.user.uid == widget.group.admin ? keypad(context) : _allowuser ? 
          keypad(context) : const Text("Admin can only send Messages"),
          if (_showEmoji)
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: EmojiPicker(
                onEmojiSelected: (category, emoji) {
                  _controller.text += emoji.emoji;
                },
                onBackspacePressed: () {
                  _controller
                    ..text = _controller.text.characters.skipLast(1).toString()
                    ..selection = TextSelection.fromPosition(
                      TextPosition(offset: _controller.text.length),
                    );
                },
                textEditingController: _controller,
                config: const Config(
                  emojiViewConfig: EmojiViewConfig(
                    emojiSizeMax: 28.0,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showBottomsheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          child: Row(
            children: [ 
              TextButton(
                onPressed: () {
                  _getImage();
                },
                child: const Card(child: Center(child: Text("Choose from Gallery"),),)
              ),
              TextButton(
                onPressed: () {
                  // Implement functionality for choosing from camera
                },
                child: const Card(child: Center(child: Text("Choose from Camera"),),)
              )
            ],
          ),
        );
      }
    );
  }

  Widget keypad(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                _showEmoji = !_showEmoji;
              });
            },
            icon: const Icon(Icons.emoji_emotions)
          ),
          InkWell(
            onTap: () {
              _getImage();
            },
            child: const Icon(Icons.camera_alt)
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Enter your message...',
              ),
              onTap: () {
                if (_showEmoji) {
                  setState(() {
                    _showEmoji = !_showEmoji;
                  });
                }
              }
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () async {
              if (_controller.text.isNotEmpty) {
                await APIs.sendGroupMessages(widget.group, _controller.text, GroupMessageType.text);
                _controller.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:we_chat_app/API/apis.dart';
// import 'package:we_chat_app/models/groupmsgmodel.dart';
// import 'package:we_chat_app/widgets/groupmsg_card.dart';


// class GroupChatScreen extends StatefulWidget {
//   final String groupId;

//   GroupChatScreen({required this.groupId});

//   @override
//   _GroupChatScreenState createState() => _GroupChatScreenState();
// }

// class _GroupChatScreenState extends State<GroupChatScreen> {
//   List<GroupMessages> _list = [];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Group Chat'),
//       ),
//       body: Column(
//         children: [
//           Flexible(
//             child: StreamBuilder(
//               stream:APIs.getAllGroupMessages(widget.groupId),
//               builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//                 switch (snapshot.connectionState) {
//                   case ConnectionState.waiting:
//                   case ConnectionState.none:
//                     return const Center(child: CircularProgressIndicator());
//                   case ConnectionState.active:
//                   case ConnectionState.done:
//                     if (snapshot.hasData) {
//                       final data = snapshot.data?.docs;
//                       _list = data?.map((e) =>GroupMessages.fromJson(e.data() as Map<String, dynamic>)).toList() ?? [];
//                       if (_list.isNotEmpty) {
//                         return ListView.builder(
//                           physics: const BouncingScrollPhysics(),
//                           itemCount: _list.length,
//                           itemBuilder: (context, index) {
//                             return GroupMessageCard(groupMessage: _list[index]);
//                           },
//                         );
//                       } else {
//                         return const Center(
//                           child: Text(
//                             "Say Hi",
//                             style: TextStyle(fontSize: 35),
//                           ),
//                         );
//                       }
//                     } else {
//                       return const Center(
//                         child: Text(
//                           "No messages found",
//                           style: TextStyle(fontSize: 20),
//                         ),
//                       );
//                     }
//                 }
//               },
//             ),
//           ),
//                   Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 IconButton(onPressed: (){
//                   setState(() {
//                     _showEmoji = !_showEmoji;
//                   });
//                 }, icon:const Icon(Icons.emoji_emotions)),
//              InkWell(
//                 onTap: () {
//                  _getImage();
//                 },
//                 child:const Icon(Icons.camera_alt)),
//                 Expanded(
//                   child: TextField(
//                     controller: _controller,
//                     decoration:const InputDecoration(
//                       hintText: 'Enter your message...',
//                     ),
//                     onTap:(){
//                       if(_showEmoji)  setState(() {
//                         _showEmoji = !_showEmoji;
//                       });
//                     }
//                   ),
//                 ),
//                 IconButton(
//                   icon:const Icon(Icons.send),
//                   onPressed: () async {
//                     print("Dssss");
//                     try {
//                     if(_controller.text.isNotEmpty) {
//                      await APIs.sendGroupMessages(widget.group, _controller.text, GroupMessageType.text).then((value) => print("something"));
//                       _controller.clear();
                    
//                     }}catch(e){
//                         print(e);
//                     } },
//                 ),
//               ],
//             ),
//           ),
//           if(_showEmoji)
//         SizedBox(
//           height:MediaQuery.of(context).size.height*0.5,
//           child: EmojiPicker(
//         onEmojiSelected: (category, emoji) {
//           _controller.text += emoji.emoji;
//         },
//         onBackspacePressed: () {
//           _controller
//       ..text = _controller.text.characters.skipLast(1).toString()
//       ..selection = TextSelection.fromPosition(
//         TextPosition(offset: _controller.text.length),
//       );
//         },
//         textEditingController: _controller,
//         config:const Config(
//          emojiViewConfig: EmojiViewConfig(
//       // Try different values if updating Flutter doesn't help
//       emojiSizeMax:28.0,
//         ),
//       )
//         ),
//       )],)
//     );
//   }
       
   
//   }


