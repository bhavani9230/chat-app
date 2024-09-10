// import 'package:flutter/material.dart';
// import 'package:we_chat_app/models/usermodel.dart';

// class CreateGroup extends StatefulWidget {
//   const CreateGroup({super.key});

//   @override
//   State<CreateGroup> createState() => _CreateGroupState();
// }

// class _CreateGroupState extends State<CreateGroup> {
//   List<ChatUser>  grouplist = [];

  
//   TextEditingController groupname = TextEditingController();
//   TextEditingController membersdata = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar:AppBar( 

//       ),
//       body: Column( 
//         children: [ 
//           TextFormField( 
//             controller: groupname,
//             decoration:const InputDecoration( 
//               hintText: "Group Name",
//               border: OutlineInputBorder( 
//                 borderSide: BorderSide(color: Colors.black)
//               ),
//               focusedBorder: OutlineInputBorder( 
//                 borderSide: BorderSide(color: Colors.blue)
//               )
//             ),
            

//           ),


//            Container(
//             width: double.infinity,
//              child: Row(
//                children: [
//                  TextFormField( 
//                   controller: groupname,
//                   decoration:const InputDecoration( 
//                     hintText: "Members add here",
//                      ),),
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//                     onPressed: (){

//                   }, child:Text("Add"))
//                ],
//              ),
//            ),

//         ],
//       ),

//     );
//   }
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:we_chat_app/models/usermodel.dart';
// import 'package:we_chat_app/API/apis.dart'; // Ensure you have this import

// class CreateGroup extends StatefulWidget {
//   const CreateGroup({super.key});

//   @override
//   State<CreateGroup> createState() => _CreateGroupState();
// }

// class _CreateGroupState extends State<CreateGroup> {
//   List<ChatUser> groupList = [];
//   List<ChatUser> allUsers = [];
//   TextEditingController groupNameController = TextEditingController();
//   TextEditingController membersDataController = TextEditingController();
//   bool isLoading = false;


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Create Group"),
//       ),
//       body: StreamBuilder(
//         stream: APIs.getAllUsers(),
//         builder: (context, snapshot) {
//            switch (snapshot.connectionState) {
//               case ConnectionState.waiting:
//               case ConnectionState.none:
//                 return const Center(
//                   child: CircularProgressIndicator(),
//                 );

//               case ConnectionState.active:
//               case ConnectionState.done:
//                 final data = snapshot.data?.docs;
//                 allUsers = data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
//                 if(allUsers.isNotEmpty) {
//                    return Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: TextFormField(
//                   controller: groupNameController,
//                   decoration: const InputDecoration(
//                     hintText: "Group Name",
//                     border: OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.black),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: BorderSide(color: Colors.blue),
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: TextFormField(
//                         controller: membersDataController,
//                         decoration: const InputDecoration(
//                           hintText: "Member email",
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 8.0),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//                       onPressed: (){
//                         for(var user in allUsers) {
//                           if(user.email== membersDataController.text.trim()) {
//                             groupList.add(user);
                          
                            

//                           }
//                         }
//                       },
//                       child: isLoading
//                           ? CircularProgressIndicator(
//                               valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//                             )
//                           : Text("Add"),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
             
//             ],
//           );

//                 }else {

//                   return Text("No users found to create group");
//                 }
               

                
          
         
//         }
//      })
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:we_chat_app/mainscreens/group_profile.dart';
// import 'package:we_chat_app/models/usermodel.dart';
// import 'package:we_chat_app/API/apis.dart';

// class CreateGroup extends StatefulWidget {
//   const CreateGroup({super.key});

//   @override
//   State<CreateGroup> createState() => _CreateGroupState();
// }

// class _CreateGroupState extends State<CreateGroup> {
//   List<ChatUser> searchList = [];
//   List<ChatUser> groupList = [];
//   List<ChatUser> allUsers = [];
//   TextEditingController groupNameController = TextEditingController();
//   TextEditingController membersDataController = TextEditingController();
//   bool isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     addCurrentUserToGroup();
//   }

//   void addCurrentUserToGroup() {
//     final currentUser = ChatUser(
//       about: "Hey, I'm using WeChat",
//       createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
//       email: APIs.user.email!,
//       id: APIs.user.uid,
//       image: APIs.user.photoURL ?? '',
//       isonline: false,
//       lastActive: DateTime.now().millisecondsSinceEpoch.toString(),
//       name: APIs.user.displayName ?? 'You',
//       pushToken: '',
//     );
//     setState(() {
//       groupList.add(currentUser);
//     });
//   }

//   void addMember(ChatUser user) {
//     setState(() {
//       groupList.add(user);
//       searchList.clear();
//       membersDataController.clear();
//     });
//   }

//   void searchMember(String query) {
//     final suggestions = allUsers.where((user) {
//       final userLower = user.email.toLowerCase();
//       final queryLower = query.toLowerCase();
//       return userLower.contains(queryLower);
//     }).toList();

