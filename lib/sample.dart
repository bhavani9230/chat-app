// // // import 'dart:developer';
// // // import 'package:firebase_auth/firebase_auth.dart';
// // // import 'package:flutter/cupertino.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:flutter/services.dart';
// // // import 'package:we_chat_app/API/apis.dart';
// // // import 'package:we_chat_app/mainscreens/profilescreen.dart';
// // // import 'package:we_chat_app/models/usermodel.dart';
// // // import 'package:we_chat_app/widgets/chat_usercard.dart';


// // // class ChatMembers extends StatefulWidget {
// // //   const ChatMembers({super.key});

// // //   @override
// // //   State<ChatMembers> createState() => _ChatMembersState();
// // // }

// // // class _ChatMembersState extends State<ChatMembers> {
// // //   TextEditingController addUsercontroller = TextEditingController();
// // //   TextEditingController searchtext = TextEditingController();
// // //   List<ChatUser> searchList = [];
// // //   List<ChatUser> usersWithMessages = [];
// // //   List<ChatUser> allUsers = []; // To hold all registered users
// // //   bool _isSearching = false;

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     APIs.getSelfInfo();
// // //     APIs.updateActiveStatus(true);
// // //     SystemChannels.lifecycle.setMessageHandler((message) {
// // //       print("Message:$message");
// // //       if (message.toString().contains('resume')) APIs.updateActiveStatus(true);
// // //       if (message.toString().contains('pause')) APIs.updateActiveStatus(false);

// // //       return Future.value(message);
// // //     });
// // //   }

