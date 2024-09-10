import 'package:flutter/material.dart';
import 'package:we_chat_app/API/apis.dart';
import 'package:we_chat_app/mainscreens/groupchat_room.dart';
import 'package:we_chat_app/models/groupmodell.dart';
import 'package:we_chat_app/models/groupmsgmodel.dart';
import 'package:we_chat_app/helper/my_date_util.dart';

class GroupCard extends StatefulWidget {
  final GroupModel group;

  const GroupCard({super.key, required this.group});

  @override
  State<GroupCard> createState() => _GroupCardState();
}

class _GroupCardState extends State<GroupCard> {
  GroupMessages? _lastMessage;
  String _lastMessageSender = '';

  @override
  Widget build(BuildContext context) {
    return Card(
      child: StreamBuilder(
        stream: APIs.getLastGroupMessage(widget.group.id),
        builder: (context, snapshot) {
          final data = snapshot.data?.docs;
          final list = data?.map((e) => GroupMessages.fromJson(e.data())).toList() ?? [];
          if (list.isNotEmpty) {
            _lastMessage = list[0];
            _fetchSenderUsername(_lastMessage!.fromId);
          }

          return ListTile(
            leading: widget.group.profilephoto.isNotEmpty ? InkWell(onTap: (){
              _showImageDialog(context, widget.group.profilephoto);
              

            },child: CircleAvatar( 
                radius:30 ,
                backgroundImage: NetworkImage(widget.group.profilephoto),
              ),
            ):  Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.blue,
              ),
              child: Center(
                child: Text(
                  widget.group.name[0].toUpperCase(),
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),),
               title: Text(widget.group.name),
               subtitle: Text(
              _lastMessage != null
                  ? '$_lastMessageSender: ${_lastMessage!.msg}'
                  : '',
              maxLines: 1,
            ),
            trailing:  _lastMessage != null ?
              Text(MyDateUtil.getLastMessageTime(context: context, time: _lastMessage!.sent)):SizedBox(),
              onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GroupChatScreen(group: widget.group),
                ),);}
           /*  leading: widget.group.profilephoto.isNotEmpty ? InkWell(
              onTap: (){
                _showImageDialog(context, widget.group.profilephoto);
              },
              child: CircleAvatar( 
                radius:30 ,
                backgroundImage: NetworkImage(widget.group.profilephoto),
              ),
            ):
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.blue,
              ),
              child: Center(
                child: Text(
                  widget.group.name[0].toUpperCase(),
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
            title: Text(widget.group.name),
            subtitle: Text(
              _lastMessage != null
                  ? '$_lastMessageSender: ${_lastMessage!.msg}'
                  : '',
              maxLines: 1,
            ),
            trailing: 
            _lastMessage == null
                ? null
                : !_lastMessage!.read.contains(APIs.user.uid) && _lastMessage!.fromId != APIs.user.uid
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
                          Text(MyDateUtil.getLastMessageTime(context: context, time: _lastMessage!.sent)),
                        ],
                      ):
                     Text(MyDateUtil.getLastMessageTime(context: context, time: _lastMessage!.sent)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GroupChatScreen(group: widget.group),
                ),
              );
            }, */
          );
        },
      ),
    );
  }

  void _fetchSenderUsername(String userId) async {
    final username = await APIs.getUsername(userId);
    setState(() {
      _lastMessageSender = username;
    });
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
