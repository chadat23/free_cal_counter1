import 'package:free_cal_counter1/config/emoji_map.dart';

String? emojiForFoodName(String foodName) {
  final lowerCaseFoodName = foodName.toLowerCase();
  for (final entry in foodEmojiMap.entries) {
    if (lowerCaseFoodName.contains(entry.key)) {
      return entry.value;
    }
  }
  return null;
}
