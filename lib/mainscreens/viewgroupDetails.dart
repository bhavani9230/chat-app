import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:we_chat_app/API/apis.dart';
import 'package:we_chat_app/mainscreens/addmembers.dart';
import 'package:we_chat_app/mainscreens/chat_members.dart';
import 'package:we_chat_app/mainscreens/chatscreen.dart';
import 'package:we_chat_app/mainscreens/viewprofile.dart';
import 'package:we_chat_app/models/groupmodell.dart';
import 'package:we_chat_app/models/usermodel.dart';
import 'package:we_chat_app/widgets/image.dart';


class UserTile extends StatelessWidget {
  final ChatUser user;
  final String currentUserId;
  final String groupAdminId;
  final String groupId;
  final VoidCallback onAdminChanged; // Callback to notify when admin changes

  UserTile({
    required this.user,
    required this.currentUserId,
    required this.groupAdminId,
    required this.groupId,
    required this.onAdminChanged, // Initialize the callback
  });

  void _onSelected(BuildContext context, String item) {
    switch (item) {
      case 'Start chat':
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(user: user)));
        break;
      case 'Remove':
        _removeUser(context);
        break;
      case 'View profile':
        // Implement view profile functionality
        Navigator.push(context, MaterialPageRoute(builder: (context) => ViewProfile(user: user)));
        break;
      case 'Make as Admin':
        _makeAdmin(context);
        break;
    }
  }

  void _removeUser(BuildContext context) async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Remove User'),
        content: Text('Are you sure you want to remove ${user.name} from the group?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Remove'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await APIs.removeUserFromGroup(groupId, user.id, user.name);
      // Optionally, refresh the state to reflect the change in the UI
    }
  }

  void _makeAdmin(BuildContext context) async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Make Admin'),
        content: Text('Are you sure you want to make ${user.name} the new admin of the group?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Make Admin'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await APIs.changeGroupAdmin(groupId, user.id);
      onAdminChanged(); // Notify the parent widget about the change
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: user.image.isNotEmpty ? NetworkImage(user.image) : null,
        child: user.image.isEmpty ? Icon(Icons.person) : null,
      ),
      title: user.id == APIs.user.uid ? Text("You") : Text(user.name),
      subtitle: Row(
        children: [
          Text(user.email),
          const SizedBox(width: 20),
          user.id == groupAdminId ? Flexible(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blue.withOpacity(0.2),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Text("Admin", style: TextStyle(color: Colors.blue)),
              ),
            ),
          ) : const SizedBox(),
        ],
      ),
      trailing: currentUserId != user.id ? PopupMenuButton<String>(
        onSelected: (item) => _onSelected(context, item),
        itemBuilder: (BuildContext context) {
          List<String> choices =  ['Start chat'];
          if (currentUserId == groupAdminId && user.id != groupAdminId) {
            choices.add('Remove');
            choices.add('Make as Admin');
            choices.add('View profile');
          }
          
          return choices.map((String choice) {
            return PopupMenuItem<String>(
              value: choice,
              child: Text(choice),
            );
          }).toList();
        },
        icon: Icon(Icons.more_vert),
      ):SizedBox()
    );
  }
}


         


class ViewDetailsGroup extends StatefulWidget {
  final GroupModel group;
  ViewDetailsGroup({super.key, required this.group});

  @override
  State<ViewDetailsGroup> createState() => _ViewDetailsGroupState();
}

class _ViewDetailsGroupState extends State<ViewDetailsGroup> {
  String fToken = '';
  XFile? imageXFile;
  File? _pickedImage;
  Uint8List webImage = Uint8List(8);
  late String profileImageUrl;
  String currentUserId = ''; // Store the current user ID here
  late bool allowMessaging; // Default value for allowing messaging

