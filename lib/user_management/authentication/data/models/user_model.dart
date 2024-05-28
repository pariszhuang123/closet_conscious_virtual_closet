import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.email,
    required super.name,
    required super.id
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      name: json['name'],
      id: json['id']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'id': id
    };
  }
}
