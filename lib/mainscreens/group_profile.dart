// import 'dart:io';
// import 'dart:typed_data';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:we_chat_app/API/apis.dart';
// import 'package:we_chat_app/mainscreens/chat_members.dart';


// class GroupDetails extends StatefulWidget {
//   final List<String> groupList;
//   const GroupDetails({super.key, required this.groupList});
//   @override
//   State<GroupDetails> createState() => _GroupDetailsState();
// }

// class _GroupDetailsState extends State<GroupDetails> {
//   TextEditingController groupNameController = TextEditingController();

//     String fToken = '';
//   XFile? imageXFile;
//   File? _pickedImage;
//   Uint8List webImage = Uint8List(8);
  
//   Future<void> _getImage() async {
//   final ImagePicker picker = ImagePicker();
//   imageXFile = await picker.pickImage(source: ImageSource.gallery);

//   if (imageXFile != null) {
//     if (!kIsWeb) {
//       var selected = File(imageXFile!.path);
//       setState(() {
//         _pickedImage = selected;
//       });

//       try {
//         // await APIs.sendChatImage(widget.user, imageXFile!);
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Image uploaded successfully')),
//         );
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to send image: $e')),
//         );
//       }

//     } else {
//       var f = await imageXFile!.readAsBytes();
//       setState(() {
//         webImage = f;
//         _pickedImage = File('a'); // Dummy file name
//       });

