import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:we_chat_app/API/apis.dart';
import 'package:we_chat_app/API/apis.dart';
import 'package:we_chat_app/API/apis.dart';
import 'package:we_chat_app/authentication/login.dart';
import 'package:we_chat_app/mainscreens/creategroup.dart';
import 'package:we_chat_app/mainscreens/profilescreen.dart';
import 'package:we_chat_app/models/groupmodell.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:we_chat_app/models/message_model.dart';
import 'package:we_chat_app/models/usermodel.dart';
import 'package:we_chat_app/widgets/chat_usercard.dart';
import 'package:we_chat_app/widgets/groupcard.dart';
// class ChatMembers extends StatefulWidget {
//   const ChatMembers({super.key});

//   @override
//   State<ChatMembers> createState() => _ChatMembersState();
// }

// class _ChatMembersState extends State<ChatMembers> {
//   bool isLoading = false;
//   ChatUser? currentUser;
//   RefreshController _refreshController = RefreshController(initialRefresh: false);

//   TextEditingController addUsercontroller = TextEditingController();
//   TextEditingController searchtext = TextEditingController();
//   List<dynamic> searchList = [];
//   List<ChatUser> list = [];
//   List<Messages> messages = [];
 
//   bool _isSearching = false;
//   @override
//   void initState() {
//     super.initState();
//   }
//   @override
  
//   void onSelected(String item) {
//     switch (item) {
//       case "My Profile":
//         if (currentUser != null) {
//            Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => ProfileScreen(user: currentUser!)),
//         );

//         }
       
//         break;
//       case "Create group":
//         Navigator.push(
//           context, 
//           MaterialPageRoute(builder: (context) => CreateGroup())
//         );
//       case "Logout":
//       APIs.updateActiveStatus(false);
//         Navigator.push(
//           context, 
//           MaterialPageRoute(builder: (context) => LoginForm())
          
//         );
//         break;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
         
//           automaticallyImplyLeading: false,
//           backgroundColor: Colors.blue,
//           foregroundColor: const Color.fromRGBO(255, 255, 255, 1),
//           title: _isSearching
//               ? TextField(
//                   cursorColor: Colors.blue,
//                   controller: searchtext,
//                   decoration: const InputDecoration(
//                     hintText: "Email, Name...",
//                     fillColor: Colors.white,
//                   ),
//                   autofocus: true,
//                   onChanged: (value) {
//                     setState(() {
//                       searchList =list;
//                   },
//                 );})
//               : Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                    currentUser != null ? TextButton(onPressed: (){
//                     Navigator.push(context, MaterialPageRoute(builder: (context)=> ProfileScreen(user: currentUser!)));

//                    }, child: Text(currentUser!.name, style:const TextStyle(
//                       color: Colors.white,
//                       fontSize: 20,
                     
//                     ),))
//                    :SizedBox(),
//                   const Text(

//                       "We chat",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                 ],
//               ),
//           actions: [
//             IconButton(
//               onPressed: () {
//                 setState(() {
//                   _isSearching = !_isSearching;
//                   if (!_isSearching) {
//                     searchList.clear();
//                     searchtext.clear();
//                   }
//                 });
//               },
//               icon: Icon(
//                 _isSearching ? Icons.clear : Icons.search,
//                 color: Colors.white,
//               ),
//             ),
//             PopupMenuButton<String>(
//               icon: const Icon(
//                 Icons.more_vert,
//                 color: Colors.white,
//               ),
//               onSelected: onSelected,
//               itemBuilder: (context) => [
//                 PopupMenuItem(
//                   value: "My Profile",
//                   child: TextButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>
//                               ProfileScreen(user: currentUser!),
//                         ),
//                       );
//                     },
//                     child: const Text(
//                       "My Profile",
//                       style:  TextStyle(
//                         color: Colors.blue,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//                 ),
//                 PopupMenuItem(
//                   value: "Create Group",
//                   child: TextButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => CreateGroup(),
//                         ),
//                       );
//                     },
//                     child:const Text(
//                       "Create Group",
//                       style: const TextStyle(
//                         color: Colors.blue,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//                 ),
//                  PopupMenuItem(
//                   value: "Logout",
//                   child: TextButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => LoginForm(),
//                         ),
//                       );
//                     },
//                     child:const Text(
//                       "Logout",
//                       style: const TextStyle(
//                         color: Colors.blue,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         body: Column(
//           children: [
//             StreamBuilder(
//               stream:APIs.getAllUsers(),
//                builder:(context,snapshot) {
//                   switch (snapshot.connectionState) {
//                       case ConnectionState.waiting:
//                       case ConnectionState.none:
//                         return const Center(child: CircularProgressIndicator());
//                       case ConnectionState.active:
//                       case ConnectionState.done:
//                         if (snapshot.hasData) {
//                           final data = snapshot.data?.docs;
//                           list = data?.map((e) => ChatUser.fromJson(e.data() as Map<String, dynamic>)).toList() ?? [];
//                           if(list.isNotEmpty) {
//                             return ListView.builder(
//                               itemCount: list.length,
//                               itemBuilder: (context,index) {
//                                 return 
//                                 // ChatUserCard(user: list[index]);
//                                 StreamBuilder(
//                                   stream:APIs.getAllMessages(list[index]), 
//                                   builder: (context,snapshot) {
//                                     final messageData = snapshot.data?.docs;
//                                     messages = messageData?.map((e)=>Messages.fromJson(e.data() as Map<String,dynamic>)).toList() ?? [];
//                                     if(messages.isNotEmpty) {
//                                       return ChatUserCard(user: list[index]);
//                                       }
//                                     else {
//                                       return SizedBox();
//                                     }
//                                   });
//                                    });
//                           }else {
//                             return Text("Welcom");
//                           }
//                           }else {
//                             return Text("Welcome");
//                           }
            