//     setState(() {
//       searchList = suggestions;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blue,
//         foregroundColor: Colors.white,
//         title: const Text("Create Group"),
//       ),
//       body: StreamBuilder(
//         stream: APIs.getAllUsers(),
//         builder: (context, snapshot) {
//           switch (snapshot.connectionState) {
//             case ConnectionState.waiting:
//             case ConnectionState.none:
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );

//             case ConnectionState.active:
//             case ConnectionState.done:
//               final data = snapshot.data?.docs;
//               allUsers = data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
//               if (allUsers.isNotEmpty) {
//                 return Column(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: TextFormField(
//                         controller: groupNameController,
//                         decoration: const InputDecoration(
//                           hintText: "Group Name",
//                           border: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.black),
//                           ),
//                           focusedBorder: OutlineInputBorder(
//                             borderSide: BorderSide(color: Colors.blue),
//                           ),
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Column(
//                         children: [
//                           TextField(
//                             controller: membersDataController,
//                             decoration: const InputDecoration(
//                               hintText: "Email, Name...",
//                             ),
//                             onChanged: searchMember,
//                           ),
//                           const SizedBox(height: 8.0),
//                           if (searchList.isNotEmpty)
//                             Container(
//                               height: 100.0,
//                               child: ListView.builder(
//                                 itemCount: searchList.length,
//                                 itemBuilder: (context, index) {
//                                   final user = searchList[index];
//                                   return ListTile(
//                                     title: Text(user.name),
//                                     subtitle: Text(user.email),
//                                     onTap: () => addMember(user),
//                                   );
//                                 },
//                               ),
//                             ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                     Expanded(
//                       child: ListView.builder(
//                         itemCount: groupList.length,
//                         itemBuilder: (context, index) {
//                           final user = groupList[index];
//                           return ListTile(
//                             leading: CircleAvatar(
//                               backgroundImage: user.image.isNotEmpty
//                                   ? NetworkImage(user.image)
//                                   : null,
//                               child: user.image.isEmpty ? Icon(Icons.person) : null,
//                             ),
//                             title: Text(user.name),
//                             subtitle: Text(user.email),
//                           );
//                         },
//                       ),
//                     ),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//                       onPressed: () {
//                         if (groupNameController.text.isNotEmpty && groupList.length >= 3) {
//                           APIs.createGroup(
//                             name: groupNameController.text,
//                             members: groupList,
//                             admin: APIs.user.uid,
//                           ).then((_) {
//                             Navigator.push(context, MaterialPageRoute(builder: (context)=> GroupDetails()));
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(content: Text('Group created successfully')),
//                             );
//                           }).catchError((error) {
//                             print("Error creating group: $error");
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(content: Text('Failed to create group')),
//                             );
//                           });
//                         } else {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(content: Text('Please enter a group name and add at least 3 members')),
//                           );
//                         }
//                       },
//                       child: const Text("Create Group", style: TextStyle(color: Colors.white)),
//                     ),
//                   ],
//                 );
//               } else {
//                 return const Center(
//                   child: Text("No users found to create group"),
//                 );
//               }
//           }
//         },
//       ),
//     );
//   }
// }
// import 'dart:async';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:we_chat_app/mainscreens/group_profile.dart';
// import 'package:we_chat_app/models/usermodel.dart';
// import 'package:we_chat_app/API/apis.dart';

// class CreateGroup extends StatefulWidget {
//   const CreateGroup({super.key});

//   @override
//   State<CreateGroup> createState() => _CreateGroupState();
// }

// class _CreateGroupState extends State<CreateGroup> {
//   List<ChatUser> searchList = [];
//   List<String> groupList = [];
//   List<ChatUser> allUsers = [];
 
//   TextEditingController membersDataController = TextEditingController();
//   bool isLoading = false;
//   Timer? _debounce;

//   @override
//   void initState() {
//     super.initState();
//     addCurrentUserToGroup();
//     fetchAllUsers();
//   }

//   void addCurrentUserToGroup() {
   
//     setState(() {
//       groupList.add(APIs.user.uid);
//     });
//   }

//   void fetchAllUsers() async {
//     setState(() {
//       isLoading = true;
//     });

//     final data = await APIs.getAllUsers().first;
//     setState(() {
//       allUsers = data.docs.map((e) => ChatUser.fromJson(e.data())).toList();
//       isLoading = false;
//     });
//   }

//   void addMember(String user) {
//     setState(() {
//       groupList.add(user);
//       searchList.clear();
//       membersDataController.clear();
//     });
//   }

//   void searchMember(String query) {
//     if (_debounce?.isActive ?? false) _debounce?.cancel();
//     _debounce = Timer(const Duration(milliseconds: 300), () {
//       final suggestions = allUsers.where((user) {
//         final userLower = user.email.toLowerCase();
//         final queryLower = query.toLowerCase();
//         return userLower.contains(queryLower);
//       }).toList();

//       setState(() {
//         searchList = suggestions;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _debounce?.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Create Group"),
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Column(
//               children: [
               
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Column(
//                     children: [
//                       TextField(
//                         controller: membersDataController,
//                         decoration: const InputDecoration(
//                           hintText: "Email...",
//                         ),
//                         onChanged: searchMember,
//                       ),
//                       const SizedBox(height: 8.0),
//                       if (searchList.isNotEmpty)
//                         Container(
//                           height: 100.0,
//                           child: ListView.builder(
//                             itemCount: searchList.length,
//                             itemBuilder: (context, index) {
//                               final user = searchList[index];
//                               return ListTile(
//                                 title: Text(user.name),
//                                 subtitle: Text(user.email),
//                                 onTap: () => addMember(user.id),
//                               );
//                             },
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: groupList.length,
//                     itemBuilder: (context, index) {
//                       final user = groupList[index];
//                       return
//                       ListTile(
//                         leading: CircleAvatar(
//                           backgroundImage:user.image
//                               ? NetworkImage(user.)
//                               : null,
//                           child: user.image.isEmpty ? Icon(Icons.person) : null,
//                         ),
//                         title: Text(user.name),
//                         subtitle: Text(user.email),
//                         trailing: groupList[index].email == FirebaseAuth.instance.currentUser!.email ?SizedBox(): 
//                         IconButton(onPressed:  (){
//                           setState(() {
//                             groupList.removeAt(index);
                            
//                           }); },
//                          icon: Icon(Icons.cancel,color: Colors.red,)),
//                       );
//                     },
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//                     onPressed: () {
//                       if (groupList.length >= 3) {
                      
//                           // Navigator.push(context, MaterialPageRoute(builder: (context) => GroupDetails( groupList: groupList)));
//                           // ScaffoldMessenger.of(context).showSnackBar(
//                           //   const SnackBar(content: Text('Group created successfully')));
                          
                      
//                       } else {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(content: Text('Please enter a group name and add at least 3 members')),
//                         );
//                       }
//                     },
//                     child: const Text("Create Group", style: TextStyle(color: Colors.white)),
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }
// }
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:we_chat_app/mainscreens/group_profile.dart';
import 'package:we_chat_app/models/usermodel.dart';
import 'package:we_chat_app/API/apis.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({super.key});

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  
  List<ChatUser> searchList = [];
  List<String> groupList = [];
  List<ChatUser> allUsers = [];
  Map<String, ChatUser> userMap = {};

  TextEditingController membersDataController = TextEditingController();
  bool isLoading = false;
  Timer? _debounce;
  ChatUser? currentUser;

 
  @override
  void initState() {
    super.initState();
    fetchCurrentUserDetails();
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
        addCurrentUserToGroup();
        fetchAllUsers();
      });
    } else {
      // Handle user not existing case if needed
    }

    setState(() {
      isLoading = false;
    });
  }

   void addCurrentUserToGroup() {
    if (currentUser != null) {
      setState(() {
        groupList.add(currentUser!.id);
        userMap[currentUser!.id] = currentUser!;
      });
    }
  
  }

  void fetchAllUsers() async {
    setState(() {
      isLoading = true;
    });

    final data = await APIs.getAllUsers().first;
    setState(() {
      allUsers = data.docs.map((e) => ChatUser.fromJson(e.data())).toList();
      for (var user in allUsers) {
        userMap[user.id] = user;
      }
      isLoading = false;
    });
  }

  void addMember(String user) {
    setState(() {
      groupList.add(user);
      searchList.clear();
      membersDataController.clear();
    });
  }
  void searchMember(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      final suggestions = allUsers.where((user) {
        final userLower = user.email.toLowerCase();
        final queryLower = query.toLowerCase();
        return userLower.contains(queryLower);
      }).toList();

      setState(() {
        searchList = suggestions;
      });
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text("Create Group",style: TextStyle(color: Colors.white),),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: membersDataController,
                        decoration: const InputDecoration(
                          hintText: "Search by email...",
                        ),
                        onChanged: searchMember,
                      ),
                      const SizedBox(height: 8.0),
                      if (searchList.isNotEmpty)
                        Container(
                          height: 100.0,
                          child: ListView.builder(
                            itemCount: searchList.length,
                            itemBuilder: (context, index) {
                              final user = searchList[index];
                              return ListTile(
                                title: Text(user.name),
                                subtitle: Text(user.email),
                                onTap: () => addMember(user.id),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: groupList.length,
                    itemBuilder: (context, index) {
                      final userId = groupList[index];
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
                        trailing: user.email == FirebaseAuth.instance.currentUser!.email
                            ? SizedBox()
                            : IconButton(
                                onPressed: () {
                                  setState(() {
                                    groupList.removeAt(index);
                                  });
                                },
                                icon: Icon(Icons.cancel, color: Colors.red),
                              ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    onPressed: () {
                      if (groupList.length >= 3) {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => GroupDetails(groupList: groupList)));
                       
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(backgroundColor: Colors.blue,
                            content: Text('Please enter a group name and add at least 3 members')),
                        );
                      }
                    },
                    child: const Text("Create Group", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
    );
  }
}
