import 'package:equatable/equatable.dart';

class WalletModel extends Equatable {
  final double balance;
  final String cardNumberLast4;
  final String cardExpiry;
  final String currency;

  const WalletModel({
    required this.balance,
    required this.cardNumberLast4,
    required this.cardExpiry,
    required this.currency,
  });

  @override
  List<Object?> get props => [
        balance,
        cardNumberLast4,
        cardExpiry,
        currency,
      ];
}