//       try {
        
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

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar( 
//         title: Text("Group Title"),
//         backgroundColor: Colors.blue,
//         foregroundColor: Colors.white,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column( 
//         crossAxisAlignment: CrossAxisAlignment.center,
//           children: [ 
//             InkWell(
//                   onTap: () {
//                     _getImage();
//                   },
//                   child: kIsWeb
//                       ? CircleAvatar(
//                           radius: kIsWeb
//                               ? 70
//                               : MediaQuery.of(context).size.width * 0.20,
//                           backgroundColor: Colors.grey,
//                           backgroundImage: MemoryImage(
//                               webImage), // Assuming `webImage` is a Uint8List
        
//                           child: imageXFile == null
//                               ? Container( 
//                                 height: 100,
//                                 width: 100,
//                                 decoration: BoxDecoration( 
//                                   color: Colors.blue,
//                                   borderRadius: BorderRadius.circular(50)
//                                 ),
//                               )
//                               : null,
//                         )
//                       : CircleAvatar(
//                           radius: kIsWeb
//                               ? 70
//                               : MediaQuery.of(context).size.width * 0.20,
//                           backgroundColor: Colors.white,
//                           backgroundImage: imageXFile == null
//                               ? null
//                               : FileImage(
//                                   File(imageXFile!.path),
//                                 ),
//                           child: imageXFile == null
//                               ? Container( 
//                                 height: 100,
//                                 width: 100,
//                                 decoration: BoxDecoration( 
//                                   color: Colors.blue,
//                                   borderRadius: BorderRadius.circular(50)
//                                 ),
//                               )
//                               : null),
//                 ),
//                 const SizedBox(height: 10,),
//                  Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: TextFormField(
//                     controller: groupNameController,
//                     decoration: const InputDecoration(
//                       hintText: "Group Name",
//                       border: OutlineInputBorder(
//                         borderSide: BorderSide(color: Colors.black),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: BorderSide(color: Colors.blue),
//                       ),
//                     ),
//                   ),
//                 ),
//                  const SizedBox(height: 10,),
//                 const Divider(color: Colors.grey,),
//                Flexible(
//                   child: ListView.builder(
//                     itemCount: widget.groupList.length,
//                     itemBuilder: (context, index) {
//                       final user = widget.groupList[index];
//                       return ListTile(
//                         leading: CircleAvatar(
//                           backgroundImage:
//                               ? NetworkImage(user.image)
//                               : null,
//                           child: user.image.isEmpty ? Icon(Icons.person) : null,
//                         ),
//                         title: Text(user.name),
//                         subtitle: Text(user.email),
//                       );
//                     },
//                   ),
//                 ),

        
        
//         ],),
//       ),
//        floatingActionButton: FloatingActionButton(backgroundColor: Colors.blue,
//         onPressed: (){
//           if(groupNameController.text != "") {
//               APIs.createGroup(name: groupNameController.text, members:widget.groupList, admin:APIs.user.uid);
//                ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(backgroundColor: Colors.blue,content: Text('group created successfully')),
                         
//                         );
//                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatMembers()));

//           }
//           else {
//              ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(backgroundColor: Colors.blue,
//                             content: Text('Please enter a group name and add at least 3 members')),
//                         );
//           }
        
//         },
//        child: Icon(Icons.done,color: Colors.white,),),
//     );
//   }
// }

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:we_chat_app/mainscreens/chat_members.dart';
import 'package:we_chat_app/models/usermodel.dart';
import 'package:we_chat_app/API/apis.dart';

class GroupDetails extends StatefulWidget {
  final List<String> groupList;
  const GroupDetails({super.key, required this.groupList});

  @override
  State<GroupDetails> createState() => _GroupDetailsState();
}

class _GroupDetailsState extends State<GroupDetails> {
  TextEditingController groupNameController = TextEditingController();
  String fToken = '';
  XFile? imageXFile;
  File? _pickedImage;
  Uint8List webImage = Uint8List(8);
  String? profileImageUrl;
  bool isLoading = false;
  Map<String, ChatUser> userMap = {};

  @override
  void initState() {
    super.initState();
    fetchGroupUsers();
   // In

  }
  Future<void> _getImage() async {
  final ImagePicker picker = ImagePicker();
  imageXFile = await picker.pickImage(source: ImageSource.gallery);
  
  if (imageXFile != null) {
    if(!kIsWeb) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString() + '.jpg'; // Unique file name
    try {
      // Upload the image to Firebase Storage
      var storageRef = FirebaseStorage.instance.ref().child('profile_pictures').child(fileName);
      await storageRef.putFile(File(imageXFile!.path));
      
      // Get the download URL
      String downloadURL = await storageRef.getDownloadURL();
      
    
      
      setState(() {
        profileImageUrl = downloadURL; // Update the profile image URL
      });
    } catch (e) {
      print('Failed to upload image: $e');
    }

    }else {
       var f = await imageXFile?.readAsBytes();
      setState(() {
        webImage = f!;
        _pickedImage = File('a');
      });
      String fileName = DateTime.now().millisecondsSinceEpoch.toString() + '.jpg'; // Unique file name
      try {
        // Upload the image to Firebase Storage
        var storageRef = FirebaseStorage.instance.ref().child('profile_pictures').child(fileName);
        await storageRef.putData(webImage);
        
        // Get the download URL
        String downloadURL = await storageRef.getDownloadURL();
        
        
       
        
        setState(() {
          profileImageUrl = downloadURL; // Update the profile image URL
        });
      } catch (e) {
        print('Failed to upload image: $e');
      }
    }
    
    
  } else {
    print('No image selected');
  }
}

  Future<void> fetchGroupUsers() async {
    setState(() {
      isLoading = true;
    });

    final users = await Future.wait(widget.groupList.map((userId) async {
      final userDoc = await APIs.firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        return ChatUser.fromJson(userDoc.data()!);
      }
      return null;
    }));

    setState(() {
      userMap = {for (var user in users.whereType<ChatUser>()) user.id: user};
      isLoading = false;
    });
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Group Details",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      _getImage();
                    },
                    child: kIsWeb
                        ? CircleAvatar(
                            radius: kIsWeb
                                ? 70
                                : MediaQuery.of(context).size.width * 0.20,
                            backgroundColor: Colors.grey,
                            backgroundImage: MemoryImage(webImage),
                            child: imageXFile == null
                                ? Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  )
                                : null,
                          )
                        : CircleAvatar(
                            radius: kIsWeb
                                ? 70
                                : MediaQuery.of(context).size.width * 0.20,
                            backgroundColor: Colors.white,
                            backgroundImage: imageXFile == null
                                ? null
                                : FileImage(File(imageXFile!.path)),
                            child: imageXFile == null
                                ? Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  )
                                : null,
                          ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: groupNameController,
                      decoration: const InputDecoration(
                        hintText: "Group Name",
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(color: Colors.grey),
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.groupList.length,
                      itemBuilder: (context, index) {
                        final userId = widget.groupList[index];
                        final user = userMap[userId];
                        if (user == null) return SizedBox.shrink();

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: user.image.isNotEmpty
                                ? NetworkImage(user.image)
                                : null,
                            child: user.image.isEmpty ? Icon(Icons.person) : null,
                          ),
                          title: Text(user.name),
                          subtitle: Text(user.email),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          if (groupNameController.text.isNotEmpty) {
            APIs.createGroup(
              profilephoto: profileImageUrl ?? "",
              name: groupNameController.text,
              members: widget.groupList,
              admin: APIs.user.uid,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.blue,
                content: Text('Group created successfully'),
              ),
            );
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatMembers()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.blue,
                content: Text('Please enter a group name and add at least 3 members'),
              ),
            );
          }
        },
        child: Icon(Icons.done, color: Colors.white),
      ),
    );
  }
}
