import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../features/scanning/models/scan_history_model.dart';
import '../../features/search/models/additive_model.dart';
import '../../features/profile/models/user_preferences_model.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;
  
  DatabaseService._init();
  
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('faap_scan.db');
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
  
  Future<void> initialize() async {
    await database;
  }
  
  Future<void> _createDB(Database db, int version) async {
    // Scan History Table
    await db.execute('''
      CREATE TABLE scan_history(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        barcode TEXT NOT NULL,
        product_name TEXT NOT NULL,
        brand TEXT,
        image_url TEXT,
        risk_level TEXT NOT NULL,
        harmful_additives TEXT,
        scan_date INTEGER NOT NULL,
        is_favorite INTEGER DEFAULT 0
      )
    ''');
    
    // Additives Table
    await db.execute('''
      CREATE TABLE additives(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        code TEXT NOT NULL UNIQUE,
        name TEXT NOT NULL,
        description TEXT,
        risk_level TEXT NOT NULL,
        health_impacts TEXT,
        common_products TEXT,
        alternatives TEXT
      )
    ''');
    
    // User Preferences Table
    await db.execute('''
      CREATE TABLE user_preferences(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        key TEXT NOT NULL UNIQUE,
        value TEXT NOT NULL
      )
    ''');
    
    // Avoid List Table
    await db.execute('''
      CREATE TABLE avoid_list(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        additive_code TEXT NOT NULL,
        reason TEXT,
        date_added INTEGER NOT NULL
      )
    ''');
    
    // Products Table
    await db.execute('''
      CREATE TABLE products(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        barcode TEXT NOT NULL UNIQUE,
        name TEXT NOT NULL,
        brand TEXT,
        category TEXT,
        image_url TEXT,
        ingredients TEXT,
        additives TEXT,
        nutritional_info TEXT,
        last_updated INTEGER NOT NULL
      )
    ''');
    
    // Insert sample additives data
    await _insertSampleAdditives(db);
  }
  
  Future<void> _insertSampleAdditives(Database db) async {
    final additives = [
      {
        'code': 'E102',
        'name': 'Tartrazine',
        'description': 'Yellow synthetic food dye',
        'risk_level': 'high',
        'health_impacts': 'May cause hyperactivity in children, allergic reactions',
        'common_products': 'Soft drinks, candy, processed foods',
        'alternatives': 'Turmeric, saffron'
      },
      {
        'code': 'E211',
        'name': 'Sodium Benzoate',
        'description': 'Preservative commonly used in acidic foods',
        'risk_level': 'medium',
        'health_impacts': 'May form benzene when combined with vitamin C',
        'common_products': 'Soft drinks, pickles, sauces',
        'alternatives': 'Natural preservatives like vitamin E'
      },
      {
        'code': 'E300',
        'name': 'Ascorbic Acid (Vitamin C)',
        'description': 'Natural antioxidant and preservative',
        'risk_level': 'low',
        'health_impacts': 'Generally safe, beneficial antioxidant',
        'common_products': 'Fruit juices, bread, canned foods',
        'alternatives': 'None needed - naturally occurring'
      },
      {
        'code': 'E621',
        'name': 'Monosodium Glutamate (MSG)',
        'description': 'Flavor enhancer',
        'risk_level': 'medium',
        'health_impacts': 'May cause headaches in sensitive individuals',
        'common_products': 'Processed foods, snacks, restaurant food',
        'alternatives': 'Natural umami sources like mushrooms'
      },
      {
        'code': 'E951',
        'name': 'Aspartame',
        'description': 'Artificial sweetener',
        'risk_level': 'medium',
        'health_impacts': 'Controversial, may affect metabolism',
        'common_products': 'Diet sodas, sugar-free products',
        'alternatives': 'Stevia, monk fruit sweetener'
      },
    ];
    
    for (final additive in additives) {
      await db.insert('additives', additive);
    }
  }
  
  // Scan History Operations
  Future<int> insertScanHistory(ScanHistoryModel scan) async {
    final db = await database;
    return await db.insert('scan_history', scan.toMap());
  }
  
  Future<List<ScanHistoryModel>> getScanHistory({int? limit}) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'scan_history',
      orderBy: 'scan_date DESC',
      limit: limit,
    );
    
    return List.generate(maps.length, (i) {
      return ScanHistoryModel.fromMap(maps[i]);
    });
  }
  
  Future<int> toggleFavorite(int id, bool isFavorite) async {
    final db = await database;
    return await db.update(
      'scan_history',
      {'is_favorite': isFavorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
  // Additives Operations
  Future<List<AdditiveModel>> searchAdditives(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'additives',
      where: 'code LIKE ? OR name LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
    
    return List.generate(maps.length, (i) {
      return AdditiveModel.fromMap(maps[i]);
    });
  }
  
  Future<AdditiveModel?> getAdditive(String code) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'additives',
      where: 'code = ?',
      whereArgs: [code],
      limit: 1,
    );
    
    if (maps.isNotEmpty) {
      return AdditiveModel.fromMap(maps.first);
    }
    return null;
  }
  
  // User Preferences Operations
  Future<void> setPreference(String key, String value) async {
    final db = await database;
    await db.insert(
      'user_preferences',
      {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  
  Future<String?> getPreference(String key) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'user_preferences',
      where: 'key = ?',
      whereArgs: [key],
      limit: 1,
    );
    
    if (maps.isNotEmpty) {
      return maps.first['value'] as String;
    }
    return null;
  }
  
  // Avoid List Operations
  Future<int> addToAvoidList(String additiveCode, String? reason) async {
    final db = await database;
    return await db.insert('avoid_list', {
      'additive_code': additiveCode,
      'reason': reason,
      'date_added': DateTime.now().millisecondsSinceEpoch,
    });
  }
  
  Future<int> removeFromAvoidList(String additiveCode) async {
    final db = await database;
    return await db.delete(
      'avoid_list',
      where: 'additive_code = ?',
      whereArgs: [additiveCode],
    );
  }
  
  Future<List<String>> getAvoidList() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('avoid_list');
    
    return maps.map((map) => map['additive_code'] as String).toList();
  }
  
  Future<void> close() async {
    final db = await database;
    db.close();
  }
}