import 'package:flutter/material.dart';
import 'package:we_chat_app/API/apis.dart';
import 'package:we_chat_app/models/usermodel.dart';
//  // Adjust the import path
class ViewProfile extends StatelessWidget {
  final ChatUser user;
  


  ViewProfile({required this.user});

  late bool isBlocked;

  void _toggleBlockStatus(BuildContext context) async {
    bool newStatus = !user.isBlocked;
    await APIs.toggleBlockStatus(user.id, newStatus);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(newStatus ? 'User blocked' : 'User unblocked'),
      ),
    );
    // Optionally, you can add logic to refresh the user's data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          user.name,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(user.image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: Center(
                        child: Text(
                          'Name: ${user.name}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Card(
                    child: SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: Center(
                        child: Text(
                          'About: ${user.about}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Card(
                    child: SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: Center(
                        child: Text(
                          'Email: ${user.email}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Card(
                    child: SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: Center(
                        child: TextButton(
                          onPressed: () => _toggleBlockStatus(context),
                          child: Text(
                            user.isBlocked ? 'Unblock user' : 'Block user',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// class ViewProfile extends StatelessWidget {
//   final ChatUser user; // User object passed in constructor

//   ViewProfile({required this.user}); // Constructor

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
      
//       appBar: AppBar(
//         iconTheme:IconThemeData(color: Colors.white),
//         title: Text(user.name,style: TextStyle(color: Colors.white),),
//         backgroundColor: Colors.blue,
//         foregroundColor: Colors.white,
//       ),
//       body: Column(
//         children: [
//           // Image section
//           Container(
//             height: MediaQuery.of(context).size.height * 0.5, // Image covers half the screen height
//             width: double.infinity,
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: NetworkImage(user.image),
//                 fit: BoxFit.cover, // Cover the entire container
//               ),
//               // borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
//             ),
//           ),
//           // User details section
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // User name
//                     Card(
//                     child: SizedBox(
//                       height:50,
//                       width:double.infinity,
//                       child: Center(
//                         child: Text('Name : ${user.name ?? 'No about info available'}'
//                           ,
//                           style:const  TextStyle(
//                             fontSize: 16,
//                             color: Colors.black,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
                 
//                   SizedBox(height: 8),
//                   // User about
//                   Card(
//                     child: SizedBox(
//                       height:50,
//                       width:double.infinity,
//                       child: Center(
//                         child: Text('About : ${user.about ?? 'No about info available'}'
//                           ,
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.grey[700],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 8),
//                   // User email
//                   Card(
//                     child: SizedBox(
//                       height:50,
//                       width:double.infinity,
//                       child: Center(
//                         child: Text('Email : ${user.email?? 'No about info available'}'
//                           ,
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.grey[700],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   //block user
//                    Card(
//                     child: SizedBox(
//                       height:50,
//                       width:double.infinity,
//                       child: Center(
//                         child: TextButton(onPressed: (){


//                         }, child:const  Text("Block user"
//                           ,
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.red,
//                           ),
//                         ),)
                        
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
