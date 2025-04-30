class Product {
  final String id;
  final String name;
  final double price;
  final double gstRate; // GST rate in percentage (5, 12, 18, or 28)
  final String? description;
  final String? barcode;
  final String? category;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.gstRate,
    this.description,
    this.barcode,
    this.category,
  });

  // Calculate CGST (half of GST rate)
  double get cgst => (price * gstRate) / 200;

  // Calculate SGST (half of GST rate)
  double get sgst => (price * gstRate) / 200;

  // Calculate total price including GST
  double get totalPrice => price + cgst + sgst;

  // Create a copy of the product with modified fields
  Product copyWith({
    String? id,
    String? name,
    double? price,
    double? gstRate,
    String? description,
    String? barcode,
    String? category,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      gstRate: gstRate ?? this.gstRate,
      description: description ?? this.description,
      barcode: barcode ?? this.barcode,
      category: category ?? this.category,
    );
  }

  // Convert product to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'gstRate': gstRate,
      'description': description,
      'barcode': barcode,
      'category': category,
    };
  }

  // Create product from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      gstRate: (json['gstRate'] as num).toDouble(),
      description: json['description'] as String?,
      barcode: json['barcode'] as String?,
      category: json['category'] as String?,
    );
  }
} 