//                }}),
               
//           ],
//         )
       
       
//       ),
//     );
//   }
// }
class ChatMembers extends StatefulWidget {
  const ChatMembers({super.key});

  @override
  State<ChatMembers> createState() => _ChatMembersState();
}

class _ChatMembersState extends State<ChatMembers> {
  bool isLoading = false;
  ChatUser? currentUser;
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  TextEditingController addUsercontroller = TextEditingController();
  TextEditingController searchtext = TextEditingController();
  List<dynamic> searchList = [];
  List<dynamic> combinedList = [];
  List<dynamic> usersWithConversations = [];
  bool _isSearching = false;
  Map<String, bool> userMessageCache = {};

  StreamSubscription<QuerySnapshot>? userSubscription;
  StreamSubscription<QuerySnapshot>? groupSubscription;

  @override
  void initState() {
    super.initState();
    APIs.updateActiveStatus(true);
    SystemChannels.lifecycle.setMessageHandler((message) {
      print("Message:$message");
      if (message.toString().contains('resume')) APIs.updateActiveStatus(true);
      if (message.toString().contains('pause')) APIs.updateActiveStatus(false);
      if (message.toString().contains('inactive')) APIs.updateActiveStatus(false);
      if (message.toString().contains('hidden')) APIs.updateActiveStatus(false);
      return Future.value(message);
    });
    fetchCurrentUserDetails();
    _refreshUsers();

    // Set up listeners for real-time updates
    _listenToUsersAndGroups();
  }

  void _listenToUsersAndGroups() {
    userSubscription = APIs.getAllUsers().listen((userSnapshots) {
      final users = userSnapshots.docs.map((e) => ChatUser.fromJson(e.data())).toList();
      final groupSnapshots = APIs.getAllGroups().first;
      final groups = groupSnapshots.then((groupSnapshot) {
        return groupSnapshot.docs.map((e) => GroupModel.fromJson(e.data())).toList();
      });
      groups.then((groupsList) {
        setState(() {
          combinedList = [...users, ...groupsList];
          filterUsersWithConversations();
        });
      });
    });

    groupSubscription = APIs.getAllGroups().listen((groupSnapshots) {
      final groups = groupSnapshots.docs.map((e) => GroupModel.fromJson(e.data())).toList();
      final userSnapshots = APIs.getAllUsers().first;
      final users = userSnapshots.then((userSnapshot) {
        return userSnapshot.docs.map((e) => ChatUser.fromJson(e.data())).toList();
      });
      users.then((usersList) {
        setState(() {
          combinedList = [...usersList, ...groups];
          filterUsersWithConversations();
        });
      });
    });
  }

  @override
  void dispose() {
    userSubscription?.cancel();
    groupSubscription?.cancel();
    super.dispose();
  }

  Future<void> _refreshUsers() async {
    // Fetch the latest data from your API
    final updatedData = await _getAllUsersAndGroups(); // Replace with your API call

    setState(() {
      combinedList = updatedData;
      filterUsersWithConversations();
    });

    // Complete the refresh action
    _refreshController.refreshCompleted();
  }

