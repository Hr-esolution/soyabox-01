class ReservationModel {
  int? id;
  int? userId;
  String? name;
  String? phone;
  String? city; // Nouvelle propriété
  DateTime? reservationDate;
  String? reservationTime;
  int? numberOfPersons;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  ReservationModel({
    this.id,
    this.userId,
    this.name,
    this.phone,
    this.city, // Initialisation de la nouvelle propriété
    this.reservationDate,
    this.reservationTime,
    this.numberOfPersons,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  // Factory constructor to create an instance from JSON
  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    return ReservationModel(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      phone: json['phone'],
      city: json['city'], // Ajout de la ville dans fromJson
      reservationTime: json['reservation_time'],
      numberOfPersons: json['number_of_persons'],
      status: json['status'],
      reservationDate: json['reservation_date'] != null
          ? DateTime.parse(json['reservation_date'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  // Method to convert the instance back to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'phone': phone,
      'city': city, // Ajout de la ville dans toJson
      'reservation_date': reservationDate?.toIso8601String(),
      'reservation_time': reservationTime,
      'number_of_persons': numberOfPersons,
      'status': status,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
