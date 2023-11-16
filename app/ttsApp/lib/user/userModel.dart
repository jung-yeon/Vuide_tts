class User{
  String email;
  String pwd;
  String name;
  String phone;
  DateTime joinDate;
  String type;
  String adminYn;

  User(this.email,
        this.pwd,
        this.name,
        this.phone,
        this.joinDate,
        this.type,
        this.adminYn
      );
  User.fromJson(Map<String, dynamic> json)
      : email = json["mem_email"],
        pwd = json["mem_pwd"],
        name = json["mem_name"],
        phone = json["phone"],
        joinDate = json["joinDate"],
        type = json["mem_type"],
        adminYn = json["adminYn"];

}

