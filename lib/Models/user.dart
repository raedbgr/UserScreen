import 'dart:io';

class Eluser {
  String? name;
  int? age;
  File? pic;
  String? date;

  Eluser({
    this.name = "N/A",
    this.age = 0,
    this.pic = null,
    this.date = "N/A",
  });

  factory Eluser.fromJson(Map<String, dynamic> json) {
    return Eluser(
      name: json['name'],
      age: json['age'],
      pic: json['pic'] != null ? File(json['pic']) : null,
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
      'pic': pic != null ? pic!.path : null,
      'date': date,
    };
  }

  void updateName(String newName) {
    name = newName;
  }

  void updateAge(int newAge) {
    age = newAge;
  }

  void updatePic(File newPic) {
   if(newPic!= null) pic = newPic;
  }
}
