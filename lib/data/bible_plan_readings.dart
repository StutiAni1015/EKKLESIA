/// Full Bible in a Year — 1189 chapters distributed across 365 days.
///
/// All 1189 canonical Bible chapters are listed in order (Genesis → Revelation).
/// [getReadingsForDay] returns the 3–4 chapters assigned to a given day (1-indexed).
library;

// ── Book list: (name, chapterCount) ──────────────────────────────────────────
const _books = <(String, int)>[
  // Old Testament
  ('Genesis', 50),
  ('Exodus', 40),
  ('Leviticus', 27),
  ('Numbers', 36),
  ('Deuteronomy', 34),
  ('Joshua', 24),
  ('Judges', 21),
  ('Ruth', 4),
  ('1 Samuel', 31),
  ('2 Samuel', 24),
  ('1 Kings', 22),
  ('2 Kings', 25),
  ('1 Chronicles', 29),
  ('2 Chronicles', 36),
  ('Ezra', 10),
  ('Nehemiah', 13),
  ('Esther', 10),
  ('Job', 42),
  ('Psalms', 150),
  ('Proverbs', 31),
  ('Ecclesiastes', 12),
  ('Song of Solomon', 8),
  ('Isaiah', 66),
  ('Jeremiah', 52),
  ('Lamentations', 5),
  ('Ezekiel', 48),
  ('Daniel', 12),
  ('Hosea', 14),
  ('Joel', 3),
  ('Amos', 9),
  ('Obadiah', 1),
  ('Jonah', 4),
  ('Micah', 7),
  ('Nahum', 3),
  ('Habakkuk', 3),
  ('Zephaniah', 3),
  ('Haggai', 2),
  ('Zechariah', 14),
  ('Malachi', 4),
  // New Testament
  ('Matthew', 28),
  ('Mark', 16),
  ('Luke', 24),
  ('John', 21),
  ('Acts', 28),
  ('Romans', 16),
  ('1 Corinthians', 16),
  ('2 Corinthians', 13),
  ('Galatians', 6),
  ('Ephesians', 6),
  ('Philippians', 4),
  ('Colossians', 4),
  ('1 Thessalonians', 5),
  ('2 Thessalonians', 3),
  ('1 Timothy', 6),
  ('2 Timothy', 4),
  ('Titus', 3),
  ('Philemon', 1),
  ('Hebrews', 13),
  ('James', 5),
  ('1 Peter', 5),
  ('2 Peter', 3),
  ('1 John', 5),
  ('2 John', 1),
  ('3 John', 1),
  ('Jude', 1),
  ('Revelation', 22),
];

/// Lazily built flat list of every chapter label, e.g. "Genesis 1", "Genesis 2" … "Revelation 22".
List<String>? _allChapters;

List<String> get _chapters {
  if (_allChapters != null) return _allChapters!;
  final out = <String>[];
  for (final (book, count) in _books) {
    for (var c = 1; c <= count; c++) {
      out.add('$book $c');
    }
  }
  _allChapters = out;
  return out;
}

/// Returns the list of chapter readings for [day] (1 = first day, 365 = last day).
/// Each call returns 3 or 4 chapters so that all 1189 chapters fit in 365 days.
List<String> getReadingsForDay(int day) {
  if (day < 1) day = 1;
  if (day > 365) day = 365;
  final chapters = _chapters; // 1189 items
  final total = chapters.length; // 1189
  final start = ((day - 1) * total) ~/ 365;
  final end = (day * total) ~/ 365; // exclusive
  return chapters.sublist(start, end);
}

/// Total number of chapters in the Bible (1189).
const int totalBibleChapters = 1189;
