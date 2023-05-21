import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  static const String keyTopScore = 'top_score';

  static Future<int> getTopScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(keyTopScore) ?? 0;
  }

  static Future<void> saveTopScore(int topScore) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(keyTopScore, topScore);
  }
}
