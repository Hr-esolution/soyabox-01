class SignUpBody {
  String name;
  String password;
  String phone;

  SignUpBody({
    required this.name,
    required this.phone,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["name"] = name;
    data["password"] = password;
    data["phone"] = phone;
    return data;
  }
}
