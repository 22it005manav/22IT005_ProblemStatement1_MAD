import 'dart:convert';
import 'cart_item.dart';

class Invoice {
  final String id;
  final DateTime date;
  final List<CartItem> items;
  final double totalAmount;
  final double totalGST;

  Invoice({
    required this.id,
    required this.date,
    required this.items,
    required this.totalAmount,
    required this.totalGST,
  });

  // Calculate CGST (half of total GST)
  double get cgst => totalGST / 2;

  // Calculate SGST (half of total GST)
  double get sgst => totalGST / 2;

  // Convert invoice to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'items': jsonEncode(items.map((item) => item.toJson()).toList()),
      'totalAmount': totalAmount,
      'totalGST': totalGST,
    };
  }

  // Create invoice from JSON
  factory Invoice.fromJson(Map<String, dynamic> json) {
    final List<dynamic> itemsJson = jsonDecode(json['items'] as String);
    final items = itemsJson
        .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
        .toList();

    return Invoice(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      items: items,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      totalGST: (json['totalGST'] as num).toDouble(),
    );
  }

  // Create a copy of the invoice with modified fields
  Invoice copyWith({
    String? id,
    DateTime? date,
    List<CartItem>? items,
    double? totalAmount,
    double? totalGST,
  }) {
    return Invoice(
      id: id ?? this.id,
      date: date ?? this.date,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      totalGST: totalGST ?? this.totalGST,
    );
  }
} 