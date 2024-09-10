



// import 'dart:io';
// import 'dart:typed_data';

// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:we_chat_app/API/apis.dart';
// import 'package:we_chat_app/authentication/login.dart';
// import 'package:we_chat_app/models/usermodel.dart';

// class ProfileScreen extends StatefulWidget {
//   late ChatUser user;
//    ProfileScreen({super.key,required this.user });

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//    String fToken = '';
//   XFile? imageXFile;
//   File? _pickedImage;
//   Uint8List webImage = Uint8List(8);
  
//   Future<void> _getImage() async {
//     final ImagePicker picker = ImagePicker();
//     imageXFile = await picker.pickImage(source: ImageSource.gallery);
//     if (imageXFile != null) {
//       if (!kIsWeb) {
//         var selected = File(imageXFile!.path);
       
//         setState(() {
//           _pickedImage = selected;
//         });
//       } else {
//         var f = await imageXFile!.readAsBytes();
//         setState(() {
//           webImage = f;
//           _pickedImage =
//               File('a'); // Not sure why you're creating a dummy file here
//         });
//       }
//     } else {
//       print('No image selected');
//     }
//   }
//   final _formKey = GlobalKey<FormState>();
//   TextEditingController nameeditor = TextEditingController();
//   TextEditingController abouteditot = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => FocusScope.of(context).unfocus(),
//       child: Scaffold(
//         appBar: AppBar( 
//           foregroundColor: Colors.white,
//           backgroundColor: Colors.blue,
//           centerTitle: true,
//           title: const Text("My Profile",style: TextStyle(color: Colors.white
//           ),),
      
