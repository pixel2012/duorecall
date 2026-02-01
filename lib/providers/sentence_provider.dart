import 'package:flutter/material.dart';
import '../models/sentence.dart';
import '../services/database_helper.dart';

class SentenceProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper();

  List<Sentence> _sentences = [];
  List<Sentence> _filteredSentences = [];
  String _searchQuery = '';
  String? _selectedScene;
  String? _selectedTense;
  String _sortBy = 'import_time_desc';

  List<Sentence> get sentences => _searchQuery.isEmpty && _selectedScene == null && _selectedTense == null
      ? _sentences
      : _filteredSentences;

  String get searchQuery => _searchQuery;
  String? get selectedScene => _selectedScene;
  String? get selectedTense => _selectedTense;
  String get sortBy => _sortBy;

  Future<void> loadSentences({int? limit, int? offset}) async {
    _sentences = await _db.getAllSentences(limit: limit, offset: offset);
    _applyFilters();
    notifyListeners();
  }

  Future<void> search(String query) async {
    _searchQuery = query;
    if (query.isEmpty) {
      _filteredSentences = _sentences;
    } else {
      _filteredSentences = await _db.searchSentences(query);
    }
    notifyListeners();
  }

  void filterByScene(String? scene) {
    _selectedScene = scene;
    _applyFilters();
    notifyListeners();
  }

  void filterByTense(String? tense) {
    _selectedTense = tense;
    _applyFilters();
    notifyListeners();
  }

  void setSortBy(String sort) {
    _sortBy = sort;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    var result = List<Sentence>.from(_sentences);

    if (_searchQuery.isNotEmpty) {
      result = result.where((s) =>
          s.chineseText.contains(_searchQuery) ||
          s.englishText.contains(_searchQuery)).toList();
    }

    if (_selectedScene != null) {
      result = result.where((s) => s.scene == _selectedScene).toList();
    }

    if (_selectedTense != null) {
      result = result.where((s) => s.tense == _selectedTense).toList();
    }

    switch (_sortBy) {
      case 'import_time_desc':
        result.sort((a, b) => b.importTime.compareTo(a.importTime));
        break;
      case 'import_time_asc':
        result.sort((a, b) => a.importTime.compareTo(b.importTime));
        break;
      case 'review_count_desc':
        result.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
        break;
      case 'error_count_desc':
        result.sort((a, b) => b.errorCount.compareTo(a.errorCount));
        break;
    }

    _filteredSentences = result;
  }

  Future<void> addSentence(Sentence sentence) async {
    await _db.insertSentence(sentence);
    await loadSentences();
  }

  Future<void> addSentences(List<Sentence> sentences) async {
    await _db.insertSentences(sentences);
    await loadSentences();
  }

  Future<void> updateSentence(Sentence sentence) async {
    await _db.updateSentence(sentence);
    await loadSentences();
  }

  Future<void> deleteSentence(int id) async {
    await _db.deleteSentence(id);
    await loadSentences();
  }

  Future<void> deleteAllSentences() async {
    await _db.deleteAllSentences();
    await loadSentences();
  }

  Future<Sentence?> getSentence(int id) async {
    return await _db.getSentence(id);
  }

  Future<void> incrementReviewCount(int id) async {
    final sentence = await _db.getSentence(id);
    if (sentence != null) {
      await _db.updateSentence(sentence.copyWith(
        reviewCount: sentence.reviewCount + 1,
        lastReviewTime: DateTime.now(),
      ));
      await loadSentences();
    }
  }

  Future<void> incrementErrorCount(int id) async {
    final sentence = await _db.getSentence(id);
    if (sentence != null) {
      await _db.updateSentence(sentence.copyWith(
        errorCount: sentence.errorCount + 1,
      ));
      await loadSentences();
    }
  }

  Future<void> incrementHintCount(int id) async {
    final sentence = await _db.getSentence(id);
    if (sentence != null) {
      await _db.updateSentence(sentence.copyWith(
        hintCount: sentence.hintCount + 1,
      ));
      await loadSentences();
    }
  }

  Future<void> markAsMastered(int id, bool mastered) async {
    final sentence = await _db.getSentence(id);
    if (sentence != null) {
      await _db.updateSentence(sentence.copyWith(isMastered: mastered));
      await loadSentences();
    }
  }

  Future<List<Sentence>> getSentencesByScene(String scene) async {
    return await _db.getSentencesByScene(scene);
  }

  Future<List<Sentence>> getSentencesByTense(String tense) async {
    return await _db.getSentencesByTense(tense);
  }

  Future<int> getCountByScene(String scene) async {
    return await _db.getSentenceCountByScene(scene);
  }

  Future<int> getCountByTense(String tense) async {
    return await _db.getSentenceCountByTense(tense);
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedScene = null;
    _selectedTense = null;
    _filteredSentences = _sentences;
    notifyListeners();
  }
}
