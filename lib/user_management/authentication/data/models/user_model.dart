import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.email,
    required super.id
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      id: json['id']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'id': id
    };
  }
}
