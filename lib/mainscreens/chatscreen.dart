

import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'dart:html' as html;
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image_picker/image_picker.dart';
import 'package:printing/printing.dart';
import 'package:we_chat_app/API/apis.dart';
import 'package:we_chat_app/mainscreens/viewprofile.dart';
import 'package:we_chat_app/models/message_model.dart';
import 'package:we_chat_app/models/usermodel.dart';
import 'package:we_chat_app/widgets/message_design.dart';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;



class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String fToken = '';
  XFile? imageXFile;
  File? _pickedImage;
  Uint8List webImage = Uint8List(8);
  
  Future<void> _getImage() async {
  final ImagePicker picker = ImagePicker();
  imageXFile = await picker.pickImage(source: ImageSource.gallery);

 if (imageXFile != null) {
    if (!kIsWeb) {
      var selected = File(imageXFile!.path);
      setState(() {
        _pickedImage = selected;
      });

      try {
        await APIs.sendChatImage(widget.user, imageXFile!);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image sent successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send image: $e')),
        );
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
        var storageRef = FirebaseStorage.instance.ref().child('images').child(fileName);
        await storageRef.putData(webImage);
        
        // Get the download URL
        String downloadURL = await storageRef.getDownloadURL();
        
        // Update the profile picture URL in the Firestore user document
        await APIs.sendMessages(widget.user, downloadURL, MessageType.image);
        
       
      } catch (e) {
        print('Failed to upload image: $e');
      }
    }
  } else {
    print('No image selected');
  }
}

  bool _showEmoji = false;
  List<Messages> _list = [];
  TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();
 
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      
      child: Scaffold(
        appBar: AppBar(
          
          foregroundColor: Colors.white,
          automaticallyImplyLeading: false,
          elevation: 0, // Remove shadow
          
          backgroundColor: Colors.transparent, // Make background transparent
          flexibleSpace: Container(
            decoration:const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.blue],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: InkWell(onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> ViewProfile(user: widget.user)));
            },
              child: Row(
                children: [SizedBox(width:10),
                   widget.user.image != null && widget.user.image.isNotEmpty ? 
                CircleAvatar( 
                  radius: 25,
                  backgroundImage: NetworkImage(widget.user.image),
                ):
                  Container(
                    width: 40,
                    height: 40,
                    margin: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Text(
                        widget.user.name[0].toUpperCase(),
                        style: const TextStyle(color: Colors.blue, fontSize: 20),
                      ),
                    ),
                  ),
                  const  SizedBox(width:30),
                  Expanded(
                    child: StreamBuilder(
                      stream: APIs.getUserInfo(widget.user),
                      builder: (context, snapshot) {
                        final data = snapshot.data?.docs;
                        final list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.user.name,
                              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            // Text(
                            //   list.isNotEmpty
                            //       ? widget.user.isonline ? 'Online' : widget.user.about
                            //       : widget.user.about,
                            //   style: const TextStyle(color: Colors.white70, fontSize: 14),
                            // ),
                          ],
                        );
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                   IconButton(onPressed: (){
              downloadPdf(widget.user);
            }, icon: Icon(Icons.download))
                ],
              ),
            ),
          ),
        ),
       
        body:Column( children: [ 
         
          Flexible(child:
          StreamBuilder(
            
            stream:APIs.getAllMessages(widget.user),
            
            builder: (context, snapshot) {
              
              switch(snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                 return const Center(child: CircularProgressIndicator());
        
                case ConnectionState.active:
                case ConnectionState.done:
              
               final data = snapshot.data?.docs;
               _list = data?.map((e) => Messages.fromJson(e.data())).toList() ?? [];
               
               if(_list.isNotEmpty) {
                  return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: _list.length ,
                itemBuilder: (context,index) {
                  return MessageCard(messages: _list[index]);
              
              });
               }else {
                return const Text("say Hi",
                style: TextStyle(fontSize: 35),);
               }
              }
             
            }
          ),
              )
        
           
              ,Padding(
              padding: const EdgeInsets.all(8.0),
              child: widget.user.isBlocked ? Container():
              Row(

                
                children: [
                  IconButton(onPressed: (){
                    setState(() {
                      _showEmoji = !_showEmoji;
                    });
        
                  }, icon:const Icon(Icons.emoji_emotions)),
               InkWell(
                  onTap: () {
                   _getImage();
                  },
                  child:const Icon(Icons.camera_alt)),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration:const InputDecoration(
                        hintText: 'Enter your message...',
                      ),
                      onTap:(){
                        if(_showEmoji)  setState(() {
                          _showEmoji = !_showEmoji;
                        });
                      }
                    ),
                  ),
                  IconButton(
                    icon:const Icon(Icons.send),
                    onPressed: () async {
                      print("Dssss");
                      try {
                      if(_controller.text.isNotEmpty) {
                       await APIs.sendMessages(widget.user, _controller.text, MessageType.text).then((value) => print("something"));
                        _controller.clear();
                      
                      }}catch(e){
                          print(e);
                      } },
                  ),
                ],
              ),
            ),
            if(_showEmoji)
          SizedBox(
            height:MediaQuery.of(context).size.height*0.5,
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
          config:const Config(
           emojiViewConfig: EmojiViewConfig(
        // Try different values if updating Flutter doesn't help
        emojiSizeMax:28.0,
          ),
        )
        
          ),
        
        )],)
      ),
    );
  }

  void _showBottomsheet() {
    showModalBottomSheet(
     
      context: context,
       builder:(context) {
        return Container(
          child:  Row( 
            children: [ 
              TextButton(onPressed: (){

              }, child:const Card( child: Center(child: Text("Choose from Gallery"),),)),
               TextButton(onPressed: (){

              }, child:const Card( child: Center(child: Text("Choose from Camera"),),))
            ],
          ),
        );
       });
  }
  
  Future<Uint8List> generatePdf(ChatUser user) async {
    final pdf = pw.Document();
    Uint8List? profileImageBytes;

  // Load the font
  final fontData = await rootBundle.load('assets/NotoSans-Regular.ttf');
  final ttf = pw.Font.ttf(fontData);

  try {
    final response = await http.get(Uri.parse(user.image));
    if (response.statusCode == 200) {
      profileImageBytes = response.bodyBytes;
    } else {
      print('Failed to load profile image, status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Exception caught while loading profile image: $e');
  }
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('User Details', style: pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 16),
               if (profileImageBytes != null)
                pw.Image(pw.MemoryImage(profileImageBytes)),
              pw.Text('Name: ${user.name}'),
              pw.Text('Email: ${user.email}'),
              pw.Text('About: ${user.about}'),
              pw.Text('Created At: ${user.createdAt}'),
              pw.Text('ID: ${user.id}'),
              pw.Text('Image: ${user.image}'),
              pw.Text('Is Online: ${user.isonline}'),
              pw.Text('Last Active: ${user.lastActive}'),
              pw.Text('Push Token: ${user.pushToken}'),
              pw.Text('Is Blocked: ${user.isBlocked}'),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  void downloadPdf(ChatUser user) async {
    final pdfData = await generatePdf(user);
    final blob = html.Blob([pdfData], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', 'user_details.pdf')
      ..click();
    html.Url.revokeObjectUrl(url);
  }
}