class RegisterModel {
  String? ic;
  String? name;
  String? mobileNo;
  String? password;
  String? email;
  String? gender;

  RegisterModel(
      {this.ic,
      this.name,
      this.mobileNo,
      this.password,
      this.email,
      this.gender});

  // RegisterModel.fromJson(Map<String, dynamic> json) {
  //   ic = json['ic'];
  //   name = json['name'];
  //   password = json['password'];
  //   mobileNo = json['mobileNo'];
  // }

  // Map<String, dynamic> toJson() {
  //   Map<String, dynamic> data = <String, dynamic>{};
  //   data['ic'] = ic;
  //   data['name'] = name;
  //   data['language'] = language;
  //   data['mobileNo'] = mobileNo;
  //   return data;
  // }
}