//         ),
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal:MediaQuery.of(context).size.width*0.15, vertical:MediaQuery.of(context).size.height*0.2 ),
//             child: Form(
//               key: _formKey,
//               child: Column( 
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [ 
//               //     Stack( 
//               //       alignment: Alignment.bottomRight,
//               //       children: [ 
//               //           Container( 
//               //     height: 200,
//               //     width:200,
//               //     decoration:BoxDecoration( 
//               //       borderRadius: BorderRadius.circular(100),
//               //       color: Colors.blue.withOpacity(0.7)),
//               //       child: Center(child: Text(widget.user.name[0].toUpperCase(),style: TextStyle(color: Colors.white,fontSize: 30),)),
//               //   ),
//               //     IconButton(onPressed:  (){
//               //       _showBottomsheet();
                        
//               //     }, icon: const Icon(Icons.edit))
//               //  ],
//               //     ),
//                InkWell(
//                 onTap: () {
//                   _getImage();
//                 },
//                 child: kIsWeb
//                     ? CircleAvatar(
//                         radius: kIsWeb
//                             ? 70
//                             : MediaQuery.of(context).size.width * 0.20,
//                         backgroundColor: Colors.grey,
//                         backgroundImage: MemoryImage(
//                             webImage), // Assuming `webImage` is a Uint8List

//                         child: imageXFile == null
//                             ? Container( 
//                               height: 100,
//                               width: 100,
//                               decoration: BoxDecoration( 
//                                 color: Colors.blue,
//                                 borderRadius: BorderRadius.circular(50)
//                               ),
//                             )
//                             : null,
//                       )
//                     : CircleAvatar(
//                         radius: kIsWeb
//                             ? 70
//                             : MediaQuery.of(context).size.width * 0.20,
//                         backgroundColor: Colors.white,
//                         backgroundImage: imageXFile == null
//                             ? null
//                             : FileImage(
//                                 File(imageXFile!.path),
//                               ),
//                         child: imageXFile == null
//                             ? Container( 
//                               height: 100,
//                               width: 100,
//                               decoration: BoxDecoration( 
//                                 color: Colors.blue,
//                                 borderRadius: BorderRadius.circular(50)
//                               ),
//                             )
//                             : null),
//               ),
//                    const SizedBox(height: 20,),
//                    Text('Email :  ${widget.user.email}',style:const TextStyle(fontSize: 16),),
//                    const SizedBox(height: 20,),
//                    Container(
//                     width:MediaQuery.of(context).size.width*0.5,
//                      child: Row( 
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [ 
//                         Icon(Icons.person_outline),
//                         Text(widget.user.name,),
                        
//                       ],
//                      ),
//                    ),

                        
//                   TextFormField( 
//                      validator: (value) {
//                       value != null && value.isNotEmpty ? null : "Required field";
//                     },
//                    onSaved: (value) => APIs.me!.name = value ?? "",
//                     controller: nameeditor,
//                     decoration: InputDecoration( 
//                       border:const OutlineInputBorder( 
//                         borderSide: BorderSide(color: Colors.grey)
//                       ),
//                       focusedBorder: OutlineInputBorder( 
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide:const BorderSide(color: Colors.blue)
//                       ),
//                       hintText:widget.user.name,
//                       suffix:const Icon(Icons.person,color:Colors.blue,)
//                     ),
                  
//                   ),
//                   const SizedBox(height: 20,),
//                    TextFormField( 
//                     onSaved: (value) => APIs.me!.about= value ?? "",
//                     validator: (value) {
//                       value != null && value.isNotEmpty ? null : "Required field";
//                     },
//                     controller: abouteditot,
//                     decoration: InputDecoration( 
//                      suffix:const Icon(Icons.ac_unit,color:Colors.blue,),
//                        border:const OutlineInputBorder( 
//                         borderSide: BorderSide(color: Colors.grey)
//                       ),
//                       focusedBorder: OutlineInputBorder( 
//                         borderRadius: BorderRadius.circular(10),
//                         borderSide:const BorderSide(color: Colors.blue)
//                       ),
//                       hintText:widget.user.about
//                     ),
                  
//                   ),
                    
//                  const SizedBox(height: 20,),
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//                     onPressed: (){
//                       if(nameeditor.text != "" && abouteditot.text != "") {
                     
//                        APIs.updateUserInfo(name:nameeditor.text,about: abouteditot.text).then((value) => print("updated"));
//                         ScaffoldMessenger.of(context).showSnackBar(
//                          const SnackBar(
//                             backgroundColor: Colors.blue,
//                             content:Text("Detailes Updated successfully")));
//                       }

//                     },
//                    child:const Text("Update",style: TextStyle(color: Colors.white))) 
//                 ],
//               ),
//             ),
//           ),
//         ),
//         floatingActionButton: FloatingActionButton.extended(
//           backgroundColor: Colors.blue,
//           onPressed: (){
//             Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginForm()));
//             APIs.auth.signOut();
      
//         }, label:const Text("Logout",style: TextStyle(color: Colors.white),),
//         icon:const Icon(Icons.logout,color: Colors.white,),
//         ),
      
//       ),
//     );
//   }
//    void _showBottomsheet() {
//     showModalBottomSheet(
     
//       context: context,
//        builder:(context) {
//         return  Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column( 
//               children: [ 
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//                   onPressed: (){
                  
          
//                 }, child:const Center(child: Text("Choose from Gallery",style: TextStyle(color: Colors.white),),)),
//                 const SizedBox(height: 20,),
//                  ElevatedButton(
//                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//                   onPressed: (){
          
//                 }, child:const  Center(child: Text("Choose from Camera",style: TextStyle(color: Colors.white),),))
//               ],
            
//           ),
//         );
//        });
//   }

// }

import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:we_chat_app/API/apis.dart';
import 'package:we_chat_app/authentication/login.dart';
import 'package:we_chat_app/models/usermodel.dart';

// class ProfileScreen extends StatefulWidget {
//   final ChatUser user;
//   ProfileScreen({super.key, required this.user});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   String fToken = '';
//   XFile? imageXFile;
//   File? _pickedImage;
//   Uint8List webImage = Uint8List(8);

//   Future<void> _getImage() async {
//     final ImagePicker picker = ImagePicker();
//     imageXFile = await picker.pickImage(source: ImageSource.gallery);
//     if (imageXFile != null) {
//       if (!kIsWeb) {
//         var selected = File(imageXFile!.path);
//         setState(() {
//           _pickedImage = selected;
//         });
//       } else {
//         var f = await imageXFile!.readAsBytes();
//         setState(() {
//           webImage = f;
//           _pickedImage = File('a'); // Not sure why you're creating a dummy file here
//         });
//       }
//     } else {
//       print('No image selected');
//     }
//   }

//   final _formKey = GlobalKey<FormState>();
//   TextEditingController nameController = TextEditingController();
//   TextEditingController aboutController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     nameController.text = widget.user.name;
//     aboutController.text = widget.user.about;
//   }

//   Future<void> _showEditDialog(String field) async {
//     TextEditingController controller = field == 'name' ? nameController : aboutController;
//     return showDialog<void>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Edit ${field[0].toUpperCase() + field.substring(1)}'),
//           content: TextField(
//             controller: controller,
//             decoration: InputDecoration(
//               hintText: 'Enter new $field',
//             ),
//             autofocus: true,
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             TextButton(
//               child: Text('Save'),
//               onPressed: () {
//                 if (field == 'name') {
//                   widget.user.name = nameController.text;
//                 } else {
//                   widget.user.about = aboutController.text;
//                 }
//                 APIs.updateUserInfo(name: widget.user.name, about: widget.user.about).then((_) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       backgroundColor: Colors.blue,
//                       content: Text('Details Updated successfully'),
//                     ),
//                   );
//                   Navigator.of(context).pop();
//                   setState(() {});
//                 }).catchError((e) {
//                   print('Error updating user info: $e');
//                 });
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => FocusScope.of(context).unfocus(),
//       child: Scaffold(
//         appBar: AppBar(
//           foregroundColor: Colors.white,
//           backgroundColor: Colors.blue,
//           centerTitle: true,
//           title: const Text("My Profile", style: TextStyle(color: Colors.white)),
//         ),
//         body: SingleChildScrollView(
//           child: Padding(
//             padding: EdgeInsets.symmetric(
//               horizontal: MediaQuery.of(context).size.width * 0.15,
//               vertical: MediaQuery.of(context).size.height * 0.2,
//             ),
//             child: Column(
//               children: [
//                 InkWell(
//                   onTap: _getImage,
//                   child: kIsWeb
//                       ? CircleAvatar(
//                           radius: kIsWeb ? 70 : MediaQuery.of(context).size.width * 0.20,
//                           backgroundColor: Colors.grey,
//                           backgroundImage: MemoryImage(webImage),
//                           child: imageXFile == null
//                               ? Container(
//                                   height: 100,
//                                   width: 100,
//                                   decoration: BoxDecoration(
//                                     color: Colors.blue,
//                                     borderRadius: BorderRadius.circular(50),
//                                   ),
//                                 )
//                               : null,
//                         )
//                       : CircleAvatar(
//                           radius: kIsWeb ? 70 : MediaQuery.of(context).size.width * 0.20,
//                           backgroundColor: Colors.white,
//                           backgroundImage: imageXFile == null
//                               ? null
//                               : FileImage(File(imageXFile!.path)),
//                           child: imageXFile == null
//                               ? Container(
//                                   height: 100,
//                                   width: 100,
//                                   decoration: BoxDecoration(
//                                     color: Colors.blue,
//                                     borderRadius: BorderRadius.circular(50),
//                                   ),
//                                 )
//                               : null,
//                         ),
//                 ),
//                 const SizedBox(height: 20),
//                 Text('Email: ${widget.user.email}', style: const TextStyle(fontSize: 16)),
//                 const SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         Icon(Icons.person_outline),
//                         SizedBox(width: 8),
//                         Text(widget.user.name),
//                       ],
//                     ),
//                     IconButton(
//                       icon: Icon(Icons.edit, color: Colors.blue),
//                       onPressed: () => _showEditDialog('name'),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         Icon(Icons.info_outline),
//                         SizedBox(width: 8),
//                         Text(widget.user.about),
//                       ],
//                     ),
//                     IconButton(
//                       icon: Icon(Icons.edit, color: Colors.blue),
//                       onPressed: () => _showEditDialog('about'),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//                   onPressed: () {
//                     if (_formKey.currentState?.validate() ?? false) {
//                       APIs.updateUserInfo(name: nameController.text, about: aboutController.text).then((_) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             backgroundColor: Colors.blue,
//                             content: Text('Details Updated successfully'),
//                           ),
//                         );
//                       }).catchError((e) {
//                         print('Error updating user info: $e');
//                       });
//                     }
//                   },
//                   child: const Text("Update", style: TextStyle(color: Colors.white)),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         floatingActionButton: FloatingActionButton.extended(
//           backgroundColor: Colors.blue,
//           onPressed: () {
//             Navigator.push(context, MaterialPageRoute(builder: (context) => LoginForm()));
//             APIs.auth.signOut();
//           },
//           label: const Text("Logout", style: TextStyle(color: Colors.white)),
//           icon: const Icon(Icons.logout, color: Colors.white),
//         ),
//       ),
//     );
//   }
// }



class ProfileScreen extends StatefulWidget {
  final ChatUser user;
  ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String fToken = '';
  XFile? imageXFile;
  File? _pickedImage;
  Uint8List webImage = Uint8List(8);
  late String profileImageUrl;

  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController aboutController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.user.name;
    aboutController.text = widget.user.about;
    profileImageUrl = widget.user.image ?? ''; // Initialize profileImageUrl
  }

 /*  Future<void> _getImage() async {
    final ImagePicker picker = ImagePicker();
    imageXFile = await picker.pickImage(source: ImageSource.gallery);
    if (imageXFile != null) {
      if (!kIsWeb) {
        var selected = File(imageXFile!.path);
        setState(() {
          _pickedImage = selected;
        });
        // Upload the image and update Firestore
        await APIs.updateProfilePicture(selected);
        setState(() {
          profileImageUrl = imageXFile!.path; // Update the profile image URL
        });
      } else {
        var f = await imageXFile!.readAsBytes();
        setState(() {
          webImage = f;
          _pickedImage = File('a');
           // Not used here, just for web case
        });
      }
    } else {
      print('No image selected');
    }
  } */
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
      
      // Update the profile picture URL in the Firestore user document
      await APIs.updateProfilePicture(downloadURL);
      
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
        print("image picked");
      });
    }
    
  } else {
    print('No image selected');
  }
}


  Future<void> _showEditDialog(String field) async {
    TextEditingController controller = field == 'name' ? nameController : aboutController;
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit ${field[0].toUpperCase() + field.substring(1)}'),
          content: TextField(
            controller: controller,
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
                if (field == 'name') {
                  widget.user.name = nameController.text;
                } else {
                  widget.user.about = aboutController.text;
                }
                APIs.updateUserInfo(name: widget.user.name, about: widget.user.about).then((_) {
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue,
          centerTitle: true,
          title: const Text("My Profile", style: TextStyle(color: Colors.white)),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.15,
              vertical: MediaQuery.of(context).size.height * 0.2,
            ),
            child: Column(
              children: [
                InkWell(
                  onTap: _getImage,
               
                  
                  child: kIsWeb
                      ? CircleAvatar(
                          radius: kIsWeb ? 70 : MediaQuery.of(context).size.width * 0.20,
                          backgroundColor: Colors.grey,
                          backgroundImage: webImage.isNotEmpty
                              ? MemoryImage(webImage)
                              : null,
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
                          radius: kIsWeb ? 70 : MediaQuery.of(context).size.width * 0.20,
                          backgroundColor: Colors.white,
                          backgroundImage: profileImageUrl.isNotEmpty
                              ? NetworkImage(profileImageUrl)
                              : null,
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
                const SizedBox(height: 20),
                Text('Email: ${widget.user.email}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.person_outline),
                        SizedBox(width: 8),
                        Text(widget.user.name),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _showEditDialog('name'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline),
                        SizedBox(width: 8),
                        Text(widget.user.about),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _showEditDialog('about'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      APIs.updateUserInfo(name: nameController.text, about: aboutController.text).then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.blue,
                            content: Text('Details Updated successfully'),
                          ),
                        );
                      }).catchError((e) {
                        print('Error updating user info: $e');
                      });
                    }
                  },
                  child: const Text("Update", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.blue,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginForm()));
            APIs.auth.signOut();
          },
          label: const Text("Logout", style: TextStyle(color: Colors.white)),
          icon: const Icon(Icons.logout, color: Colors.white),
        ),
      ),
    );
  }
}