  RefreshController _refreshController = RefreshController(initialRefresh: false);
  TextEditingController groupName = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      profileImageUrl = widget.group.profilephoto ?? '';
      allowMessaging = widget.group.allowMessaging ?? false; // Initialize from group data
    });
    currentUserId = APIs.user.uid; // Assume this method fetches the current user ID
  }

  Future<void> _getImage() async {
    final ImagePicker picker = ImagePicker();
    imageXFile = await picker.pickImage(source: ImageSource.gallery);

    if (imageXFile != null) {
      if (!kIsWeb) {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString() + '.jpg'; // Unique file name
        try {
          // Upload the image to Firebase Storage
          var storageRef = FirebaseStorage.instance.ref().child('profile_pictures').child(fileName);
          await storageRef.putFile(File(imageXFile!.path));

          // Get the download URL
          String downloadURL = await storageRef.getDownloadURL();

          // Update the profile picture URL in the Firestore user document
          await APIs.updateProfilePictureGroup(downloadURL, widget.group.id);

          setState(() {
            profileImageUrl = downloadURL; // Update the profile image URL
          });
        } catch (e) {
          print('Failed to upload image: $e');
        }
      } else {
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

          // Update the profile picture URL in the Firestore user document
          await APIs.updateProfilePictureGroup(downloadURL, widget.group.id);

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

  Stream<List<ChatUser>> _fetchGroupMembersStream() {
    return APIs.firestore
        .collection('groups')
        .doc(widget.group.id)
        .snapshots()
        .asyncMap((snapshot) async {
          List<ChatUser> members = [];
          if (snapshot.exists) {
            List<String> memberIds = List<String>.from(snapshot.data()!['members'] ?? []);
            for (String uid in memberIds) {
              ChatUser? user = await APIs.getUserDetailsByUid(uid);
              if (user != null) {
                members.add(user);
              }
            }
          }
          return members;
        });
  }

  Future<void> _refreshMembers() async {
    setState(() {
      // This triggers the UI to refresh with the updated stream
    });
    _refreshController.refreshCompleted();
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Group'),
          content: Text('Are you sure you want to delete this group?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteGroup();
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChatMembers()));
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showExitConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Exit Group'),
          content: Text('Are you sure you want to exit this group?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _exitGroup();
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChatMembers()));
              },
              child: Text('Exit', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteGroup() async {
    try {
      await APIs.deleteGroup(widget.group.id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(backgroundColor: Colors.blue,
          content: Text('Group deleted successfully')),
      );
      Navigator.push(context, MaterialPageRoute(builder: (context) => ChatMembers()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.blue,content: Text('Failed to delete group: $e')),
      );
    }
  }

  Future<void> _exitGroup() async {
    try {
      await APIs.removeUserFromGroup(widget.group.id, currentUserId,APIs.user.displayName ?? "");
     
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Exited group successfully')),
      );
      Navigator.push(context, MaterialPageRoute(builder: (context) => ChatMembers()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to exit group: $e')),
      );
    }
  }

  Future<void> _toggleMessaging(bool value) async {
    try {
      await APIs.updateGroupMessagingStatus(widget.group.id, value);
      setState(() {
        allowMessaging = value;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.blue,
          content: Text('Messaging status updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.blue,content: Text('Failed to update messaging status: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: Text(
          widget.group.name,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SmartRefresher(
        controller: _refreshController,
        onRefresh: _refreshMembers,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> FullImage(ImageUrl: profileImageUrl)));
                    },
                    child: CircleAvatar(
                      radius: 100,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: NetworkImage(profileImageUrl),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _getImage();
                    },
                    icon: Icon(Icons.camera_alt),
                  ),
                ],
              ),
              const SizedBox(height: 20),
               Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    
                    Text(widget.group.name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _showEditDialog('name'),
                    ),
                  ],
                ),
              
              const SizedBox(height: 10),
              StreamBuilder<List<ChatUser>>(
                stream: _fetchGroupMembersStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No members found');
                  } else {
                    return Column(
                      children: [
                        Text(
                          'Group Members: ${snapshot.data!.length}',
                          style: const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        const SizedBox(height: 20),
                         currentUserId == widget.group.admin
                            ? SwitchListTile(
                                title: const Text("Allow Users to Send Messages",
                                 style: TextStyle(fontSize:16, color: Colors.black),),
                                value: allowMessaging,
                                activeColor: Colors.blue,
                                onChanged: (value) {
                                  _toggleMessaging(value);
                                },
                              )
                            :const SizedBox(),
                             const SizedBox(height: 20),
                       
                        currentUserId == widget.group.admin
                            ? ListTile(
                                leading: Container(
                                  width: 35,
                                  height: 35,
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(20)),
                                  child:const Icon(Icons.person_add, color: Colors.white),
                                ),
                                title:const Text(
                                  "Add Members",
                                  style: TextStyle(color: Colors.blue),
                                ),
                                onTap: () {
                                  _addUser();
                                },
                              )
                            : SizedBox(),
                       
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            ChatUser member = snapshot.data![index];
                            return UserTile(
                              groupId: widget.group.id,
                              user: member,
                              currentUserId: currentUserId,
                              groupAdminId: widget.group.admin,
                              onAdminChanged: _refreshMembers,
                            );
                          },
                        ),
                        currentUserId == widget.group.admin
                            ? Card(
                                child: ListTile(
                                  title: const Text(
                                    "Delete Group",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  onTap: () {
                                    _showDeleteConfirmationDialog();
                                  },
                                ),
                              )
                            : Card(
                                child: ListTile(
                                  title:const Text(
                                    "Exit",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  onTap: () {
                                    _showExitConfirmationDialog();
                                  },
                                ),
                              ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addUser() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => AddMembers(group: widget.group)));
  }
   Future<void> _showEditDialog(String field) async {
   
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit ${field[0].toUpperCase() + field.substring(1)}'),
          content: TextField(
            controller: groupName,
            decoration: InputDecoration(
              hintText: 'Enter new $field',
            ),
            autofocus: true,
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                widget.group.name = groupName.text;
              
                APIs.updateGroupName(groupId: widget.group.id, newName:groupName.text).then((_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.blue,
                      content: Text('Details Updated successfully'),
                    ),
                  );
                  Navigator.of(context).pop();
                  setState(() {});
                }).catchError((e) {
                  print('Error updating user info: $e');
                });
              },
            ),
          ],
        );
      },
    );
  }
   
}
