// enum GroupMessageType { text, image, system }

// class GroupMessages {
//   String msg;
//   String fromId;
//   String toId;
//   String sent;
//   List<String> read;
//   GroupMessageType type;

//   GroupMessages({
//     required this.msg,
//     required this.fromId,
//     required this.toId,
//     required this.sent,
//     required this.read,
//     required this.type,
//   });

//   factory GroupMessages.fromJson(Map<String, dynamic> json) {
//     return GroupMessages(
//       msg: json['msg'],
//       fromId: json['fromId'],
//       toId: json['toId'],
//       sent: json['sent'],
//       read: List<String>.from(json['read']),
//       type: json['type'] == 'text' ? GroupMessageType.text : GroupMessageType.image,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'msg': msg,
//       'fromId': fromId,
//       'toId': toId,
//       'sent': sent,
//       'read': read,
//       'type': type == GroupMessageType.text ? 'text' : 'image',
//     };
//   }
// }


enum GroupMessageType { text, image, system }

class GroupMessages {
  String msg;
  String fromId;
  String toId;
  String sent;
  List<String> read;
  GroupMessageType type;

  GroupMessages({
    required this.msg,
    required this.fromId,
    required this.toId,
    required this.sent,
    required this.read,
    required this.type,
  });

  factory GroupMessages.fromJson(Map<String, dynamic> json) {
    return GroupMessages(
      msg: json['msg'] as String,
      fromId: json['fromId'] as String,
      toId: json['toId']as String,
      sent: json['sent']as String,
      read: List<String>.from(json['read']),
      type: _getTypeFromString(json['type']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'msg': msg,
      'fromId': fromId,
      'toId': toId,
      'sent': sent,
      'read': read,
      'type': _getStringFromType(type),
    };
  }

  static GroupMessageType _getTypeFromString(String type) {
    switch (type) {
      case 'text':
        return GroupMessageType.text;
      case 'image':
        return GroupMessageType.image;
      case 'system':
        return GroupMessageType.system;
      default:
        throw Exception('Unknown message type');
    }
  }

  static String _getStringFromType(GroupMessageType type) {
    switch (type) {
      case GroupMessageType.text:
        return 'text';
      case GroupMessageType.image:
        return 'image';
      case GroupMessageType.system:
        return 'system';
      default:
        throw Exception('Unknown message type');
    }
  }
}

