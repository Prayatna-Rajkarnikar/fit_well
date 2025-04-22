class UserModel {
  final String id;
  final String username;
  final String email;
  final int footstep;
  final int consumedcalorie;
  final int totalcalorie;
  final int time;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.footstep,
    required this.consumedcalorie,
    required this.totalcalorie,
    required this.time,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor to create a User object from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      footstep: json["footstep"] ?? 0, // Default to 0
      consumedcalorie: json["consumedcalorie"] ?? 0,
      totalcalorie: json["totalcalorie"] ?? 0,
      time: json["time"] ?? 0,
      createdAt: json["createdAt"] != null
          ? DateTime.parse(json["createdAt"])
          : DateTime.now(),
      updatedAt: json["updatedAt"] != null
          ? DateTime.parse(json["updatedAt"])
          : DateTime.now(), // Parse updatedAt
    );
  }

// Convert User object to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'username': username,
      'email': email,
      "footstep": footstep,
      "consumedcalorie": consumedcalorie,
      "totalcalorie": totalcalorie,
      "time": time,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt":
      updatedAt.toIso8601String(), // Convert updatedAt to ISO string
    };
  }
}
