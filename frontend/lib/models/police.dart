import 'dart:convert';

class Police {
  String? policename;
  String? password;

  Police({this.policename, this.password});

  Map<String, dynamic> toMap() {
    return {
      'policename': policename,
      'password': password,
    };
  }

  factory Police.fromJson(Map<String, dynamic> json) {
    return Police(
      policename: json['policename'],
      password: json['password'],
    );
  }
}

Police userFromJson(String str) => Police.fromJson(json.decode(str));