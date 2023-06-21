
class updateMod {
  String? msg;
  String? date;

  updateMod ({
   this.msg,
   this.date,
});
  // Json convert
  factory updateMod.fromJson(Map<String, dynamic> json) {
    return updateMod(
      msg: json['msg'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'msg': msg,
      'date': date,
    };
  }
}
