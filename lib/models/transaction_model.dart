import 'package:equatable/equatable.dart';

enum TransactionType {
  income,
  expense,
}

enum TransactionStatus {
  success,
  pending,
  failed,
}

class TransactionModel extends Equatable {
  final String id;
  final String title;
  final String category;
  final TransactionType type;
  final double amount;
  final DateTime date;
  final TransactionStatus status;
  final String iconOrEmoji;

  const TransactionModel({
    required this.id,
    required this.title,
    required this.category,
    required this.type,
    required this.amount,
    required this.date,
    required this.status,
    required this.iconOrEmoji,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        category,
        type,
        amount,
        date,
        status,
        iconOrEmoji,
      ];
}
