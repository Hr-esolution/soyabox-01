class AddressModel {
  int? id;
  int? userId;
  String? rue;
  String? boulevard;
  String? ville;
  String? updatedAt;
  String? createdAt;

  AddressModel({
    this.id,
    this.userId,
    this.rue,
    this.boulevard,
    this.ville,
    this.updatedAt,
    this.createdAt,
  });

  AddressModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    rue = json['rue'];
    boulevard = json['boulevard'];
    ville = json['ville'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['rue'] = rue;
    data['boulevard'] = boulevard;
    data['ville'] = ville;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;

    return data;
  }

  String get fullAddress =>
      '$rue, $boulevard,$ville,';
}
