// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:we_chat_app/API/apis.dart';
// import 'package:we_chat_app/models/groupmodell.dart';
// import 'package:we_chat_app/models/usermodel.dart';


// class AddMembers extends StatefulWidget {
//   final GroupModel group;
//   const AddMembers({super.key, required this.group});

//   @override
//   State<AddMembers> createState() => _AddMembersState();
// }

// class _AddMembersState extends State<AddMembers> {
//   final TextEditingController _searchController = TextEditingController();
//   List<ChatUser> _searchResults = [];

//   @override
//   void initState() {
//     super.initState();
//     _searchController.addListener(_onSearchChanged);
//   }

//   @override
//   void dispose() {
//     _searchController.removeListener(_onSearchChanged);
//     _searchController.dispose();
//     super.dispose();
//   }

//   void _onSearchChanged() {
//     _searchUsers(_searchController.text);
//   }

//   Future<void> _searchUsers(String query) async {
//     if (query.isEmpty) {
//       setState(() {
//         _searchResults = [];
//       });
//       return;
//     }

//     final results = await FirebaseFirestore.instance
//         .collection('users')
//         .where('name', isGreaterThanOrEqualTo: query)
//         .where('name', isLessThanOrEqualTo: query + '\uf8ff')
//         .get();

//     setState(() {
//       _searchResults = results.docs.map((doc) => ChatUser.fromJson(doc.data())).toList();
//     });
//   }

//   Future<void> _addMember(ChatUser user) async {
//     if (widget.group.members.contains(user.id)) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(backgroundColor: Colors.blue,
//           content:
//           Text('${user.name} is already a member.'),
//         ),
//       );
//       return;
//     }

//     // Add the user to the group members list
//     await FirebaseFirestore.instance.collection('groups').doc(widget.group.id).update({
//       'members': FieldValue.arrayUnion([user.id]),
//     });

//     setState(() {
//       widget.group.members.add(user.id);
//     });

//     await APIs.sendSystemMessage(widget.group.id, '${user.name} has been added to the group');

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         backgroundColor: Colors.blue,
//         content: Text('${user.name} has been added to the group.'),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: IconThemeData(color: Colors.white),
//         title:const Text('Add Members',style: TextStyle(color: Colors.white),),
//         backgroundColor: Colors.blue,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _searchController,
//               decoration:const InputDecoration(
//                 labelText: 'Search',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: _searchResults.length,
//                 itemBuilder: (context, index) {
//                   final user = _searchResults[index];
//                   return ListTile(
//                     title: Text(user.name),
//                     subtitle: Text(user.email),
//                     trailing: ElevatedButton(
//                       style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//                       onPressed: () {
//                         _addMember(user);
//                         _searchController.clear();

//                       }, 
//                       child: Text('Add',style: TextStyle(color: Colors.white)),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:we_chat_app/API/apis.dart';
import 'package:we_chat_app/models/groupmodell.dart';
import 'package:we_chat_app/models/usermodel.dart';

class AddMembers extends StatefulWidget {
  final GroupModel group;
  const AddMembers({super.key, required this.group});

  @override
  State<AddMembers> createState() => _AddMembersState();
}

class _AddMembersState extends State<AddMembers> {
  final TextEditingController _searchController = TextEditingController();
  List<ChatUser> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _searchUsers(_searchController.text);
  }

  Future<void> _searchUsers(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    final results = await FirebaseFirestore.instance
        .collection('users')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThanOrEqualTo: query + '\uf8ff')
        .get();

    final allUsers = results.docs.map((doc) => ChatUser.fromJson(doc.data())).toList();

    // Filter out current members
    final nonMembers = allUsers.where((user) => !widget.group.members.contains(user.id)).toList();

    setState(() {
      _searchResults = nonMembers;
    });
  }

  Future<void> _addMember(ChatUser user) async {
    if (widget.group.members.contains(user.id)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.blue,
          content: Text('${user.name} is already a member.'),
        ),
      );
      return;
    }

    // Add the user to the group members list
    await FirebaseFirestore.instance.collection('groups').doc(widget.group.id).update({
      'members': FieldValue.arrayUnion([user.id]),
    });

    setState(() {
      widget.group.members.add(user.id);
    });

    await APIs.sendSystemMessage(widget.group.id, '${user.name} has been added to the group');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.blue,
        content: Text('${user.name} has been added to the group.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text('Add Members', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final user = _searchResults[index];
                  return ListTile(
                    title: Text(user.name),
                    subtitle: Text(user.email),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                      onPressed: () {
                        _addMember(user);
                        _searchController.clear();
                      },
                      child: const Text('Add', style: TextStyle(color: Colors.white)),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
