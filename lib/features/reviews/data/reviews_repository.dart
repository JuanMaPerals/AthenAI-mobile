import '../domain/review_case.dart';

/// Repository for managing review cases
/// Currently in-memory only - will be persisted with SharedPreferences
class ReviewsRepository {
  final List<ReviewCase> _cases = [];
  final int _maxCases = 20; // Keep last 20 cases

  /// Get all review cases, sorted by date (newest first)
  List<ReviewCase> getAllCases() {
    final sortedCases = List<ReviewCase>.from(_cases);
    sortedCases.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sortedCases;
  }

  /// Get recent cases (up to specified limit)
  List<ReviewCase> getRecentCases({int limit = 5}) {
    final all = getAllCases();
    return all.take(limit).toList();
  }

  /// Get a specific case by ID
  ReviewCase? getCaseById(String id) {
    try {
      return _cases.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Add a new review case
  void addCase(ReviewCase reviewCase) {
    _cases.add(reviewCase);

    // Keep only the most recent cases to avoid unbounded growth
    if (_cases.length > _maxCases) {
      // Sort by date and remove oldest
      _cases.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      _cases.removeRange(_maxCases, _cases.length);
    }

    // TODO: Persist to SharedPreferences
    // _saveToStorage();
  }

  /// Delete a case by ID
  void deleteCase(String id) {
    _cases.removeWhere((c) => c.id == id);
    // TODO: Persist to SharedPreferences
    // _saveToStorage();
  }

  /// Clear all cases
  void clearAll() {
    _cases.clear();
    // TODO: Persist to SharedPreferences
    // _saveToStorage();
  }

  // TODO: Implement persistence methods when shared_preferences is approved
  /*
  Future<void> _saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final casesJson = _cases.map((c) => c.toJson()).toList();
    await prefs.setString('review_cases', jsonEncode(casesJson));
  }

  Future<void> _loadFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final casesStr = prefs.getString('review_cases');
    if (casesStr != null) {
      final casesJson = jsonDecode(casesStr) as List<dynamic>;
      _cases.clear();
      _cases.addAll(
        casesJson.map((json) => ReviewCase.fromJson(json as Map<String, dynamic>)),
      );
    }
  }
  */
}
