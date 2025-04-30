import 'package:flutter/foundation.dart';
import '../models/product.dart';
import '../db/database_helper.dart';

class ProductProvider with ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper.instance;
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  String _searchQuery = '';

  List<Product> get products => _filteredProducts;
  String get searchQuery => _searchQuery;

  Future<void> loadProducts() async {
    _products = await _db.getAllProducts();
    _filterProducts();
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _filterProducts();
    notifyListeners();
  }

  void _filterProducts() {
    if (_searchQuery.isEmpty) {
      _filteredProducts = List.from(_products);
    } else {
      _filteredProducts = _products
          .where((product) =>
              product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              (product.barcode?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false))
          .toList();
    }
  }

  Future<void> addProduct(Product product) async {
    await _db.insertProduct(product);
    await loadProducts();
  }

  Future<void> updateProduct(Product product) async {
    await _db.updateProduct(product);
    await loadProducts();
  }

  Future<void> deleteProduct(String id) async {
    await _db.deleteProduct(id);
    await loadProducts();
  }

  Product? getProductById(String id) {
    try {
      return _products.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }
} 