import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/product.dart';
import '../models/invoice.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('gst_billing.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE products (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        price REAL NOT NULL,
        gstRate REAL NOT NULL,
        description TEXT,
        barcode TEXT,
        category TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE invoices (
        id TEXT PRIMARY KEY,
        date TEXT NOT NULL,
        totalAmount REAL NOT NULL,
        totalGST REAL NOT NULL,
        items TEXT NOT NULL
      )
    ''');
  }

  // Product operations
  Future<String> insertProduct(Product product) async {
    final db = await database;
    await db.insert('products', product.toJson());
    return product.id;
  }

  Future<List<Product>> getAllProducts() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('products');
    return List.generate(maps.length, (i) => Product.fromJson(maps[i]));
  }

  Future<Product?> getProduct(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return Product.fromJson(maps.first);
  }

  Future<int> updateProduct(Product product) async {
    final db = await database;
    return db.update(
      'products',
      product.toJson(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  Future<int> deleteProduct(String id) async {
    final db = await database;
    return db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Invoice operations
  Future<String> insertInvoice(Invoice invoice) async {
    final db = await database;
    await db.insert('invoices', invoice.toJson());
    return invoice.id;
  }

  Future<List<Invoice>> getAllInvoices() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('invoices');
    return List.generate(maps.length, (i) => Invoice.fromJson(maps[i]));
  }

  Future<Invoice?> getInvoice(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'invoices',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return Invoice.fromJson(maps.first);
  }

  Future<List<Invoice>> getInvoicesByDateRange(DateTime start, DateTime end) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'invoices',
      where: 'date BETWEEN ? AND ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
    );
    return List.generate(maps.length, (i) => Invoice.fromJson(maps[i]));
  }
} 