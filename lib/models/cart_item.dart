import 'product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  // Calculate subtotal for this item
  double get subtotal => product.price * quantity;

  // Calculate CGST for this item
  double get cgst => (product.price * quantity * product.gstRate) / 200;

  // Calculate SGST for this item
  double get sgst => (product.price * quantity * product.gstRate) / 200;

  // Calculate total for this item including GST
  double get total => subtotal + cgst + sgst;

  // Create a copy of the cart item with modified fields
  CartItem copyWith({
    Product? product,
    int? quantity,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  // Convert cart item to JSON
  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
    };
  }

  // Create cart item from JSON
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
    );
  }
} 