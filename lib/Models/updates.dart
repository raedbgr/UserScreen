class updateMod {
  int? userId;
  String? msg;
  String? date;

  updateMod({
    this.userId,
    this.msg,
    this.date,
  });

  // Json convert
  factory updateMod.fromJson(Map<String, dynamic> json) {
    return updateMod(
      userId: json['userId'],
      msg: json['msg'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'msg': msg,
      'date': date,
    };
  }
}
