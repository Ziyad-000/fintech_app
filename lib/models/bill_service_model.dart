import 'package:equatable/equatable.dart';

class BillFieldModel extends Equatable {
  final String key;
  final String label;
  final String placeholder;
  final String type; // e.g., "text", "number"

  const BillFieldModel({
    required this.key,
    required this.label,
    required this.placeholder,
    this.type = 'text',
  });

  @override
  List<Object?> get props => [
        key,
        label,
        placeholder,
        type,
      ];
}

class BillServiceModel extends Equatable {
  final String id;
  final String name;
  final String emoji;
  final String colorTheme;
  final List<BillFieldModel> fields;

  const BillServiceModel({
    required this.id,
    required this.name,
    required this.emoji,
    required this.colorTheme,
    required this.fields,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        emoji,
        colorTheme,
        fields,
      ];
}

const List<BillServiceModel> mockBillServices = [
  BillServiceModel(
    id: "internet",
    name: "Internet",
    emoji: "🌐",
    colorTheme: "bg-blue-500/20 text-blue-400",
    fields: [
      BillFieldModel(key: "provider", label: "Provider", placeholder: "e.g. Comcast, AT&T"),
      BillFieldModel(key: "accountNumber", label: "Account Number", placeholder: "Enter account number"),
    ],
  ),
  BillServiceModel(
    id: "electricity",
    name: "Electricity",
    emoji: "⚡",
    colorTheme: "bg-yellow-500/20 text-yellow-400",
    fields: [
      BillFieldModel(key: "meterNumber", label: "Meter Number", placeholder: "Enter meter number"),
      BillFieldModel(key: "units", label: "Units (kWh)", placeholder: "Enter units consumed", type: "number"),
    ],
  ),
  BillServiceModel(
    id: "mobile",
    name: "Mobile Recharge",
    emoji: "📱",
    colorTheme: "bg-emerald-500/20 text-emerald-400",
    fields: [
      BillFieldModel(key: "phoneNumber", label: "Phone Number", placeholder: "+1 (555) 000-0000"),
      BillFieldModel(key: "carrier", label: "Carrier", placeholder: "e.g. Verizon, T-Mobile"),
    ],
  ),
  BillServiceModel(
    id: "water",
    name: "Water",
    emoji: "💧",
    colorTheme: "bg-cyan-500/20 text-cyan-400",
    fields: [
      BillFieldModel(key: "accountNumber", label: "Account Number", placeholder: "Enter account number"),
    ],
  ),
  BillServiceModel(
    id: "tv",
    name: "TV / Cable",
    emoji: "📺",
    colorTheme: "bg-purple-500/20 text-purple-400",
    fields: [
      BillFieldModel(key: "subscriberId", label: "Subscriber ID", placeholder: "Enter subscriber ID"),
      BillFieldModel(key: "provider", label: "Provider", placeholder: "e.g. DirecTV, Xfinity"),
    ],
  ),
  BillServiceModel(
    id: "insurance",
    name: "Insurance",
    emoji: "🛡️",
    colorTheme: "bg-rose-500/20 text-rose-400",
    fields: [
      BillFieldModel(key: "policyNumber", label: "Policy Number", placeholder: "Enter policy number"),
      BillFieldModel(key: "provider", label: "Provider", placeholder: "e.g. State Farm, Allstate"),
    ],
  ),
];

