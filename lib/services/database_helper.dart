import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/sentence.dart';
import '../models/ai_cache.dart';
import '../models/conversation_history.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'duorecall.db');

    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE sentences (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        chinese_text TEXT NOT NULL,
        english_text TEXT NOT NULL,
        scene TEXT NOT NULL,
        tense TEXT NOT NULL,
        import_time TEXT NOT NULL,
        source_time TEXT,
        image_path TEXT,
        ocr_confidence REAL,
        retry_count INTEGER DEFAULT 0,
        review_count INTEGER DEFAULT 0,
        hint_count INTEGER DEFAULT 0,
        error_count INTEGER DEFAULT 0,
        last_review_time TEXT,
        is_mastered INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE ai_cache (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        sentence_id INTEGER NOT NULL,
        cache_type TEXT NOT NULL,
        content TEXT NOT NULL,
        created_at TEXT NOT NULL,
        is_expired INTEGER DEFAULT 0,
        FOREIGN KEY (sentence_id) REFERENCES sentences (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE conversation_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        sentence_id INTEGER NOT NULL,
        question TEXT NOT NULL,
        answer TEXT NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY (sentence_id) REFERENCES sentences (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE settings (
        key TEXT PRIMARY KEY,
        value TEXT
      )
    ''');

    await db.execute('''
      CREATE INDEX idx_sentences_scene ON sentences(scene)
    ''');

    await db.execute('''
      CREATE INDEX idx_sentences_tense ON sentences(tense)
    ''');

    await db.execute('''
      CREATE INDEX idx_sentences_import_time ON sentences(import_time)
    ''');

    await db.execute('''
      CREATE INDEX idx_ai_cache_sentence_id ON ai_cache(sentence_id)
    ''');

    await db.execute('''
      CREATE INDEX idx_conversation_sentence_id ON conversation_history(sentence_id)
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // 版本2：补充缺失的时态数据
      await _migrateTenseData(db);
    }
  }

  /// 迁移时态数据 - 为现有数据补充时态
  Future<void> _migrateTenseData(Database db) async {
    // 获取所有时态为空或默认值的记录
    final maps = await db.query(
      'sentences',
      where: 'tense IS NULL OR tense = ? OR tense = ?',
      whereArgs: ['', 'simple_present'],
    );

    for (final map in maps) {
      final id = map['id'] as int;
      final englishText = map['english_text'] as String;

      // 根据英文句子推断时态
      final tense = _detectTense(englishText);

      await db.update(
        'sentences',
        {'tense': tense},
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  }

  /// 根据英文句子检测时态
  String _detectTense(String englishText) {
    final text = englishText.toLowerCase().trim();

    // 现在完成进行时: have/has been + doing
    if (RegExp(r'\b(have|has)\s+been\s+\w+ing\b').hasMatch(text)) {
      return 'present_perfect_continuous';
    }
    // 过去完成进行时: had been + doing
    if (RegExp(r'\bhad\s+been\s+\w+ing\b').hasMatch(text)) {
      return 'past_perfect_continuous';
    }
    // 将来完成进行时: will have been + doing
    if (RegExp(r'\bwill\s+have\s+been\s+\w+ing\b').hasMatch(text)) {
      return 'future_perfect_continuous';
    }
    // 过去完成时: had + done
    if (RegExp(r'\bhad\s+\w+ed\b').hasMatch(text) ||
        RegExp(
          r'\bhad\s+(been|gone|come|seen|done|taken|made)\b',
        ).hasMatch(text)) {
      return 'past_perfect';
    }
    // 现在完成时: have/has + done
    if (RegExp(r'\b(have|has)\s+\w+ed\b').hasMatch(text) ||
        RegExp(
          r'\b(have|has)\s+(been|gone|come|seen|done|taken|made)\b',
        ).hasMatch(text)) {
      return 'present_perfect';
    }
    // 将来完成时: will have + done
    if (RegExp(r'\bwill\s+have\s+\w+ed\b').hasMatch(text)) {
      return 'future_perfect';
    }
    // 过去进行时: was/were + doing
    if (RegExp(r'\b(was|were)\s+\w+ing\b').hasMatch(text)) {
      return 'past_continuous';
    }
    // 现在进行时: am/is/are + doing
    if (RegExp(r'\b(am|is|are)\s+\w+ing\b').hasMatch(text)) {
      return 'present_continuous';
    }
    // 将来进行时: will be + doing
    if (RegExp(r'\bwill\s+be\s+\w+ing\b').hasMatch(text)) {
      return 'future_continuous';
    }
    // 一般过去时: 过去式动词或 did
    if (RegExp(
          r'\b(did|was|were|had|went|came|saw|took|made|got|found|thought|said|came|went|had|did|got|made|found|took|saw|came|went|knew|thought|told|felt|became|left|put|meant|kept|let|began|seemed|helped|showed|heard|played|ran|moved|lived|believed|brought|happened|stood|lost|paid|met|included|continued|set|learned|changed|led|understood|watched|followed|stopped|created|spoke|read|spent|grew|opened|walked|offered|remembered|loved|considered|appeared|bought|waited|served|died|sent|expected|built|stayed|fell|cut|reached|killed|remained)\b',
        ).hasMatch(text) ||
        RegExp(r'\w+ed\b').hasMatch(text)) {
      return 'simple_past';
    }
    // 一般将来时: will 或 be going to
    if (RegExp(r'\bwill\b').hasMatch(text) ||
        RegExp(r'\b(am|is|are)\s+going\s+to\b').hasMatch(text)) {
      return 'simple_future';
    }
    // 默认：一般现在时
    return 'simple_present';
  }

  Future<int> insertSentence(Sentence sentence) async {
    final db = await database;
    return await db.insert('sentences', sentence.toMap());
  }

  Future<List<int>> insertSentences(List<Sentence> sentences) async {
    final db = await database;
    final ids = <int>[];

    await db.transaction((txn) async {
      for (final sentence in sentences) {
        final id = await txn.insert('sentences', sentence.toMap());
        ids.add(id);
      }
    });

    return ids;
  }

  Future<Sentence?> getSentence(int id) async {
    final db = await database;
    final maps = await db.query('sentences', where: 'id = ?', whereArgs: [id]);

    if (maps.isNotEmpty) {
      return Sentence.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Sentence>> getAllSentences({int? limit, int? offset}) async {
    final db = await database;
    final maps = await db.query(
      'sentences',
      orderBy: 'import_time DESC',
      limit: limit,
      offset: offset,
    );

    return maps.map((map) => Sentence.fromMap(map)).toList();
  }

  Future<List<Sentence>> getSentencesByScene(
    String scene, {
    int? limit,
    int? offset,
  }) async {
    final db = await database;
    final maps = await db.query(
      'sentences',
      where: 'scene = ?',
      whereArgs: [scene],
      orderBy: 'import_time DESC',
      limit: limit,
      offset: offset,
    );

    return maps.map((map) => Sentence.fromMap(map)).toList();
  }

  Future<List<Sentence>> getSentencesByTense(
    String tense, {
    int? limit,
    int? offset,
  }) async {
    final db = await database;
    final maps = await db.query(
      'sentences',
      where: 'tense = ?',
      whereArgs: [tense],
      orderBy: 'import_time DESC',
      limit: limit,
      offset: offset,
    );

    return maps.map((map) => Sentence.fromMap(map)).toList();
  }

  Future<List<Sentence>> getSentencesByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final db = await database;
    final maps = await db.query(
      'sentences',
      where: 'source_time >= ? AND source_time <= ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
      orderBy: 'source_time DESC',
    );

    return maps.map((map) => Sentence.fromMap(map)).toList();
  }

  Future<List<Sentence>> searchSentences(String query) async {
    final db = await database;
    final maps = await db.query(
      'sentences',
      where: 'chinese_text LIKE ? OR english_text LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'import_time DESC',
    );

    return maps.map((map) => Sentence.fromMap(map)).toList();
  }

  Future<int> updateSentence(Sentence sentence) async {
    final db = await database;
    return await db.update(
      'sentences',
      sentence.toMap(),
      where: 'id = ?',
      whereArgs: [sentence.id],
    );
  }

  Future<int> deleteSentence(int id) async {
    final db = await database;
    return await db.delete('sentences', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteAllSentences() async {
    final db = await database;
    return await db.delete('sentences');
  }

  Future<int> getSentenceCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM sentences');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> getSentenceCountByScene(String scene) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM sentences WHERE scene = ?',
      [scene],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> getSentenceCountByTense(String tense) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM sentences WHERE tense = ?',
      [tense],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> getReviewedTodayCount() async {
    final db = await database;
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM sentences WHERE last_review_time >= ?',
      [startOfDay.toIso8601String()],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> getMasteredCount() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM sentences WHERE is_mastered = 1',
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> insertAiCache(AiCache cache) async {
    final db = await database;
    return await db.insert('ai_cache', cache.toMap());
  }

  Future<AiCache?> getAiCache(int sentenceId, String cacheType) async {
    final db = await database;
    final maps = await db.query(
      'ai_cache',
      where: 'sentence_id = ? AND cache_type = ?',
      whereArgs: [sentenceId, cacheType],
      orderBy: 'created_at DESC',
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return AiCache.fromMap(maps.first);
    }
    return null;
  }

  Future<int> deleteExpiredAiCache() async {
    final db = await database;
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    return await db.delete(
      'ai_cache',
      where: 'cache_type = ? AND created_at < ?',
      whereArgs: [AiCache.typeFollowUp, sevenDaysAgo.toIso8601String()],
    );
  }

  Future<int> insertConversationHistory(ConversationHistory history) async {
    final db = await database;
    return await db.insert('conversation_history', history.toMap());
  }

  Future<List<ConversationHistory>> getConversationHistory(
    int sentenceId,
  ) async {
    final db = await database;
    final maps = await db.query(
      'conversation_history',
      where: 'sentence_id = ?',
      whereArgs: [sentenceId],
      orderBy: 'created_at ASC',
    );

    return maps.map((map) => ConversationHistory.fromMap(map)).toList();
  }

  Future<int> deleteConversationHistory(int sentenceId) async {
    final db = await database;
    return await db.delete(
      'conversation_history',
      where: 'sentence_id = ?',
      whereArgs: [sentenceId],
    );
  }

  Future<String?> getSetting(String key) async {
    final db = await database;
    final maps = await db.query('settings', where: 'key = ?', whereArgs: [key]);

    if (maps.isNotEmpty) {
      return maps.first['value'] as String?;
    }
    return null;
  }

  Future<int> setSetting(String key, String value) async {
    final db = await database;
    return await db.insert('settings', {
      'key': key,
      'value': value,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }
}
