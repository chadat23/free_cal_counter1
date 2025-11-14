//import 'package:free_cal_counter1/config/emoji_map.dart';
//
//String emojiForFoodName(String foodName) {
//  if (foodName.isEmpty) {
//    return '🍴';
//  }
//
//  final lowerCaseFoodName = foodName.toLowerCase();
//  final sortedKeys = foodEmojiMap.keys.toList()
//    ..sort((a, b) => b.length.compareTo(a.length));
//
//  for (final key in sortedKeys) {
//    if (lowerCaseFoodName.contains(key)) {
//      return foodEmojiMap[key]!;
//    }
//  }
//
//  return '🍴';
//}

import 'package:free_cal_counter1/config/emoji_map.dart';

/// Returns an appropriate emoji for a given food name.
///
/// Matching priority:
/// 1. Multi-word keys are matched before single-word keys
/// 2. Longer keys take precedence within the same word count
/// 3. Ignores descriptors after commas (e.g., ", raw")
/// 4. Prefers matching the last words in the name ("milk chocolate" → 🍫)
/// 5. Avoids partial matches ("watermelon" won't match "melon")
String emojiForFoodName(String foodName) {
  if (foodName.isEmpty) {
    return '🍴';
  }

  // Clean the food name by lowercasing, trimming, and removing descriptors
  final cleanedName = _cleanFoodName(foodName);

  // Sort keys: multi-word phrases first, then longer strings first
  final sortedKeys = _getSortedKeys();

  // Split into words to enable progressive matching
  final words = cleanedName.split(RegExp(r'\s+'));

  // Try matching progressively shorter suffixes
  // Example: "milk chocolate" → try "milk chocolate", then "chocolate"
  for (int startIndex = 0; startIndex < words.length; startIndex++) {
    final phrase = words.sublist(startIndex).join(' ');

    // First, try exact match of the entire phrase
    if (foodEmojiMap.containsKey(phrase)) {
      return foodEmojiMap[phrase]!;
    }

    // Then, try word boundary match to find the key within the phrase
    // This prevents matching "melon" when "watermelon" is available
    for (final key in sortedKeys) {
      if (_hasWordBoundaryMatch(phrase, key)) {
        return foodEmojiMap[key]!;
      }
    }
  }

  return '🍴';
}

/// Cleans a food name by:
/// - Converting to lowercase
/// - Trimming whitespace
/// - Removing descriptors after commas (e.g., ", raw")
/// - Removing parenthetical content
/// - Normalizing multiple spaces
String _cleanFoodName(String foodName) {
  return foodName
      .toLowerCase()
      .trim()
      .split(',')
      .first // Take only the part before the first comma
      .trim()
      .replaceAll(
        RegExp(r'\s*\([^)]*\)'),
        '',
      ) // Remove parentheses and contents
      .replaceAll(RegExp(r'\s+'), ' '); // Normalize to single spaces
}

/// Returns emoji map keys sorted by:
/// 1. Word count (descending) - more words first
/// 2. String length (descending) - longer keys first
List<String> _getSortedKeys() {
  return foodEmojiMap.keys.toList()..sort((a, b) {
    final aWordCount = a.split(' ').length;
    final bWordCount = b.split(' ').length;

    // Prioritize keys with more words
    if (aWordCount != bWordCount) {
      return bWordCount.compareTo(aWordCount);
    }

    // For same word count, prioritize longer keys
    return b.length.compareTo(a.length);
  });
}

/// Checks if [key] appears as a whole word in [text] using word boundaries.
/// Prevents partial matches like "melon" in "watermelon".
bool _hasWordBoundaryMatch(String text, String key) {
  final pattern = RegExp(r'\b' + RegExp.escape(key) + r'\b');
  return pattern.hasMatch(text);
}
