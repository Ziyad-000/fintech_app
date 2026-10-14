import 'package:equatable/equatable.dart';

enum PaymentMethodType {
  card,
  wallet,
  bank,
}

class PaymentMethodModel extends Equatable {
  final String id;
  final String label;
  final String? last4;
  final PaymentMethodType type;
  final String emoji;

  const PaymentMethodModel({
    required this.id,
    required this.label,
    this.last4,
    required this.type,
    required this.emoji,
  });

  @override
  List<Object?> get props => [
        id,
        label,
        last4,
        type,
        emoji,
      ];
}
