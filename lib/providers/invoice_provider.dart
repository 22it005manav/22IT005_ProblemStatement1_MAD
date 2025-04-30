import 'package:flutter/foundation.dart';
import '../models/invoice.dart';
import '../models/cart_item.dart';
import '../db/database_helper.dart';

class InvoiceProvider with ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper.instance;
  List<Invoice> _invoices = [];
  List<Invoice> _filteredInvoices = [];
  String _searchQuery = '';
  DateTime? _startDate;
  DateTime? _endDate;

  List<Invoice> get invoices => _filteredInvoices;
  String get searchQuery => _searchQuery;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;

  Future<void> loadInvoices() async {
    if (_startDate != null && _endDate != null) {
      _invoices = await _db.getInvoicesByDateRange(_startDate!, _endDate!);
    } else {
      _invoices = await _db.getAllInvoices();
    }
    _filterInvoices();
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _filterInvoices();
    notifyListeners();
  }

  void setDateRange(DateTime? start, DateTime? end) {
    _startDate = start;
    _endDate = end;
    loadInvoices();
  }

  void _filterInvoices() {
    if (_searchQuery.isEmpty) {
      _filteredInvoices = List.from(_invoices);
    } else {
      _filteredInvoices = _invoices
          .where((invoice) =>
              invoice.id.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              invoice.date.toString().contains(_searchQuery))
          .toList();
    }
  }

  Future<void> addInvoice(List<CartItem> items, double totalAmount, double totalGST) async {
    final invoice = Invoice(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now(),
      items: items,
      totalAmount: totalAmount,
      totalGST: totalGST,
    );
    await _db.insertInvoice(invoice);
    await loadInvoices();
  }

  Future<Invoice?> getInvoiceById(String id) async {
    return await _db.getInvoice(id);
  }

  void clearFilters() {
    _searchQuery = '';
    _startDate = null;
    _endDate = null;
    loadInvoices();
  }
} 