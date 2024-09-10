// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:we_chat_app/API/apis.dart';
// import 'package:we_chat_app/helper/my_date_util.dart';
// import 'package:we_chat_app/models/message_model.dart';
// import 'package:fast_cached_network_image/fast_cached_network_image.dart';


// class MessageCard extends StatefulWidget {
//   const MessageCard({super.key, required this.messages});
//   final Messages messages;

//   @override
//   State<
//   MessageCard> createState() => _MessageCardState();
// }

// class _MessageCardState extends State<MessageCard> {
//   final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

//   @override
//   Widget build(BuildContext context) {
//      bool isMe = APIs.user.uid == widget.messages.fromId;
//     return InkWell(
//       onLongPress: (){
//          _showBottomsheet(isMe);
//       },
//       child: isMe ? _greenMessage() : _blueMessage());
//   }

//   Widget _blueMessage() {
   
//     if (widget.messages.read.isEmpty) {
//       APIs.updateMessageReadStatus(widget.messages);
//     }
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Flexible(
//             child: Container(
//               color: Colors.lightBlue.withOpacity(0.3),
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child:widget.messages.type == MessageType.text?   _buildMessageContent(widget.messages.msg) : ClipRRect( 
//                   borderRadius: BorderRadius.circular(20),
//                   child: Flexible(
//                     child: FastCachedImage(
                      
//                       // width: MediaQuery.of(context).size.width*0.5,
//                       // height: MediaQuery.of(context).size.height*0.5,
//                       url: widget.messages.msg,
//                       errorBuilder: (context, error, stackTrace) => Text(stackTrace.toString())),
//                   )

//                 ),
//               ),
//             ),
//           ),
//         ),
//         Text(MyDateUtil.getFormattedTime(context: context, time: widget.messages.sent))
//       ],
//     );
//   }

//   Widget _greenMessage() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Row(
//           children: [
//             widget.messages.read.isNotEmpty ? const Icon(Icons.done_all, color: Colors.blue) : SizedBox(),
//             Text(MyDateUtil.getFormattedTime(context: context, time: widget.messages.sent)),
//           ],
//         ),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Flexible(
//             child: Container(
//               color: Colors.lightGreen.withOpacity(0.3),
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child:widget.messages.type == MessageType.text?   _buildMessageContent(widget.messages.msg) : ClipRRect( 
//                   borderRadius: BorderRadius.circular(20),
//                   child: 
//                   // CachedNetworkImage(imageUrl: widget.messages.msg)
//                   Flexible(
//                     child: FastCachedImage(
                      
//                       // width: MediaQuery.of(context).size.width*0.5,
//                       // height: MediaQuery.of(context).size.height*0.5,
//                       url: widget.messages.msg,
//                       errorBuilder: (context, error, stackTrace) => Text(stackTrace.toString())),
//                   )

//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//  Widget _buildMessageContent(String msg) {
//     // Regex to find URLs in the message
//     final urlRegExp = RegExp(
//       r'((https?:\/\/)?(www\.)?[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}(\/[^\s]*)?)',
//       caseSensitive: false,
//     );

//     // Split the message into parts to detect URLs
//     final parts = msg.split(urlRegExp);
//     final matches = urlRegExp.allMatches(msg).map((m) => m.group(0)).toList();

//     List<InlineSpan> textSpans = [];
//     for (var i = 0; i < parts.length; i++) {
//       textSpans.add(TextSpan(text: parts[i]));

//       if (i < matches.length) {
//         final url = matches[i]!;
//         textSpans.add(
//           TextSpan(
//             text: url,
//             style: const TextStyle(
//                 color: Colors.blue, decoration: TextDecoration.underline),
//             recognizer: TapGestureRecognizer()
//               ..onTap = () async {
//                 String launchUrl = url.startsWith('http') ? url : 'http://$url';
//                 if (await canLaunch(launchUrl)) {
//                   await launch(launchUrl);
//                 } else {
//                   throw 'Could not launch $launchUrl';
//                 }
//               },
//           ),
//         );
//       }
//     }

//     return RichText(
//       text: TextSpan(
//         style:const TextStyle(color: Colors.black),
//         children: textSpans,
//       ),
//     );
//   }
//   void _showBottomsheet(bool isMe) {
//     showModalBottomSheet(context: context, builder:(_) {
//       return ListView( 
//         shrinkWrap: true,
//         children: [ 
//           Container( 
//             height: 10,
//             margin: EdgeInsets.all(8.0),
//             decoration: BoxDecoration( 
//               color: Colors.grey
//             ),

//           ),

//           widget.messages.type == MessageType.text ? 
//          OptionalITem(icon: Icons.copy,name: "Copy Text", onTap: () async{
//            await Clipboard.setData(ClipboardData(text:widget.messages.msg)).then((value) {
//             Navigator.pop(context);

//            });
           
//          }, ):  OptionalITem(icon: Icons.download,name: "Save Image", onTap: () {
           
//          }, ),
//          Divider(color: Colors.grey,),
//          const SizedBox(height: 20,),
//           widget.messages.type == MessageType.text && isMe? 
//          OptionalITem(icon: Icons.edit, name
//          : "Edit", onTap: (){
//           print("ds");
//           _showDialog();
//           Navigator.pop(context);
//          },): SizedBox(),
//           Divider(color: Colors.grey,),
//          const SizedBox(height: 20,),
//          OptionalITem(icon: Icons.delete, name: "Delete", onTap: ()  {
//           APIs.deleteMessage(widget.messages).then((value) {
//             Navigator.pop(context);
//            });
//          },),
//           const SizedBox(height: 20,),

//           OptionalITem(icon:Icons.remove_red_eye,name:
//            "Send At: ${MyDateUtil.getLastMessageTime(context: context, time: widget.messages.sent)}",onTap: () {
            
//           },),
//            const SizedBox(height: 20,),
           
//           OptionalITem(icon:Icons.remove_red_eye,name:
//           widget.messages.read.isEmpty ? 
//            "Read At: Not seen yet" : "Read At: ${MyDateUtil.getFormattedTime(context: context, time:widget.messages.read)}",onTap: () {
            
//           },),

//         ],
//       );

//     });
//   }

//   void _showDialog() {
//     print("fsgg");
//     String updatemsg = widget.messages.msg;
//      WidgetsBinding.instance.addPostFrameCallback((_) {
//        showDialog(
//       context: context, builder: (context) {
//       return AlertDialog( 
//         title: const Text("Update Messages"),
//         content: SizedBox(
//           height: MediaQuery.of(context).size.height*0.3,
//           child: Column(children: [ 
//            TextFormField( 
//             onChanged: (value) => updatemsg = value,
//             maxLines: null,
//             initialValue: updatemsg,
//             decoration: InputDecoration( 
//               border: OutlineInputBorder( 
//                 borderSide: BorderSide(color: Colors.blue)
//               )
//             ),
//            )
          
          
//           ],),
//         ),
//      actions: [ 
//       ElevatedButton(
//         style:ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//         onPressed: (){
//         Navigator.pop(context);

//       }, child:Text("Cancel",style: TextStyle(color: Colors.white),)),
//       ElevatedButton(
//         style:ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//         onPressed: (){
//         APIs.UpdateMessage(widget.messages, updatemsg);  
//         Navigator.pop(context);

//       }, child:Text("Update",style: TextStyle(color: Colors.white),))
//      ],
//       );

//     });

//      });  
// }
// }
// class OptionalITem extends StatelessWidget {
//   final IconData? icon;
//   final String? name;
//   final VoidCallback? onTap;
//   OptionalITem({super.key, this.icon, this.name, this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return InkWell( 
//       onTap: () {
//          if (onTap != null) {
//           onTap!();
//         }

//       },child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
        
//         children: [ 
//         Icon(icon),
//            Padding(
//              padding: const EdgeInsets.only(left: 10),
//              child: Flexible(child: Text('$name')),
//            )

//       ],),
//     );
//   }
// }


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:we_chat_app/API/apis.dart';
import 'package:we_chat_app/helper/my_date_util.dart';
import 'package:we_chat_app/models/message_model.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:we_chat_app/widgets/image.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.messages});
  final Messages messages;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    bool isMe = APIs.user.uid == widget.messages.fromId;
    return InkWell(
      onLongPress: () {
        _showBottomsheet(isMe);
      },
      child: isMe ? _greenMessage() : _blueMessage(),
    );
  }

  Widget _blueMessage() {
    if (widget.messages.read.isEmpty) {
      APIs.updateMessageReadStatus(widget.messages);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child:Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [ 
                widget.messages.type == MessageType.text
                ? _buildMessageContent(widget.messages.msg)
                :_buildImageMessage(widget.messages.msg),
                Text(
          MyDateUtil.getFormattedTime(context: context, time: widget.messages.sent),
          style: TextStyle(color: Colors.grey[600],fontSize: 8),
        ),

            ],)
           
               
          ),
        ),
        SizedBox(width: 8),
        
      ],
    );
  }

  Widget _greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        widget.messages.read.isNotEmpty ? 
          Icon(Icons.done_all, color: Colors.blue, size: 20):  Icon(Icons.done_all, color: Colors.grey, size: 20),
        SizedBox(width: 4),
        Flexible(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [ 
               widget.messages.type == MessageType.text
                ? _buildMessageContent(widget.messages.msg):_buildImageMessage(widget.messages.msg),
                Text(
          MyDateUtil.getFormattedTime(context: context, time: widget.messages.sent),
          style: TextStyle(color: Colors.grey[600],fontSize: 8),
        ),

            ],)
           
                // : ClipRRect(
                //     borderRadius: BorderRadius.circular(12),
                //     child: FastCachedImage(
                //       url: widget.messages.msg,
                //       errorBuilder: (context, error, stackTrace) => Icon(Icons.error, color: Colors.red),
                //     ),
                //   ),
          ),
        ),
      
      ],
    );
  }
