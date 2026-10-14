import 'package:equatable/equatable.dart';

class ContactModel extends Equatable {
  final String id;
  final String name;
  final String handle;
  final String initials;
  final String colorHex;

  const ContactModel({
    required this.id,
    required this.name,
    required this.handle,
    required this.initials,
    required this.colorHex,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        handle,
        initials,
        colorHex,
      ];
}
