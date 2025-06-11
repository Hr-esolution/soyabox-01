class UserModel {
  int? id;
  String? name;
  String? phone;
  String? address;

  UserModel({
    this.id,
    this.name,
    this.phone,
    this.address,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      address:
          json['address'] as String?, // Ensure 'address' is handled if present
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['phone'] = phone;

    return data;
  }
}
