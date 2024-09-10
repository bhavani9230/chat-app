// class Messages {
//   Messages({
//     required this.fromId,
//     required this.toId,
//     required this.msg,
//     required this.sent,
//     required this.read,
//     required this.type,
//   });
//   late final String fromId;
//   late final String toId;
//   late final String msg;
//   late final String sent;
//   late final String read;
//   late final Type type;
  
//   Messages.fromJson(Map<String, dynamic> json){
//     fromId = json['fromId'].toString();
//     toId = json['toId'].toString();
//     msg = json['msg'].toString();
//     sent = json['sent'].toString();
//     read = json['read'].toString();
//     type = json['type'].toString() == Type.image.name ?  Type.image:Type.text;
//   }

//   Map<String, dynamic> toJson() {
//     final data = <String, dynamic>{};
//     data['fromId'] = fromId;
//     data['toId'] = toId;
//     data['msg'] = msg;
//     data['sent'] = sent;
//     data['read'] = read;
//     data['type'] = type;
//     return data;
//   }
// }
// enum MessageType { text, image }
// class Messages {
//   String fromId;
//   String toId;
//   String msg;
//   String sent;
//   String read;
//   String type;

//   Messages({
//     required this.fromId,
//     required this.toId,
//     required this.msg,
//     required this.sent,
//     required this.read,
//     required this.type,
//   });

//   factory Messages.fromJson(Map<String, dynamic> json) => Messages(
//     fromId: json['fromId'],
//     toId: json['toId'],
//     msg: json['msg'],
//     sent: json['sent'],
//     read: json['read'],
//     type: json['type'],
//   );

//   Map<String, dynamic> toJson() => {
//     'fromId': fromId,
//     'toId': toId,
//     'msg': msg,
//     'sent': sent,
//     'read': read,
//     'type': type,
//   };
// }


enum MessageType { text, image }

class Messages {
  String msg;
  String fromId;
  String toId;
  String sent;
  String read;
  MessageType type;

  Messages({
    required this.msg,
    required this.fromId,
    required this.toId,
    required this.sent,
    required this.read,
    required this.type,
  });

  factory Messages.fromJson(Map<String, dynamic> json) {
    return Messages(
      msg: json['msg'],
      fromId: json['fromId'],
      toId: json['toId'],
      sent: json['sent'],
      read: json['read'],
      type: json['type'] == 'text' ? MessageType.text : MessageType.image,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'msg': msg,
      'fromId': fromId,
      'toId': toId,
      'sent': sent,
      'read': read,
      'type': type == MessageType.text ? 'text' : 'image',
    };
  }
}
