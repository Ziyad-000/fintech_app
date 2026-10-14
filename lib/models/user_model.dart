import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String handle;
  final String avatarUrl;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.handle,
    required this.avatarUrl,
  });

  @override
  List<Object?> get props => [id, name, email, handle, avatarUrl];
}