  Future<void> fetchCurrentUserDetails() async {
    setState(() {
      isLoading = true;
    });

    final user = FirebaseAuth.instance.currentUser!;
    final userSnapshot = await APIs.firestore.collection('users').doc(user.uid).get();

    if (userSnapshot.exists) {
      setState(() {
        currentUser = ChatUser.fromJson(userSnapshot.data()!);
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  void onSelected(String item) {
    switch (item) {
      case "My Profile":
        if (currentUser != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfileScreen(user: currentUser!)),
          );
        }
        break;
      case "Create group":
        // Navigator.push(
        //   context, 
        //   MaterialPageRoute(builder: (context) => CreateGroup())
        // );
        break;
      case "Logout":
       
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blue,
          foregroundColor: const Color.fromRGBO(255, 255, 255, 1),
          title: _isSearching
              ? TextField(
                  cursorColor: Colors.blue,
                  controller: searchtext,
                  decoration: const InputDecoration(
                    hintText: "Email, Name...",
                    fillColor: Colors.white,
                  ),
                  autofocus: true,
                  onChanged: (value) {
                    setState(() {
                      searchList = combinedList.where((item) {
                        if (item is ChatUser) {
                          return item.name.toLowerCase().contains(value.toLowerCase()) ||
                              item.email.toLowerCase().contains(value.toLowerCase());
                        } else if (item is GroupModel) {
                          return item.name.toLowerCase().contains(value.toLowerCase());
                        }
                        return false;
                      }).toList();
                    });
                  },
                )
              : Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  currentUser != null ? TextButton(
                    onPressed: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context) => ProfileScreen(user: currentUser!))
                      );
                    }, 
                    child: Text(currentUser!.name, style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ))
                  ) : const SizedBox(),
                  const Text(
                    "We chat",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                  if (!_isSearching) {
                    searchList.clear();
                    searchtext.clear();
                  }
                });
              },
              icon: Icon(
                _isSearching ? Icons.clear : Icons.search,
                color: Colors.white,
              ),
            ),
            PopupMenuButton<String>(
              icon: const Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
              onSelected: onSelected,
              itemBuilder: (context) => [
               PopupMenuItem(
                  value: "My Profile",
                  child:TextButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> ProfileScreen(user:currentUser!,)));

                  }, child: Text(
                    "My Profile",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                    ),
                  ),)
                 
                ),
              PopupMenuItem(
                  value: "Create Group",
                  child: TextButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> CreateGroup()));

                  }, child: Text(
                    "Create Group",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                    ),
                  ),)
                 
                ),
                PopupMenuItem(
                  value: "Logout",
                  child:TextButton(onPressed: (){
                    FirebaseAuth.instance.signOut();
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginForm()));

                  }, child:  Text(
                    "Logout",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                    ),
                  ),)
                ),
              ],
            ),
          ],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SmartRefresher(
                controller: _refreshController,
                onRefresh: _refreshUsers,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: _isSearching ? searchList.length : usersWithConversations.length,
                  itemBuilder: (context, index) {
                    final item = _isSearching ? searchList[index] : usersWithConversations[index];
                    if (item is ChatUser) {
                      return ChatUserCard(user: item);
                    } else if (item is GroupModel) {
                      return GroupCard(group: item);
                    }
                    return Container();
                  },
                ),
              ),
      ),
    );
  }

  Future<void> _logout() async {
    await APIs.updateActiveStatus(false); // Ensure this update is completed
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginForm())
    ); // Then sign out
  }

  Future<List<dynamic>> _getAllUsersAndGroups() async {
    final userSnapshots = await APIs.getAllUsers().first;
    final groupSnapshots = await APIs.getAllGroups().first;

    List<ChatUser> users = userSnapshots.docs.map((e) => ChatUser.fromJson(e.data())).toList();
    List<GroupModel> groups = groupSnapshots.docs.map((e) => GroupModel.fromJson(e.data())).toList();
  
    return [...users, ...groups];
  }

  void filterUsersWithConversations() async {
    List<ChatUser> filteredUsers = [];
    for (var user in combinedList) {
      if (user is ChatUser) {
        bool hasMessages = await _hasMessages(user);
        if (hasMessages) {
          filteredUsers.add(user);
        }
      }
    }
    setState(() {
      usersWithConversations = [...filteredUsers, ...combinedList.where((item) => item is GroupModel)];
    });
  }

  Future<bool> _hasMessages(ChatUser user) async {
    if (userMessageCache.containsKey(user.id)) {
      return userMessageCache[user.id]!;
    }
    try {
      var messagesSnapshot = await APIs.getAllMessages(user).first;
      bool hasMessages = messagesSnapshot.docs.isNotEmpty;
      userMessageCache[user.id] = hasMessages;
      return hasMessages;
    } catch (error) {
      print(error);
      return false; // Or return a default value if needed
    }
  }
}
