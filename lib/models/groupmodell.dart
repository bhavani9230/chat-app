class GroupModel {
  GroupModel({
    required this.about,
    required this.id,
    required this.name,
    required this.profilephoto,
    required this.members,
    required this.admin,
    this.allowMessaging,
  });
  late String about;
  late  String id;
  late  String name;
  late  String profilephoto;
  late List<String> members;
  late String admin;
  late bool? allowMessaging;
  
  GroupModel.fromJson(Map<String, dynamic> json){
    about = json['about'] as String;
    id = json['id']as String;
    name = json['name']as String;
    profilephoto = json['profilephoto']as String;
    members = List<String>.from(json['members']);
    admin = json['admin']as String;
    allowMessaging = json['allowMessaging'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['about'] = about;
    data['id'] = id;
    data['name'] = name;
    data['profilephoto'] = profilephoto;
    data['members'] = members;
    data['admin'] =  admin;
    data['allowMessaging'] = allowMessaging;
    return data;
  }
}