//   Widget _buildImageMessage(String url) {
//   return FastCachedImage(
//     url: url,
//     errorBuilder: (context, error, stackTrace) {
//       print("Error loading image: $error");
//       print(url);
//       return Icon(Icons.error, color: Colors.red);
//     },
//     // progressIndicatorBuilder: (context, url, progress) {
//     //   return CircularProgressIndicator(value: progress.progress);
//     // },
//   );
// }

  Widget _buildMessageContent(String msg) {
    final urlRegExp = RegExp(
      r'((https?:\/\/)?(www\.)?[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}(\/[^\s]*)?)',
      caseSensitive: false,
    );

    final parts = msg.split(urlRegExp);
    final matches = urlRegExp.allMatches(msg).map((m) => m.group(0)).toList();

    List<InlineSpan> textSpans = [];
    for (var i = 0; i < parts.length; i++) {
      textSpans.add(TextSpan(text: parts[i]));

      if (i < matches.length) {
        final url = matches[i]!;
        textSpans.add(
          TextSpan(
            text: url,
            style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                String launchUrl = url.startsWith('http') ? url : 'http://$url';
                if (await canLaunch(launchUrl)) {
                  await launch(launchUrl);
                } else {
                  throw 'Could not launch $launchUrl';
                }
              },
          ),
        );
      }
    }

    return RichText(
      text: TextSpan(
        style: TextStyle(color: Colors.black87),
        children: textSpans,
      ),
    );
  }

  void _showBottomsheet(bool isMe) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return Container(
          decoration:const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: ListView(
            shrinkWrap: true,
            children: [
              const SizedBox(height: 8),
              Divider(color: Colors.grey[300], thickness: 2),
              widget.messages.type == MessageType.text
                  ? OptionalITem(
                      icon: Icons.copy,
                      name: "Copy Text",
                      onTap: () async {
                        await Clipboard.setData(ClipboardData(text: widget.messages.msg)).then((_) {
                          Navigator.pop(context);
                        });
                      },
                    )
                  : OptionalITem(
                      icon: Icons.download,
                      name: "Save Image",
                      onTap: () {
                        // Handle image save functionality
                      },
                    ),
              Divider(color: Colors.grey[300]),
              if (widget.messages.type == MessageType.text && isMe)
                OptionalITem(
                  icon: Icons.edit,
                  name: "Edit",
                  onTap: () {
                    Navigator.pop(context);
                    _showDialog();
                  },
                ),
              Divider(color: Colors.grey[300]),
              OptionalITem(
                icon: Icons.delete,
                name: "Delete",
                onTap: () {
                  APIs.deleteMessage(widget.messages).then((_) {
                    Navigator.pop(context);
                  });
                },
              ),
              Divider(color: Colors.grey[300]),
              OptionalITem(
                icon: Icons.remove_red_eye,
                name: "Send At: ${MyDateUtil.getLastMessageTime(context: context, time: widget.messages.sent)}",
                onTap: () {},
              ),
              Divider(color: Colors.grey[300]),
              OptionalITem(
                icon: Icons.remove_red_eye,
                name: widget.messages.read.isEmpty
                    ? "Read At: Not seen yet"
                    : "Read At: ${MyDateUtil.getFormattedTime(context: context, time: widget.messages.read)}",
                onTap: () {},
              ),
              SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showDialog() {
    String updateMsg = widget.messages.msg;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Update Message"),
            content: SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    onChanged: (value) => updateMsg = value,
                    maxLines: null,
                    initialValue: updateMsg,
                    decoration:const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Cancel", style: TextStyle(color: Colors.white)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () {
                  APIs.UpdateMessage(widget.messages, updateMsg);
                  Navigator.pop(context);
                },
                child: Text("Update", style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      );
    });
  }
   
   Widget _buildImageMessage(String imageUrl) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> FullImage(ImageUrl: imageUrl)));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            imageUrl!,
            width: 200,
            height: 200,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 8),
         ]),
    );
}
}
class OptionalITem extends StatelessWidget {
  final IconData? icon;
  final String? name;
  final VoidCallback? onTap;

  OptionalITem({super.key, this.icon, this.name, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            Icon(icon, color: Colors.black54),
            SizedBox(width: 12),
            Expanded(child: Text(name ?? '', style: TextStyle(color: Colors.black87))),
          ],
        ),
      ),
    );
  }
 
      
    
  }