// // //   Future<List<ChatUser>> _filterUsersWithMessages(List<ChatUser> users) async {
// // //     List<ChatUser> usersWithMessages = [];
// // //     for (var user in users) {
// // //       var messagesSnapshot = await APIs.getAllMessages(user).first;
// // //       if (messagesSnapshot.docs.isNotEmpty) {
// // //         usersWithMessages.add(user);
// // //       }
// // //     }
// // //     return usersWithMessages;
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return SafeArea(
// // //       child: Scaffold(
// // //         appBar: AppBar(
// // //           automaticallyImplyLeading: true,
// // //           backgroundColor: Colors.blue,
// // //           foregroundColor: Colors.white,
// // //           leading: Icon(Icons.home),
// // //           title: _isSearching
// // //               ? TextField(
// // //                   controller: searchtext,
// // //                   decoration: InputDecoration(hintText: "Email, Name..."),
// // //                   autofocus: true,
// // //                   onChanged: (value) {
// // //                     setState(() {
// // //                       searchList = allUsers
// // //                           .where((user) =>
// // //                               user.name.toString().toLowerCase().contains(value.toLowerCase()) ||
// // //                               user.email.toString().toLowerCase().contains(value.toLowerCase()))
// // //                           .toList();
// // //                     });
// // //                   })
// // //               : Text("Chat Members"),
// // //           actions: [
// // //             IconButton(
// // //                 onPressed: () {
// // //                   setState(() {
// // //                     _isSearching = !_isSearching;
// // //                     if (!_isSearching) {
// // //                       searchList.clear();
// // //                       searchtext.clear();
// // //                     }
// // //                   });
// // //                 },
// // //                 icon: Icon(_isSearching ? Icons.clear : Icons.search)),
// // //             IconButton(onPressed: () {
// // //                Navigator.push(context, MaterialPageRoute(builder: (context) => 
// // //                ProfileScreen(user:usersWithMessages[0],)));
// // //                 // if (APIs.me != null) {
// // //                 //     Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
// // //                 //   } else {
// // //                 //     print("Error: User data not available");
// // //                 //   }
             
// // //             }, icon:const Icon(Icons.more_vert)),
// // //             IconButton(
// // //                 onPressed: () {
// // //                   Navigator.pop(context);
// // //                   APIs.updateActiveStatus(false);
// // //                   FirebaseAuth.instance.signOut();
// // //                 },
// // //                 icon: Icon(Icons.arrow_back))
// // //           ],
// // //         ),
// // //         floatingActionButton: FloatingActionButton(
// // //           onPressed: () {
// // //             userAddFunction();
// // //           },
// // //           child:const Icon(Icons.add),
// // //         ),
// // //         body: StreamBuilder(
// // //           stream: APIs.getAllUsers(),
// // //           builder: (context, snapshot) {
// // //             switch (snapshot.connectionState) {
// // //               case ConnectionState.waiting:
// // //               case ConnectionState.none:
// // //                 return const Center(
// // //                   child: CircularProgressIndicator(),
// // //                 );

// // //               case ConnectionState.active:
// // //               case ConnectionState.done:
// // //                 final data = snapshot.data?.docs;
// // //                 allUsers = data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

// // //                 return FutureBuilder<List<ChatUser>>(
// // //                   future: _filterUsersWithMessages(allUsers),
// // //                   builder: (context, AsyncSnapshot<List<ChatUser>> filteredSnapshot) {
// // //                     if (filteredSnapshot.connectionState == ConnectionState.waiting) {
// // //                       return const Center(child: CircularProgressIndicator());
// // //                     }
// // //                     if (filteredSnapshot.hasError) {
// // //                       return const Center(child: Text('Error occurred'));
// // //                     }

// // //                     usersWithMessages = filteredSnapshot.data ?? [];

// // //                     if (usersWithMessages.isNotEmpty || allUsers.isNotEmpty) {
// // //                       return ListView.builder(
// // //                           physics: BouncingScrollPhysics(),
// // //                           itemCount: _isSearching ? searchList.length : usersWithMessages.length,
// // //                           itemBuilder: (context, index) {
// // //                             final user = _isSearching ? searchList[index] : usersWithMessages[index];
// // //                             return ChatUserCard(user: user);
// // //                           });
// // //                     } else {
// // //                       return const Center(
// // //                         child: Text(
// // //                           "Start Chatting",
// // //                           style: TextStyle(fontSize: 35),
// // //                         ),
// // //                       );
// // //                     }
// // //                   },
// // //                 );
// // //             }
// // //           },
// // //         ),
// // //       ),
// // //     );
// // //   }

// // //   void userAddFunction() {
// // //     String email = '';
// // //     showDialog(
// // //       context: context,
// // //       builder: (context) => AlertDialog(
// // //         content: SizedBox(
// // //           height: MediaQuery.of(context).size.height * 0.5,
// // //           width: MediaQuery.of(context).size.width * 0.7,
// // //           child: Column(
// // //             mainAxisAlignment: MainAxisAlignment.center,
// // //             children: [
// // //               Text("Add Users"),
// // //               TextFormField(
// // //                   maxLines: null,
// // //                   onChanged: (value) => email = value,
// // //                   controller: addUsercontroller,
// // //                   decoration: const InputDecoration(
// // //                       hintText: "Add Email",
// // //                       border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)))),
// // //             ],
// // //           ),
// // //         ),
// // //         actions: [
// // //           ElevatedButton(
// // //               onPressed: () {
// // //                 Navigator.pop(context);
// // //               },
// // //               child:const Text("Cancel")),
// // //           ElevatedButton(
// // //               onPressed: () async {
// // //                 Navigator.pop(context);
// // //                 if (email.isNotEmpty) {
// // //                   await APIs.addChatUser(email).then((value) {
// // //                     if (!value) {}
// // //                   });
// // //                 }
// // //               },
// // //               child: Text("Add User")),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }
// // import 'dart:io';
// // import 'package:chat_application/auth_screen/login.dart';
// // import 'package:chat_application/screens/home_screen.dart';
// // import 'package:chat_application/widgets/responsive.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:firebase_storage/firebase_storage.dart';
// // import 'package:flutter/foundation.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter/widgets.dart';
// // import 'package:fluttertoast/fluttertoast.dart';
// // import 'package:image_picker/image_picker.dart';

// // class RegisterScreen extends StatefulWidget {
// //   const RegisterScreen({Key? key}) : super(key: key);

// //   @override
// //   State<RegisterScreen> createState() => _RegisterScreenState();
// // }

// // class _RegisterScreenState extends State<RegisterScreen> {
// //   final _formKey = GlobalKey<FormState>();
// //   bool rememberUser = false;
// //   TextEditingController nameController = TextEditingController();
// //   TextEditingController emailController = TextEditingController();
// //   TextEditingController passController = TextEditingController();
// //   final _nameRegex = RegExp(r'^[a-zA-Z]+(?: [a-zA-Z]+)*$');
// //   final _emailRegex = RegExp(
// //       r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
// //   final _passwordRegex =
// //       RegExp(r'^(?=.?[A-Z])(?=.?[a-z])(?=.?[0-9])(?=.?[!@#\$&*~]).{8,}$');
// //   bool _nameValid = true;
// //   bool _emailValid = true;
// //   bool _passwordValid = true;
// //   bool passToggle = true;

// //   final _auth = FirebaseAuth.instance;
// //   final _firestore = FirebaseFirestore.instance;
// //   final _storage = FirebaseStorage.instance;
// //   XFile? imageXFile;
// //   File? _pickedImage;
// //   Uint8List webImage = Uint8List(8);

// //   Future<void> _signUp() async {
// //     try {
// //       UserCredential userCredential =
// //           await _auth.createUserWithEmailAndPassword(
// //         email: emailController.text,
// //         password: passController.text,
// //       );

// //       final imageUrl = await _uploadImage();

// //       await _firestore.collection('users').doc(userCredential.user!.uid).set({
// //         'uid': userCredential.user!.uid,
// //         'name': nameController.text,
// //         'email': emailController.text,
// //         'imageUrl': imageUrl,
// //       });

// //       Fluttertoast.showToast(msg: "Registration successful");

// //       Navigator.pushReplacement(
// //         context,
// //         MaterialPageRoute(builder: (context) => const HomeScreen()),
// //       );
// //     } on FirebaseAuthException catch (e) {
// //       if (e.code == 'email-already-in-use') {
// //         Fluttertoast.showToast(msg: "The email address is already in use.");
// //       } else {
// //         Fluttertoast.showToast(msg: "Error: ${e.message}");
// //       }
// //     } catch (e) {
// //       Fluttertoast.showToast(msg: "An unknown error occurred.");
// //     }
// //   }

// //   Future<void> _getImage() async {
// //     final ImagePicker picker = ImagePicker();
// //     try {
// //       imageXFile = await picker.pickImage(source: ImageSource.gallery);
// //       if (imageXFile != null) {
// //         if (!kIsWeb) {
// //           var selected = File(imageXFile!.path);
// //           setState(() {
// //             _pickedImage = selected;
// //           });
// //         } else {
// //           var f = await imageXFile!.readAsBytes();
// //           setState(() {
// //             webImage = f;
// //             _pickedImage = File('a');
// //           });
// //         }
// //       } else {
// //         print('No image selected');
// //       }
// //     } catch (e) {
// //       print('Error picking image: $e');
// //     }
// //   }

// //   Future<String> _uploadImage() async {
// //     if (imageXFile == null) {
// //       return '';
// //     }

// //     final ref = _storage
// //         .ref()
// //         .child('user_images')
// //         .child('${_auth.currentUser!.uid}.jpg');

// //     if (kIsWeb) {
// //       await ref.putData(webImage);
// //     } else {
// //       await ref.putFile(File(imageXFile!.path));
// //     }

// //     return await ref.getDownloadURL();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Center(
// //         child: ConstrainedBox(
// //           constraints: BoxConstraints(maxWidth: 400),
// //           child: Padding(
// //             padding: Responsive.isDesktop(context) ||
// //                     Responsive.isDesktopLarge(context)
// //                 ? EdgeInsets.all(0)
// //                 : EdgeInsets.all(20),
// //             child: SingleChildScrollView(
// //               child: Form(
// //                 key: _formKey,
// //                 child: Padding(
// //                   padding: Responsive.isDesktop(context) ||
// //                           Responsive.isDesktopLarge(context)
// //                       ? EdgeInsets.all(0)
// //                       : EdgeInsets.all(20),
// //                   child: Column(
// //                     mainAxisAlignment: MainAxisAlignment.center,
// //                     crossAxisAlignment: CrossAxisAlignment.center,
// //                     children: [
// //                       const Text(
// //                         'Create Account',
// //                         style: TextStyle(
// //                           fontSize: 24,
// //                           fontWeight: FontWeight.bold,
// //                         ),
// //                       ),
// //                       const SizedBox(height: 8),
// //                       const Text(
// //                         "Let's Create Account Together",
// //                         style: TextStyle(fontSize: 15, color: Colors.grey),
// //                       ),
// //                       const SizedBox(height: 10),
// //                       Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Center(
// //                             child: InkWell(
// //                               onTap: () {
// //                                 _getImage();
// //                               },
// //                               child: kIsWeb
// //                                   ? CircleAvatar(
// //                                       radius: kIsWeb
// //                                           ? 60
// //                                           : MediaQuery.of(context).size.width *
// //                                               0.20,
// //                                       backgroundColor: Colors.grey,
// //                                       backgroundImage: webImage.isEmpty
// //                                           ? null
// //                                           : MemoryImage(webImage),
// //                                       child: imageXFile == null
// //                                           ? Icon(
// //                                               Icons.add_photo_alternate,
// //                                               size: kIsWeb
// //                                                   ? 60
// //                                                   : MediaQuery.of(context)
// //                                                           .size
// //                                                           .width *
// //                                                       0.20,
// //                                               color: Colors.white,
// //                                             )
// //                                           : null,
// //                                     )
// //                                   : CircleAvatar(
// //                                       radius: kIsWeb
// //                                           ? 70
// //                                           : MediaQuery.of(context).size.width *
// //                                               0.20,
// //                                       backgroundColor: Colors.grey,
// //                                       backgroundImage: _pickedImage == null
// //                                           ? null
// //                                           : FileImage(
// //                                               _pickedImage!,
// //                                             ),
// //                                       child: _pickedImage == null
// //                                           ? Icon(
// //                                               Icons.add_photo_alternate,
// //                                               size: kIsWeb
// //                                                   ? 70
// //                                                   : MediaQuery.of(context)
// //                                                           .size
// //                                                           .width *
// //                                                       0.20,
// //                                               color: Colors.white,
// //                                             )
// //                                           : null,
// //                                     ),
// //                             ),
// //                           ),
// //                           const Text('Full Name'),
// //                           const SizedBox(height: 10),
// //                           TextField(
// //                             cursorColor: Colors.deepPurple,
// //                             keyboardType: TextInputType.name,
// //                             controller: nameController,
// //                             obscureText: false,
// //                             onChanged: (value) {
// //                               setState(() {
// //                                 _nameValid = _nameRegex.hasMatch(value);
// //                               });
// //                             },
// //                             decoration: InputDecoration(
// //                               focusedBorder: const OutlineInputBorder(
// //                                 borderRadius:
// //                                     BorderRadius.all(Radius.circular(10)),
// //                                 borderSide:
// //                                     BorderSide(color: Colors.deepPurple),
// //                               ),
// //                               border: const OutlineInputBorder(
// //                                 borderRadius:
// //                                     BorderRadius.all(Radius.circular(10)),
// //                                 borderSide:
// //                                     BorderSide(color: Colors.deepPurple),
// //                               ),
// //                               labelText: 'Enter Your Name',
// //                               errorText: _nameValid ? null : "Invalid name",
// //                               labelStyle: const TextStyle(
// //                                   color: Colors.grey, fontSize: 15),
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                       const SizedBox(height: 10),
// //                       Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           const Text('Email'),
// //                           const SizedBox(height: 10),
// //                           TextField(
// //                             cursorColor: Colors.deepPurple,
// //                             keyboardType: TextInputType.emailAddress,
// //                             controller: emailController,
// //                             obscureText: false,
// //                             onChanged: (value) {
// //                               setState(() {
// //                                 _emailValid = _emailRegex.hasMatch(value);
// //                               });
// //                             },
// //                             decoration: InputDecoration(
// //                               focusedBorder: const OutlineInputBorder(
// //                                 borderRadius:
// //                                     BorderRadius.all(Radius.circular(10)),
// //                                 borderSide:
// //                                     BorderSide(color: Colors.deepPurple),
// //                               ),
// //                               border: const OutlineInputBorder(
// //                                 borderRadius:
// //                                     BorderRadius.all(Radius.circular(10)),
// //                                 borderSide:
// //                                     BorderSide(color: Colors.deepPurple),
// //                               ),
// //                               labelText: 'Enter Your Email',
// //                               errorText: _emailValid ? null : "Invalid Email",
// //                               labelStyle: const TextStyle(
// //                                   color: Colors.grey, fontSize: 15),
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                       const SizedBox(height: 10),
// //                       const Align(
// //                           alignment: Alignment.bottomLeft,
// //                           child: Text('Password')),
// //                       const SizedBox(height: 10),
// //                       TextField(
// //                         onChanged: (value) {
// //                           setState(() {
// //                             _passwordValid = _passwordRegex.hasMatch(value);
// //                           });
// //                         },
// //                         cursorColor: Colors.deepPurple,
// //                         keyboardType: TextInputType.text,
// //                         controller: passController,
// //                         obscureText: passToggle,
// //                         decoration: InputDecoration(
// //                           focusedBorder: const OutlineInputBorder(
// //                             borderRadius: BorderRadius.all(Radius.circular(10)),
// //                             borderSide: BorderSide(color: Colors.deepPurple),
// //                           ),
// //                           border: const OutlineInputBorder(
// //                             borderRadius: BorderRadius.all(Radius.circular(10)),
// //                             borderSide: BorderSide(color: Colors.deepPurple),
// //                           ),
// //                           labelText: 'Enter Your Password',
// //                           errorText:
// //                               _passwordValid ? null : "Invalid Password Format",
// //                           labelStyle:
// //                               const TextStyle(color: Colors.grey, fontSize: 15),
// //                           suffixIcon: InkWell(
// //                             onTap: () {
// //                               setState(() {
// //                                 passToggle = !passToggle;
// //                               });
// //                             },
// //                             child: Icon(
// //                               passToggle
// //                                   ? Icons.visibility_off
// //                                   : Icons.visibility,
// //                               color: Colors.deepPurple,
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                       const SizedBox(height: 20),
// //                       SizedBox(
// //                         width: MediaQuery.of(context).size.width,
// //                         child: Container(
// //                           decoration: const BoxDecoration(
// //                             color: Colors.deepPurple,
// //                             borderRadius: BorderRadius.all(Radius.circular(10)),
// //                           ),
// //                           child: TextButton(
// //                             onPressed: () {
// //                               if (!_nameValid ||
// //                                   !_emailValid ||
// //                                   !_passwordValid ||
// //                                   imageXFile == null) {
// //                                 Fluttertoast.showToast(
// //                                     msg: "Please fill all fields correctly");
// //                                 return;
// //                               }
// //                               _signUp();
// //                             },
// //                             // style: ElevatedButton.styleFrom(
// //                             //   foregroundColor: Colors.white,
// //                             //   backgroundColor: Colors.deepPurple,
// //                             //   fixedSize:
// //                             //       Size(MediaQuery.of(context).size.width, 50),
// //                             // ),
// //                             child: const Text('Register',
// //                                 style: TextStyle(color: Colors.white)),
// //                           ),
// //                         ),
// //                       ),
// //                       const SizedBox(height: 10),
// //                       Row(
// //                         mainAxisAlignment: MainAxisAlignment.center,
// //                         crossAxisAlignment: CrossAxisAlignment.center,
// //                         children: [
// //                           const Text(
// //                             "Already Have An Account?",
// //                             style: TextStyle(
// //                                 color: Colors.deepPurple, fontSize: 15),
// //                           ),
// //                           TextButton(
// //                             onPressed: () {
// //                               Navigator.push(
// //                                 context,
// //                                 MaterialPageRoute(
// //                                   builder: (context) => const LoginScreen(),
// //                                 ),
// //                               );
// //                             },
// //                             child: const Text(
// //                               "Login",
// //                               style:
// //                                   TextStyle(color: Colors.black, fontSize: 15),
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// /* import 'dart:io';
// import 'dart:typed_data';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';

// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:url_launcher/url_launcher.dart';

// class ChatScreen extends StatefulWidget {
//   final String chatId;
//   final String receiverId;

//   const ChatScreen({
//     Key? key,
//     required this.chatId,
//     required this.receiverId,
//   }) : super(key: key);

//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   late String senderId;
//   String receiverName = ''; // Default empty string
//   String receiverImageUrl = ''; // Default empty string
//   final TextEditingController messageController = TextEditingController();
//   File? _pickedImage;
//   XFile? imageXFile;
//   Uint8List webImage = Uint8List(0);

//   final ScrollController _scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     senderId = _auth.currentUser!.uid;
//     _fetchReceiverInfo();
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   Future<void> _fetchReceiverInfo() async {
//     try {
//       DocumentSnapshot receiverSnapshot =
//           await _firestore.collection('users').doc(widget.receiverId).get();
//       if (receiverSnapshot.exists) {
//         setState(() {
//           receiverName = receiverSnapshot['name'];
//           receiverImageUrl = receiverSnapshot['imageUrl'];
//         });
//       }
//     } catch (e) {
//       print('Error fetching receiver information: $e');
//     }
//   }

//   void sendMessage() async {
//     String messageBody = messageController.text.trim();
//     if (messageBody.isNotEmpty) {
//       try {
//         await _firestore
//             .collection('chats')
//             .doc(widget.chatId)
//             .collection('messages')
//             .add({
//           'messageType': 'text',
//           'messageBody': messageBody,
//           'senderId': senderId,
//           'receiverId': widget.receiverId,
//           'timestamp': Timestamp.now(),
//         });
//         // Update the lastMessage and lastTime fields in the chats document
//         await _firestore.collection('chats').doc(widget.chatId).set({
//           'lastMessage': messageBody,
//           'lastTime': FieldValue.serverTimestamp(),
//         }, SetOptions(merge: true));
//         messageController.clear();
//         _scrollToBottom();
//       } catch (e) {
//         print('Error sending message: $e');
//       }
//     }
//   }

//   Future<void> _sendImage() async {
//     final ImagePicker picker = ImagePicker();
//     try {
//       final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//       if (pickedFile != null) {
//         if (!kIsWeb) {
//           final File imageFile = File(pickedFile.path);
//           String imageUrl = await _uploadImageAndGetUrl(imageFile);
//           await _firestore
//               .collection('chats')
//               .doc(widget.chatId)
//               .collection('messages')
//               .add({
//             'messageType': 'image_url',
//             'messageBody': imageUrl,
//             'senderId': senderId,
//             'receiverId': widget.receiverId,
//             'timestamp': Timestamp.now(),
//           });
//           await _firestore.collection('chats').doc(widget.chatId).set({
//             'lastMessage': imageUrl,
//             'lastTime': FieldValue.serverTimestamp(),
//           }, SetOptions(merge: true));
//         } else {
//           final bytes = await pickedFile.readAsBytes();
//           setState(() {
//             webImage = bytes;
//             _pickedImage = File('dummy.jpg'); // Provide a dummy file for web
//           });
//           String imageUrl = await _uploadWebImageAndGetUrl(webImage);
//           await _firestore
//               .collection('chats')
//               .doc(widget.chatId)
//               .collection('messages')
//               .add({
//             'messageType': 'image_url',
//             'messageBody': imageUrl,
//             'senderId': senderId,
//             'receiverId': widget.receiverId,
//             'timestamp': Timestamp.now(),
//           });
//           await _firestore.collection('chats').doc(widget.chatId).set({
//             'lastMessage': imageUrl,
//             'lastTime': FieldValue.serverTimestamp(),
//           }, SetOptions(merge: true));
//         }
//       } else {
//         print('No image selected');
//       }
//     } catch (e) {
//       print('Error picking image: $e');
//     }
//   }

//   Future<String> _uploadImageAndGetUrl(File imageFile) async {
//     try {
//       final Reference storageReference = FirebaseStorage.instance
//           .ref()
//           .child('chat_images')
//           .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
//       UploadTask uploadTask = storageReference.putFile(imageFile);
//       TaskSnapshot taskSnapshot = await uploadTask;
//       String imageUrl = await taskSnapshot.ref.getDownloadURL();
//       return imageUrl;
//     } catch (e) {
//       print('Error uploading image: $e');
//       rethrow;
//     }
//   }

//   Future<String> _uploadWebImageAndGetUrl(Uint8List webImage) async {
//     try {
//       final Reference storageReference = FirebaseStorage.instance
//           .ref()
//           .child('chat_images')
//           .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
//       UploadTask uploadTask = storageReference.putData(webImage);
//       TaskSnapshot taskSnapshot = await uploadTask;
//       String imageUrl = await taskSnapshot.ref.getDownloadURL();
//       return imageUrl;
//     } catch (e) {
//       print('Error uploading web image: $e');
//       rethrow;
//     }
//   }

//   void _scrollToBottom() {
//     _scrollController.animateTo(
//       _scrollController.position.maxScrollExtent,
//       duration: const Duration(milliseconds: 300),
//       curve: Curves.easeOut,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//         title: StreamBuilder<DocumentSnapshot>(
//           stream: FirebaseFirestore.instance
//               .collection('users')
//               .doc(widget.receiverId)
//               .snapshots(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Text('Loading...');
//             }
//             if (!snapshot.hasData || !snapshot.data!.exists) {
//               return const Text('Receiver');
//             }
//             var receiverData = snapshot.data!.data() as Map<String, dynamic>;
//             String receiverName = receiverData['name'] ?? 'Receiver';
//             String receiverImageUrl = receiverData['imageUrl'] ?? '';
//             return Row(
//               children: [
//                 CircleAvatar(
//                   backgroundImage: receiverImageUrl.isNotEmpty
//                       ? NetworkImage(receiverImageUrl)
//                       : null,
//                   radius: 20,
//                   child: receiverImageUrl.isNotEmpty
//                       ? null
//                       : Text(receiverName.isNotEmpty
//                           ? receiverName[0].toUpperCase()
//                           : '?'),
//                 ),
//                 const SizedBox(width: 8),
//                 Text(receiverName),
//               ],
//             );
//           },
//         ),
//         centerTitle: false,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('chats')
//                   .doc(widget.chatId)
//                   .collection('messages')
//                   .orderBy('timestamp')
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                   return const Center(child: Text('No messages yet'));
//                 }

//                 // Step 4: Attach ScrollController to ListView.builder
//                 WidgetsBinding.instance!.addPostFrameCallback((_) {
//                   _scrollToBottom(); // Scroll to bottom initially
//                 });

//                 return ListView.builder(
//                   controller: _scrollController,
//                   itemCount: snapshot.data!.docs.length,
//                   itemBuilder: (context, index) {
//                     DocumentSnapshot messageDoc = snapshot.data!.docs[index];
//                     Map<String, dynamic> messageData =
//                         messageDoc.data() as Map<String, dynamic>;
//                     return _buildMessageTile(messageData, messageDoc.reference);
//                   },
//                 );
//               },
//             ),
//           ),
//           _buildMessageInput(),
//         ],
//       ),
//     );
//   }

//   Widget _buildMessageTile(
//     Map<String, dynamic> data,
//     DocumentReference messageRef,
//   ) {
//     String senderId = data['senderId'];
//     bool isSender = senderId == this.senderId;

//     return FutureBuilder<DocumentSnapshot>(
//       future: _firestore.collection('users').doc(senderId).get(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData || !snapshot.data!.exists) {
//           return const SizedBox(); // Return an empty widget if sender data is not available
//         }

//         var userData = snapshot.data!.data() as Map<String, dynamic>;

//         Timestamp timestamp =
//             data['timestamp'] as Timestamp? ?? Timestamp.now();
//         DateTime dateTime = timestamp.toDate();
//         String formattedDate =
//             DateFormat('yyyy-MM-dd – kk:mm:a').format(dateTime);

//         return GestureDetector(
//           onTap: isSender
//               ? () => _showMessageOptions(messageRef, data['messageBody'])
//               : null,
//           child: Container(
//             margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//             child: Row(
//               mainAxisAlignment:
//                   isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: isSender
//                         ? CrossAxisAlignment.end
//                         : CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         constraints: BoxConstraints(
//                           maxWidth: MediaQuery.of(context).size.width * 0.7,
//                         ),
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: isSender
//                               ? Colors.deepPurple.withOpacity(0.2)
//                               : Colors.green.withOpacity(0.2),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             _buildMessageBody(data),
//                             const SizedBox(height: 4),
//                             Text(
//                               formattedDate,
//                               style: const TextStyle(
//                                 fontSize: 10,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                             if (data['edited'] == true)
//                               const Text(
//                                 'Edited',
//                                 style:
//                                     TextStyle(fontSize: 10, color: Colors.red),
//                               ),
//                             if (data['deleted'] == true)
//                               const Text(
//                                 'Deleted',
//                                 style:
//                                     TextStyle(fontSize: 10, color: Colors.red),
//                               ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildMessageBody(Map<String, dynamic> data) {
//     String messageType = data['messageType'] ?? 'text';
//     String messageBody = data['messageBody'] ?? '';

//     switch (messageType) {
//       case 'text':
//         // Check if messageBody is a URL
//         bool isUrl = Uri.tryParse(messageBody)?.hasAbsolutePath ?? false;
//         return isUrl
//             ? InkWell(
//                 onTap: () async {
//                   if (await canLaunch(messageBody)) {
//                     await launch(messageBody);
//                   } else {
//                     print('Could not launch $messageBody');
//                   }
//                 },
//                 child: Text(
//                   messageBody,
//                   style: const TextStyle(
//                       color: Colors.blue, decoration: TextDecoration.underline),
//                 ),
//               )
//             : Text(messageBody);
//       case 'image_url':
//         return _buildImageMessage(messageBody);
//       default:
//         return Text('Unsupported message type: $messageType');
//     }
//   }

//   Widget _buildImageMessage(String imageUrl) {
//     return GestureDetector(
//       onTap: () async {
//         if (await canLaunch(imageUrl)) {
//           await launch(imageUrl);
//         } else {
//           print('Could not launch $imageUrl');
//         }
//       },
//       child: Image.network(
//         imageUrl,
//         loadingBuilder: (BuildContext context, Widget child,
//             ImageChunkEvent? loadingProgress) {
//           if (loadingProgress == null) return child;
//           return Center(
//             child: CircularProgressIndicator(
//               value: loadingProgress.expectedTotalBytes != null
//                   ? loadingProgress.cumulativeBytesLoaded /
//                       loadingProgress.expectedTotalBytes!
//                   : null,
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildMessageInput() {
//     return Container(
//       padding: const EdgeInsets.all(8),
//       child: Row(
//         children: [
//           IconButton(
//             icon: const Icon(Icons.image),
//             onPressed: _sendImage,
//           ),
//           Expanded(
//             child: Container(
//               height: 50,
//               child: TextField(
//                 controller: messageController,
//                 decoration: InputDecoration(
//                   hintText: 'Enter your message...',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                 ),
//                 // textInputAction: TextInputAction.send,
//                 // onSubmitted: (value) {
//                 //   sendMessage();
//                 // },
//               ),
//             ),
//           ),
//           IconButton(
//             icon: const Icon(Icons.send),
//             onPressed: sendMessage,
//           ),
//         ],
//       ),
//     );
//   }

//   void _showMessageOptions(
//       DocumentReference messageRef, String currentMessage) {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return SafeArea(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               ListTile(
//                 leading: const Icon(Icons.edit),
//                 title: const Text('Edit'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _editMessage(messageRef, currentMessage);
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.delete),
//                 title: const Text('Delete'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _deleteMessage(messageRef);
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void _editMessage(DocumentReference messageRef, String currentMessage) async {
//     TextEditingController editController =
//         TextEditingController(text: currentMessage);
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Edit Message'),
//           content: TextField(
//             controller: editController,
//             decoration: const InputDecoration(hintText: 'Edit your message'),
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: const Text('Save'),
//               onPressed: () async {
//                 if (editController.text.trim().isNotEmpty) {
//                   try {
//                     await messageRef.update({
//                       'messageBody': editController.text.trim(),
//                       'edited': true,
//                     });
//                     Navigator.of(context).pop();
//                   } catch (e) {
//                     print('Error editing message: $e');
//                   }
//                 }
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _deleteMessage(DocumentReference messageRef) async {
//     try {
//       await messageRef.update({
//         'messageBody': "This message is deleted by sender",
//         'deleted': true,
//         'deletedAt': Timestamp.now(),
//       });
//     } catch (e) {
//       print('Error deleting message: $e');
//     }
//   }

//   void _showBottomSheet(BuildContext context, DocumentReference messageRef,
//       String currentMessage) {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         TextEditingController editController =
//             TextEditingController(text: currentMessage);
//         return Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: editController,
//                 decoration: const InputDecoration(labelText: 'Edit Message'),
//               ),
//               const SizedBox(height: 10),
//               ElevatedButton(
//                 onPressed: () {
//                   _editMessage(messageRef, editController.text);
//                   Navigator.of(context).pop();
//                 },
//                 child: const Text('Save Changes'),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   _deleteMessage(messageRef);
//                   Navigator.of(context).pop();
//                 },
//                 child: const Text('Delete Message'),
//                 style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// } */

// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart'; // Import for date formatting
// import 'package:uuid/uuid.dart';

// class ChatRoom extends StatelessWidget {
//   final Map<String, dynamic> userMap;
//   final String chatRoomId;

//   ChatRoom({required this.chatRoomId, required this.userMap});

//   final TextEditingController _message = TextEditingController();
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   File? imageFile;

//   Future getImage() async {
//     ImagePicker _picker = ImagePicker();

//     await _picker.pickImage(source: ImageSource.gallery).then((xFile) {
//       if (xFile != null) {
//         imageFile = File(xFile.path);
//         uploadImage();
//       }
//     });
//   }

//   Future uploadImage() async {
//     String fileName = Uuid().v1();
//     int status = 1;

//     await _firestore
//         .collection('chatroom')
//         .doc(chatRoomId)
//         .collection('chats')
//         .doc(fileName)
//         .set({
//       "sendby": _auth.currentUser!.displayName,
//       "message": "",
//       "type": "img",
//       "time": FieldValue.serverTimestamp(),
//     });

//     var ref =
//         FirebaseStorage.instance.ref().child('images').child("$fileName.jpg");

//     var uploadTask = await ref.putFile(imageFile!).catchError((error) async {
//       await _firestore
//           .collection('chatroom')
//           .doc(chatRoomId)
//           .collection('chats')
//           .doc(fileName)
//           .delete();

//       status = 0;
//     });

//     if (status == 1) {
//       String imageUrl = await uploadTask.ref.getDownloadURL();

//       await _firestore
//           .collection('chatroom')
//           .doc(chatRoomId)
//           .collection('chats')
//           .doc(fileName)
//           .update({"message": imageUrl});

//       print(imageUrl);
//     }
//   }

//   void onSendMessage() async {
//     if (_message.text.isNotEmpty) {
//       Map<String, dynamic> messages = {
//         "sendby": _auth.currentUser!.displayName,
//         "message": _message.text,
//         "type": "text",
//         "time": FieldValue.serverTimestamp(),
//       };

//       _message.clear();
//       await _firestore
//           .collection('chatroom')
//           .doc(chatRoomId)
//           .collection('chats')
//           .add(messages);
//     } else {
//       print("Enter Some Text");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       appBar: AppBar(
//         foregroundColor: Colors.white,
//         backgroundColor: Colors.cyan,
//         title: StreamBuilder<DocumentSnapshot>(
//           stream:
//               _firestore.collection("users").doc(userMap['uid']).snapshots(),
//           builder: (context, snapshot) {
//             if (snapshot.data != null) {
//               return Container(
//                 child: Column(
//                   children: [
//                     Text(userMap['name']),
//                     Text(
//                       snapshot.data!['status'],
//                       style: const TextStyle(fontSize: 14),
//                     ),
//                   ],
//                 ),
//               );
//             } else {
//               return Container();
//             }
//           },
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Container(
//               height: size.height / 1.25,
//               width: size.width,
//               child: StreamBuilder<QuerySnapshot>(
//                 stream: _firestore
//                     .collection('chatroom')
//                     .doc(chatRoomId)
//                     .collection('chats')
//                     .orderBy("time", descending: false)
//                     .snapshots(),
//                 builder: (BuildContext context,
//                     AsyncSnapshot<QuerySnapshot> snapshot) {
//                   if (snapshot.data != null) {
//                     return ListView.builder(
//                       itemCount: snapshot.data!.docs.length,
//                       itemBuilder: (context, index) {
//                         Map<String, dynamic> map = snapshot.data!.docs[index]
//                             .data() as Map<String, dynamic>;
//                         return messages(size, map, context);
//                       },
//                     );
//                   } else {
//                     return Container();
//                   }
//                 },
//               ),
//             ),
//             Container(
//               height: size.height / 10,
//               width: size.width,
//               alignment: Alignment.center,
//               child: Container(
//                 height: size.height / 12,
//                 width: size.width / 1.1,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       height: size.height / 17,
//                       width: size.width / 1.3,
//                       child: TextField(
//                         controller: _message,
//                         decoration: InputDecoration(
//                             suffixIcon: IconButton(
//                               onPressed: () => getImage(),
//                               icon: Icon(Icons.photo),
//                             ),
//                             hintText: "Send Message",
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             )),
//                       ),
//                     ),
//                     IconButton(
//                         icon: Icon(Icons.send), onPressed: onSendMessage),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget messages(Size size, Map<String, dynamic> map, BuildContext context) {
//     Timestamp timestamp = map['time'];
//     DateTime dateTime = timestamp.toDate();

//     String formattedTime =
//         DateFormat.jm().format(dateTime); // Format time in 12-hour format

//     return map['type'] == "text"
//         ? Container(
//             width: size.width,
//             alignment: map['sendby'] == _auth.currentUser!.displayName
//                 ? Alignment.centerRight
//                 : Alignment.centerLeft,
//             child: Container(
//               padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
//               margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(30),
//                     topRight: Radius.circular(30),
//                     bottomRight: Radius.circular(30)),
//                 color: Colors.blue,
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     map['message'],
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                       color: Colors.white,
//                     ),
//                   ),
//                   SizedBox(height: 4),
//                   Text(
//                     formattedTime,
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           )
//         : Container(
//             height: size.height / 2.5,
//             width: size.width,
//             padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//             alignment: map['sendby'] == _auth.currentUser!.displayName
//                 ? Alignment.centerRight
//                 : Alignment.centerLeft,
//             child: InkWell(
//               onTap: () => Navigator.of(context).push(
//                 MaterialPageRoute(
//                   builder: (_) => ShowImage(
//                     imageUrl: map['message'],
//                   ),
//                 ),
//               ),
//               child: Container(
//                 height: size.height / 2.5,
//                 width: size.width / 2,
//                 decoration: BoxDecoration(border: Border.all()),
//                 alignment: map['message'] != "" ? null : Alignment.center,
//                 child: map['message'] != ""
//                     ? Column(
//                         children: [
//                           Expanded(
//                             child: Image.network(
//                               map['message'],
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                           SizedBox(height: 4),
//                           Text(
//                             formattedTime,
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: Colors.black,
//                             ),
//                           ),
//                         ],
//                       )
//                     : CircularProgressIndicator(),
//               ),
//             ),
//           );
//   }
// }

// class ShowImage extends StatelessWidget {
//   final String imageUrl;

//   const ShowImage({required this.imageUrl, Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.of(context).size;

//     return Scaffold(
//       body: Container(
//         height: size.height,
//         width: size.width,
//         color: Colors.black,
//         child: Image.network(imageUrl),
//       ),
//     );
//   }
// }