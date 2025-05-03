class UserModel {
  final String id;
  final String name;
  final String email;
  final double weightKg;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.weightKg,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["_id"],
      name: json["name"],
      email: json["email"],
      weightKg: json["weightKg"].toDouble(),
    );
  }
}
