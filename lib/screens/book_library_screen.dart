import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/app_colors.dart';
import 'book_reader_screen.dart';

class BookLibraryScreen extends StatefulWidget {
  const BookLibraryScreen({super.key});

  @override
  State<BookLibraryScreen> createState() => BookLibraryScreenState();
}

class BookLibraryScreenState extends State<BookLibraryScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  String? _selectedCategory;
  final _searchCtrl = TextEditingController();
  String _query = '';
  final List<_UploadedBook> _uploadedBooks = [];
  bool _picking = false;

  static const _categories = [
    'All', 'Devotional', 'Theology', 'Biography', 'Prayer', 'Christian Living',
  ];

  static const _books = [
    Book(
      title: "Pilgrim's Progress",
      author: 'John Bunyan',
      category: 'Christian Living',
      description:
          'An allegorical narrative of the Christian life, following Pilgrim from the City of Destruction to the Celestial City.',
      gradientStart: Color(0xFF4A6741),
      gradientEnd: Color(0xFF8BA888),
      pages: 320,
      emoji: '⚓',
    ),
    Book(
      title: 'Mere Christianity',
      author: 'C.S. Lewis',
      category: 'Theology',
      description:
          'A compelling and accessible defense of the Christian faith, originally delivered as BBC radio talks.',
      gradientStart: Color(0xFF6B7FD4),
      gradientEnd: Color(0xFF9B8BBF),
      pages: 256,
      emoji: '✝️',
    ),
    Book(
      title: 'My Utmost for His Highest',
      author: 'Oswald Chambers',
      category: 'Devotional',
      description:
          'One of the most widely read daily devotionals of all time, offering 365 days of spiritual challenges.',
      gradientStart: Color(0xFFDCAE96),
      gradientEnd: Color(0xFFEC5B13),
      pages: 400,
      emoji: '🌟',
    ),
    Book(
      title: 'The Purpose Driven Life',
      author: 'Rick Warren',
      category: 'Christian Living',
      description:
          'A global bestseller that answers the question "What on earth am I here for?" through 40 days of discovery.',
      gradientStart: Color(0xFF2B6CB0),
      gradientEnd: Color(0xFF4299E1),
      pages: 336,
      emoji: '🎯',
    ),
    Book(
      title: 'Experiencing God',
      author: 'Henry Blackaby',
      category: 'Devotional',
      description:
          'Knowing and doing the will of God — a foundational guide to recognising God\'s activity and joining Him.',
      gradientStart: Color(0xFF9B4D6A),
      gradientEnd: Color(0xFFD4A5A5),
      pages: 280,
      emoji: '🙏',
    ),
    Book(
      title: 'The Cost of Discipleship',
      author: 'Dietrich Bonhoeffer',
      category: 'Theology',
      description:
          'A study of the Sermon on the Mount that calls all followers of Christ to costly, grace-filled obedience.',
      gradientStart: Color(0xFF1A202C),
      gradientEnd: Color(0xFF4A5568),
      pages: 320,
      emoji: '📖',
    ),
    Book(
      title: 'Intercessory Prayer',
      author: 'Dutch Sheets',
      category: 'Prayer',
      description:
          'Discover how God works through prayer and why your prayers make an eternal difference.',
      gradientStart: Color(0xFFB9D1EA),
      gradientEnd: Color(0xFF4A7BA0),
      pages: 240,
      emoji: '💛',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
    _searchCtrl.addListener(() => setState(() => _query = _searchCtrl.text));
  }

  @override
  void dispose() {
    _tabs.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  List<Book> get _filtered {
    var list = _books.toList();
    if (_selectedCategory != null && _selectedCategory != 'All') {
      list = list.where((b) => b.category == _selectedCategory).toList();
    }
    if (_query.isNotEmpty) {
      list = list
          .where((b) =>
              b.title.toLowerCase().contains(_query.toLowerCase()) ||
              b.author.toLowerCase().contains(_query.toLowerCase()))
          .toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : const Color(0xFFF6F6F8);
    final textColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final subColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor =
        isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            Container(
              color: isDark ? const Color(0xFF0F172A) : Colors.white,
              padding: const EdgeInsets.fromLTRB(4, 8, 16, 8),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: textColor),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  Expanded(
                    child: Text(
                      'Book Library',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                  // Upload PDF button
                  GestureDetector(
                    onTap: () => _showUploadSheet(context, isDark),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.upload_file,
                              color: Colors.white, size: 14),
                          SizedBox(width: 5),
                          Text(
                            'Upload PDF',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: borderColor),

            // Search
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: TextField(
                controller: _searchCtrl,
                style: TextStyle(fontSize: 14, color: textColor),
                decoration: InputDecoration(
                  hintText: 'Search books, authors...',
                  hintStyle: TextStyle(color: subColor, fontSize: 14),
                  prefixIcon: Icon(Icons.search, color: subColor),
                  filled: true,
                  fillColor: cardBg,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // Category chips
            SizedBox(
              height: 48,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final cat = _categories[i];
                  final active = _selectedCategory == cat ||
                      (cat == 'All' && _selectedCategory == null);
                  return GestureDetector(
                    onTap: () => setState(() =>
                        _selectedCategory = cat == 'All' ? null : cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: active ? AppColors.primary : cardBg,
                        borderRadius: BorderRadius.circular(99),
                        border: Border.all(
                          color: active ? AppColors.primary : borderColor,
                        ),
                      ),
                      child: Text(
                        cat,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: active ? Colors.white : subColor,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),

            // Uploaded books section
            if (_uploadedBooks.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Row(
                  children: [
                    Text('MY BOOKS',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(99),
                      ),
                      child: Text('${_uploadedBooks.length}',
                          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 80,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  itemCount: _uploadedBooks.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (_, i) {
                    final book = _uploadedBooks[i];
                    return GestureDetector(
                      onTap: () => _openUploadedBook(book),
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Remove Book'),
                            content: Text('Remove "${book.name}" from My Books?'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  setState(() => _uploadedBooks.removeAt(i));
                                },
                                child: const Text('Remove', style: TextStyle(color: Colors.redAccent)),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Container(
                        width: 220,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: borderColor),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 38, height: 38,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.picture_as_pdf, color: AppColors.primary, size: 20),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(book.name,
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: textColor),
                                      maxLines: 2, overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 2),
                                  Text('PDF · Tap to open',
                                      style: TextStyle(fontSize: 10, color: subColor)),
                                ],
                              ),
                            ),
                            const Icon(Icons.open_in_new, size: 14, color: AppColors.primary),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text('LIBRARY',
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B))),
              ),
            ],

            // Book grid
            Expanded(
              child: _filtered.isEmpty
                  ? Center(
                      child: Text('No books found.',
                          style: TextStyle(color: subColor)),
                    )
                  : GridView.builder(
                      padding: EdgeInsets.fromLTRB(
                          16, 0, 16, MediaQuery.of(context).padding.bottom + 80),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 0.65,
                      ),
                      itemCount: _filtered.length,
                      itemBuilder: (context, i) {
                        final book = _filtered[i];
                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BookReaderScreen(book: book),
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: cardBg,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: borderColor),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Book cover
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(16)),
                                  child: Container(
                                    height: 130,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          book.gradientStart,
                                          book.gradientEnd
                                        ],
                                      ),
                                    ),
                                    child: Stack(
                                      children: [
                                        Center(
                                          child: Text(
                                            book.emoji,
                                            style: const TextStyle(
                                                fontSize: 44),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 6,
                                          right: 8,
                                          child: Text(
                                            '${book.pages}p',
                                            style: const TextStyle(
                                              fontSize: 9,
                                              color: Colors.white70,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          book.title,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: textColor,
                                            height: 1.3,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          book.author,
                                          style: TextStyle(
                                              fontSize: 10, color: subColor),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const Spacer(),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary
                                                .withOpacity(0.08),
                                            borderRadius:
                                                BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            book.category,
                                            style: const TextStyle(
                                              fontSize: 9,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.primary,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickAndUpload() async {
    if (_picking) return;
    setState(() => _picking = true);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        allowMultiple: false,
      );
      if (result == null || result.files.isEmpty) return;
      final file = result.files.first;
      final path = file.path;
      if (path == null) {
        _snack('Could not access file path.', error: true);
        return;
      }
      final name = file.name.replaceAll(RegExp(r'\.pdf$', caseSensitive: false), '');
      setState(() {
        _uploadedBooks.add(_UploadedBook(name: name, path: path));
      });
      _snack('"$name" added to My Books.');
    } catch (e) {
      _snack('Failed to pick file: $e', error: true);
    } finally {
      if (mounted) setState(() => _picking = false);
    }
  }

  Future<void> _openUploadedBook(_UploadedBook book) async {
    final uri = Uri.file(book.path);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      _snack('No PDF viewer found on this device.', error: true);
    }
  }

  void _snack(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: error ? Colors.redAccent : AppColors.primary,
      behavior: SnackBarBehavior.floating,
    ));
  }

  void _showUploadSheet(BuildContext context, bool isDark) {
    final bg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final subColor  = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: EdgeInsets.fromLTRB(24, 16, 24, MediaQuery.of(context).padding.bottom + 32),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(color: borderColor, borderRadius: BorderRadius.circular(99)),
            ),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.upload_file, color: AppColors.primary, size: 28),
            ),
            const SizedBox(height: 14),
            Text('Upload a Book', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
            const SizedBox(height: 8),
            Text(
              'Choose a PDF from your device.\nIt will appear in your "My Books" section.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: subColor, height: 1.6),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  _pickAndUpload();
                },
                icon: const Icon(Icons.folder_open, size: 18),
                label: const Text('Choose PDF from Files',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UploadedBook {
  final String name;
  final String path;
  _UploadedBook({required this.name, required this.path});
}

class Book {
  final String title;
  final String author;
  final String category;
  final String description;
  final Color gradientStart;
  final Color gradientEnd;
  final int pages;
  final String emoji;

  const Book({
    required this.title,
    required this.author,
    required this.category,
    required this.description,
    required this.gradientStart,
    required this.gradientEnd,
    required this.pages,
    required this.emoji,
  });
}
