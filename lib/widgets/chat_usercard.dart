
import 'package:flutter/material.dart';
import 'package:we_chat_app/API/apis.dart';
import 'package:we_chat_app/helper/my_date_util.dart';
import 'package:we_chat_app/mainscreens/chatscreen.dart';
import 'package:we_chat_app/models/message_model.dart';
import 'package:we_chat_app/models/usermodel.dart';


class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  Messages? _messaage;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: StreamBuilder(
        stream: APIs.getLastMessages(widget.user),
        builder: (context, snapshot) {
          final data = snapshot.data?.docs;
          final list = data?.map((e) => Messages.fromJson(e.data())).toList() ?? [];

          if (list.isNotEmpty) {
            _messaage = list[0];
          } else {
            _messaage = null; // Ensure _messaage is null if no messages
          }

          return ListTile(
            leading: widget.user.image.isEmpty
                ? Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.blue,
                    ),
                    child: Center(
                      child: Text(
                        widget.user.name[0].toUpperCase(),
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  )
                : InkWell(onTap: (){
                      _showImageDialog(context, widget.user.image);
                },
                  child: CircleAvatar(
                      radius: 30, // Adjusted radius
                      backgroundImage: widget.user.image != null ?
                       NetworkImage(widget.user.image) : null,
                      child: 
                       widget.user.image == null ? 
                      Text( widget.user.name[0].toUpperCase()) :  null
                    ),
                ),
            title: Text(widget.user.name),
            subtitle: Text(
              _messaage != null ?  _messaage!.msg : widget.user.about,
              maxLines: 1,
            ),
            trailing: _messaage == null
                ? null
                : _messaage!.read.isEmpty &&
                        _messaage!.fromId != APIs.user.uid
                    ? Column(
                        children: [
                          Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                              color: Colors.greenAccent.shade400,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          Text(
                            MyDateUtil.getLastMessageTime(
                              context: context,
                              time: _messaage!.sent,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        MyDateUtil.getLastMessageTime(
                          context: context,
                          time: _messaage!.sent,
                        ),
                      ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(user: widget.user),
              ),
            ),
          );
        },
      ),
    );
  }
  void _showImageDialog(BuildContext context, String imageUrl) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.5, // Adjust the height as needed
          child: Image.network(imageUrl, fit: BoxFit.cover), // Display the image
        ),
        actions: [
          TextButton(
            child: Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

}


/* import 'package:flutter/material.dart';
import 'package:we_chat_app/API/apis.dart';
import 'package:we_chat_app/helper/my_date_util.dart';
import 'package:we_chat_app/mainscreens/chatscreen.dart';
import 'package:we_chat_app/models/message_model.dart';
import 'package:we_chat_app/models/usermodel.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  Messages? _message;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: StreamBuilder(
        stream: APIs.getLastMessages(widget.user),
        builder: (context, snapshot) {
          final data = snapshot.data?.docs;
          final list = data?.map((e) => Messages.fromJson(e.data())).toList() ?? [];

          if (list.isNotEmpty) {
            _message = list[0];
          } else {
            _message = null; // Ensure _message is null if no messages
          }

          return ListTile(
            leading: _buildLeading(widget.user),
            title: Text(widget.user.name),
            subtitle: Text(
              _message != null ? _message!.msg : widget.user.about,
              maxLines: 1,
            ),
            trailing: _message == null
                ? null
                : _message!.read.isEmpty &&
                        _message!.fromId != APIs.user.uid
                    ? Column(
                        children: [
                          Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                              color: Colors.greenAccent.shade400,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          Text(
                            MyDateUtil.getLastMessageTime(
                              context: context,
                              time: _message!.sent,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        MyDateUtil.getLastMessageTime(
                          context: context,
                          time: _message!.sent,
                        ),
                      ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(user: widget.user),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLeading(ChatUser user) {
    if (user.image == null || user.image.isEmpty || user.image == "") {
      return Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.blue,
        ),
        child: Center(
          child: Text(
            user.name.isNotEmpty ? user.name[0].toUpperCase() : '',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      );
    } else {
      return CircleAvatar(
        radius: 30, // Adjusted radius
        backgroundImage: NetworkImage(user.image),
      );
    }
  }
}
 */