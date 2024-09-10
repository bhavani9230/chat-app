// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:we_chat_app/API/apis.dart';
// import 'package:we_chat_app/helper/my_date_util.dart';

// import 'package:fast_cached_network_image/fast_cached_network_image.dart';
// import 'package:we_chat_app/models/groupmsgmodel.dart';

// class GroupMessageCard extends StatefulWidget {
//   const GroupMessageCard({super.key, required this.groupMessage});
//   final GroupMessages  groupMessage;

//   @override
//   State<GroupMessageCard> createState() => _GroupMessageCardState();
// }

// class _GroupMessageCardState extends State<GroupMessageCard> {
//   final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

//   @override
//   Widget build(BuildContext context) {
//     bool isMe = APIs.user.uid == widget.groupMessage.fromId;
//     return InkWell(
//       onLongPress: () {
//         _showBottomsheet(isMe);
//       },
//       child: isMe ? _greenMessage() : _blueMessage(),
//     );
//   }

//   Widget _blueMessage() {
//     if (widget.groupMessage.read.isEmpty) {
//       // APIs.updateGroupMessageReadStatus(widget.groupMessage);
//     }
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: [
//         Flexible(
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.blue[100],
//               borderRadius: BorderRadius.circular(12),
//             ),
//             padding: const EdgeInsets.all(12),
//             margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//             child: widget.groupMessage.type == GroupMessageType.text
//                 ? _buildMessageContent(widget.groupMessage.msg)
//                 : ClipRRect(
//                     borderRadius: BorderRadius.circular(12),
//                     child: FastCachedImage(
//                       url: widget.groupMessage.msg,
//                       errorBuilder: (context, error, stackTrace) => Icon(Icons.error, color: Colors.red),
//                     ),
//                   ),
//           ),
//         ),
//         SizedBox(width: 8),
//         Text(
//           MyDateUtil.getFormattedTime(context: context, time: widget.groupMessage.sent),
//           style: TextStyle(color: Colors.grey[600]),
//         ),
//       ],
//     );
//   }

//   Widget _greenMessage() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         if (widget.groupMessage.read.isNotEmpty)
//           Icon(Icons.done_all, color: Colors.blue, size: 20),
//         SizedBox(width: 4),
//         Flexible(
//           child: Container(
//             decoration: BoxDecoration(
//               color: Colors.green[100],
//               borderRadius: BorderRadius.circular(12),
//             ),
//             padding: const EdgeInsets.all(12),
//             margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//             child:Column(children: [ 
//               Text
              
//                 widget.groupMessage.type == GroupMessageType.text
//                 ? _buildMessageContent(widget.groupMessage.msg)
//                 : ClipRRect(
//                     borderRadius: BorderRadius.circular(12),
//                     child: FastCachedImage(
//                       url: widget.groupMessage.msg,
//                       errorBuilder: (context, error, stackTrace) => Icon(Icons.error, color: Colors.red),
//                     ),
//                   ),

//             ],)
           
//           ),
//         ),
//         SizedBox(width: 8),
//         Text(
//           MyDateUtil.getFormattedTime(context: context, time: widget.groupMessage.sent),
//           style: TextStyle(color: Colors.grey[600]),
//         ),
//       ],
//     );
//   }

//   Widget _buildMessageContent(String msg) {
//     final urlRegExp = RegExp(
//       r'((https?:\/\/)?(www\.)?[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}(\/[^\s]*)?)',
//       caseSensitive: false,
//     );

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
//             style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
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
//         style: TextStyle(color: Colors.black87),
//         children: textSpans,
//       ),
//     );
//   }

//   void _showBottomsheet(bool isMe) {
//     showModalBottomSheet(
//       context: context,
//       builder: (_) {
//         return Container(
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//           ),
//           child: ListView(
//             shrinkWrap: true,
//             children: [
//               SizedBox(height: 8),
//               Divider(color: Colors.grey[300], thickness: 2),
//               widget.groupMessage.type == GroupMessageType.text
//                   ? OptionalItem(
//                       icon: Icons.copy,
//                       name: "Copy Text",
//                       onTap: () async {
//                         await Clipboard.setData(ClipboardData(text: widget.groupMessage.msg)).then((_) {
//                           Navigator.pop(context);
//                         });
//                       },
//                     )
//                   : OptionalItem(
//                       icon: Icons.download,
//                       name: "Save Image",
//                       onTap: () {
//                         // Handle image save functionality
//                       },
//                     ),
//               Divider(color: Colors.grey[300]),
//               if (widget.groupMessage.type == GroupMessageType.text && isMe)
//                 OptionalItem(
//                   icon: Icons.edit,
//                   name: "Edit",
//                   onTap: () {
//                     Navigator.pop(context);
//                     // _showDialog();
//                   },
//                 ),
//               Divider(color: Colors.grey[300]),
//               OptionalItem(
//                 icon: Icons.delete,
//                 name: "Delete",
//                 onTap: () {
//                   APIs.deleteGroupMessage(widget.groupMessage).then((_) {
//                     Navigator.pop(context);
//                   });
//                 },
//               ),
//               Divider(color: Colors.grey[300]),
//               // OptionalItem(
//               //   icon: Icons.remove_red_eye,
//               //   name: "Send At: ${MyDateUtil.getLastMessageTime(context: context, time: widget.groupMessage.sent)}",
//               //   onTap: () {},
//               // ),
//               // Divider(color: Colors.grey[300]),
//               // OptionalItem(
//               //   icon: Icons.remove_red_eye,
//               //   name: widget.groupMessage.read.isEmpty
//               //       ? "Read At: Not seen yet"
//               //       : "Read At: ${MyDateUtil.getFormattedTime(context: context, time: widget.groupMessage.read)}",
//               //   onTap: () {},
//               // ),
//               SizedBox(height: 16),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   // void _showDialog() {
//   //   String updateMsg = widget.groupMessage.msg;
//   //   WidgetsBinding.instance.addPostFrameCallback((_) {
//   //     showDialog(
//   //       context: context,
//   //       builder: (context) {
//   //         return AlertDialog(
//   //           title: const Text("Update Message"),
//   //           content: SizedBox(
//   //             height: MediaQuery.of(context).size.height * 0.3,
//   //             child: Column(
//   //               mainAxisSize: MainAxisSize.min,
//   //               children: [
//   //                 TextFormField(
//   //                   onChanged: (value) => updateMsg = value,
//   //                   maxLines: null,
//   //                   initialValue: updateMsg,
//   //                   decoration: InputDecoration(
//   //                     border: OutlineInputBorder(
//   //                       borderSide: BorderSide(color: Colors.blue),
//   //                     ),
//   //                     focusedBorder: OutlineInputBorder(
//   //                       borderSide: BorderSide(color: Colors.blue),
//   //                     ),
//   //                   ),
//   //                 ),
//   //               ],
//   //             ),
//   //           ),
//   //           actions: [
//   //             ElevatedButton(
//   //               style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//   //               onPressed: () {
//   //                 Navigator.pop(context);
//   //               },
//   //               child: Text("Cancel", style: TextStyle(color: Colors.white)),
//   //             ),
//   //             ElevatedButton(
//   //               style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
//   //               onPressed: () {
//   //                 APIs.UpdateGroupMessage(widget.groupMessage, updateMsg);
//   //                 Navigator.pop(context);
//   //               },
//   //               child: Text("Update", style: TextStyle(color: Colors.white)),
//   //             ),
//   //           ],
//   //         );
//   //       },
//   //     );
//   //   });
//   // }

// }

// class OptionalItem extends StatelessWidget {
//   final IconData? icon;
//   final String? name;
//   final VoidCallback? onTap;

//   OptionalItem({super.key, this.icon, this.name, this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         if (onTap != null) {
//           onTap!();
//         }
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//         child: Row(
//           children: [
//             Icon(icon, color: Colors.black54),
//             SizedBox(width: 12),
//             Expanded(child: Text(name ?? '', style: TextStyle(color: Colors.black87))),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver_updated/gallery_saver.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:we_chat_app/API/apis.dart';
import 'package:we_chat_app/helper/my_date_util.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:we_chat_app/models/groupmsgmodel.dart';
import 'package:we_chat_app/widgets/image.dart';

class GroupMessageCard extends StatefulWidget {
  const GroupMessageCard({super.key, required this.groupMessage});
  final GroupMessages groupMessage;

  @override
  State<GroupMessageCard> createState() => _GroupMessageCardState();
}

class _GroupMessageCardState extends State<GroupMessageCard> {
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  String? senderName;
  String? senderphoto;

  @override
  void initState() {
    super.initState();
    _fetchSenderName();
  }

  Future<void> _fetchSenderName() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.groupMessage.fromId)
          .get();
      if (userDoc.exists) {
        setState(() {
          senderName = userDoc['name'] ?? 'Unknown';
          senderphoto = userDoc['image'];
        });
      }
    } catch (e) {
      print('Error fetching sender name: $e');
      setState(() {
        senderName = 'Unknown';
        senderphoto = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isMe = APIs.user.uid == widget.groupMessage.fromId;
    return InkWell(
      onLongPress: () {
        _showBottomsheet(isMe);
      },
      child: isMe ? _greenMessage() : _blueMessage(),
    );
  }

  Widget _blueMessage() {
    if (widget.groupMessage.read.isEmpty) {
      // APIs.updateGroupMessageReadStatus(widget.groupMessage);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          child: Row(
            children: [
              senderphoto != null && senderphoto!.isNotEmpty
                  ? CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(senderphoto!),
                    )
                  : Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue,
                      ),
                      child: Center(
                        child: Text(
                          senderName != null ? senderName![0].toUpperCase() : '?',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (senderName != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          senderName!,
                          style: const TextStyle(
                            color: Color.fromARGB(136, 230, 33, 33),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    widget.groupMessage.type == GroupMessageType.text
                        ? _buildMessageContent(widget.groupMessage.msg)
                        :_buildImageMessage(widget.groupMessage.msg),
                    const SizedBox(height: 4),
                    Text(
                      MyDateUtil.getFormattedTime(context: context, time: widget.groupMessage.sent),
                      style: TextStyle(color: Colors.grey[600], fontSize: 8),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  Widget _greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (widget.groupMessage.read.isNotEmpty)
          Icon(Icons.done_all, color: Colors.blue, size: 20),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("You",style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),),
                widget.groupMessage.type == GroupMessageType.text
                    ? _buildMessageContent(widget.groupMessage.msg)
                    : _buildImageMessage(widget.groupMessage.msg),
                SizedBox(height: 4),
                Text(
                  MyDateUtil.getFormattedTime(context: context, time: widget.groupMessage.sent),
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 8),
      ],
    );
  }
   Widget _buildImageMessage(String imageUrl) {
    return InkWell(onTap: (){
      Navigator.push(context,MaterialPageRoute(builder: (context)=> FullImage(ImageUrl: imageUrl)));
    },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            imageUrl,
            width: 200,
            height: 200,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 8),
         ]),
    );
}

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
        style: TextStyle(color: Colors.black87,fontSize: 15),
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
              SizedBox(height: 8),
              Divider(color: Colors.grey[300], thickness: 2),
              widget.groupMessage.type == GroupMessageType.text
                  ? OptionalItem(
                      icon: Icons.copy,
                      name: "Copy Text",
                      onTap: () async {
                        await Clipboard.setData(ClipboardData(text: widget.groupMessage.msg)).then((_) {
                          Navigator.pop(context);
                        });
                      },
                    ):SizedBox(),
                  // : OptionalItem(
                  //     icon: Icons.download,
                  //     name: "Save Image",
                  //     onTap: () {
                  //       GallerySaver.saveImage(widget.groupMessage.msg).then((success) {
    
                  //    print('Image is saved');
                  //    Navigator.pop(context);
      
                  //     });
                  //     },
                  //   ),
              Divider(color: Colors.grey[300]),
              if (widget.groupMessage.type == GroupMessageType.text && isMe)
                OptionalItem(
                  icon: Icons.edit,
                  name: "Edit",
                  onTap: () {
                    Navigator.pop(context);
                    _showDialog();
                  },
                ),
              Divider(color: Colors.grey[300]),
              OptionalItem(
                icon: Icons.delete,
                name: "Delete",
                onTap: () {
                  APIs.deleteGroupMessage(widget.groupMessage).then((_) {
                    Navigator.pop(context);
                  });
                },
              ),
              Divider(color: Colors.grey[300]),
             
              SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
  void _showDialog() {
    String updateMsg = widget.groupMessage.msg;
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
                  APIs.updateGroupMessage(widget.groupMessage, updateMsg);
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
   

}

class OptionalItem extends StatelessWidget {
  final IconData? icon;
  final String? name;
  final VoidCallback? onTap;

  OptionalItem({super.key, this.icon, this.name, this.onTap});

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
