/// username : ""
/// phone : ""
/// email : ""
/// profileImageUrl : ""

 class MyUser {
  MyUser({
      String? username, 
      String? phone, 
      String? email, 
      String? profileImageUrl,
      String? userId,
  }){
    _username = username;
    _phone = phone;
    _email = email;
    _profileImageUrl = profileImageUrl;
     _userId = userId;
}

  MyUser.fromJson(dynamic json) {
    _username = json['username'];
    _phone = json['phone'];
    _email = json['email'];
    _profileImageUrl = json['profileImageUrl'];
    _userId = json['userId'];
  }
  String? _username;
  String? _phone;
  String? _email;
  String? _profileImageUrl;
  String? _userId;
  String? get username => _username;
  String? get phone => _phone;
  String? get email => _email;
  String? get profileImageUrl => _profileImageUrl;
  String? get userId => _userId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['username'] = _username;
    map['phone'] = _phone;
    map['email'] = _email;
    map['profileImageUrl'] = _profileImageUrl;
    map['userId'] = _userId;
    return map;
  }

}