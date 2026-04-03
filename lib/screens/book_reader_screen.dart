import 'package:flutter/material.dart';
import 'book_library_screen.dart';

class BookReaderScreen extends StatefulWidget {
  final Book book;
  const BookReaderScreen({super.key, required this.book});

  @override
  State<BookReaderScreen> createState() => BookReaderScreenState();
}

class BookReaderScreenState extends State<BookReaderScreen>
    with SingleTickerProviderStateMixin {
  // Reading settings
  double _fontSize = 16.0;
  String _fontFamily = 'Default';
  _ReadingTheme _theme = _ReadingTheme.day;
  int _currentPage = 0;
  bool _showControls = true;

  // Page flip animation
  late final PageController _pageCtrl;

  static const _fontFamilies = ['Default', 'Serif', 'Mono'];
  static const _fonts = {
    'Default': 'sans-serif',
    'Serif': 'Georgia',
    'Mono': 'Courier',
  };

  // Sample chapter content
  late final List<String> _pages;

  @override
  void initState() {
    super.initState();
    _pageCtrl = PageController();
    _pages = _buildPages(widget.book.title);
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  List<String> _buildPages(String title) {
    // Generate 5 sample pages of content per book
    final intro = '''${widget.book.title}

By ${widget.book.author}

${widget.book.description}

This is a preview of the book. The full text is available in the public domain or through licensed distributions.

Chapter 1

${_sampleText(title, 1)}''';

    final pages = <String>[intro];
    for (int i = 2; i <= 5; i++) {
      pages.add('''Chapter $i

${_sampleText(title, i)}''');
    }
    return pages;
  }

  String _sampleText(String title, int chapter) {
    const passages = [
      'The journey of faith begins not with great deeds, but with a single step of trust. In the quietness of the heart, where doubts and fears reside, the voice of God calls us forward — not because we are ready, but because He is faithful.\n\nEvery great man and woman of God has faced moments of uncertainty. The prophets trembled. The disciples fled. Yet it was in their weakness that His strength was perfected. For God does not call the qualified; He qualifies the called.\n\nDo not despise these small beginnings. The mustard seed becomes a great tree. The widow\'s mite outweighs the wealthy man\'s gold. What matters is not the size of your offering, but the wholeness of your heart.',
      'Grace is not a doctrine to be debated but a river to be entered. It flows from the very nature of God, who is love. To encounter grace is to be undone and remade — to find that what we feared would destroy us has become the very thing that redeems us.\n\nThe cross stands at the centre of history as the loudest declaration of grace the universe has ever heard. There, in the darkness of midday, God paid what He did not owe so that we might receive what we could never earn.\n\nLive, therefore, not in the ledger of debt but in the freedom of the forgiven. Let grace shape how you see yourself, how you see others, and how you move through the world.',
      'Prayer is not a technique. It is a relationship. When a child calls to a parent, no formula is required — only honest words and a trusting heart. God invites us to come as we are, not as we hope to be.\n\nYet we are taught to pray. Jesus gave His disciples a pattern — not a script — to guide them into the rhythms of conversation with the Father: acknowledgement, surrender, petition, forgiveness, guidance, and praise. These are not boxes to check but postures to inhabit.\n\nFind a quiet place. Still your mind. Speak the things on your heart. Then, most crucially, wait. For prayer is not a monologue but a dialogue, and the Father speaks to those who have learned to listen.',
      'The Church is not a building. It is not a denomination. It is not a service on Sunday morning. The Church is the Body of Christ — the living, breathing community of all who have been called out of darkness into His marvellous light.\n\nWe are called to one another. Not as an afterthought, but as an essential expression of the gospel itself. When the world sees us loving one another — across cultures, languages, and backgrounds — it catches a glimpse of the Kingdom of Heaven.\n\nDo not forsake the gathering together. Be present. Bring your gifts. Receive the gifts of others. For in community, we become more fully who God has made us to be.',
      'The sufferings of this present time are not worth comparing to the glory that is to be revealed. This is not a dismissal of pain — our Saviour Himself wept at the grave of His friend. But it is an invitation to a wider perspective.\n\nThe story is not over. The last chapter has not been written. What we see now is part of a narrative that stretches from before the foundations of the world to a new creation where every tear will be wiped away.\n\nHold lightly to this present age. Set your hope fully on the grace that will be brought to you at the revelation of Jesus Christ. And in the waiting, serve faithfully, love deeply, and hold fast to the confession of your hope.',
    ];
    return passages[(chapter - 1) % passages.length];
  }

  Color get _bgColor {
    switch (_theme) {
      case _ReadingTheme.day:
        return const Color(0xFFFAF8F3);
      case _ReadingTheme.night:
        return const Color(0xFF1A1A2E);
      case _ReadingTheme.sepia:
        return const Color(0xFFF4E8D0);
    }
  }

  Color get _textClr {
    switch (_theme) {
      case _ReadingTheme.day:
        return const Color(0xFF1E1E1E);
      case _ReadingTheme.night:
        return const Color(0xFFE8E8E8);
      case _ReadingTheme.sepia:
        return const Color(0xFF4A3728);
    }
  }

  Color get _subClr {
    switch (_theme) {
      case _ReadingTheme.day:
        return const Color(0xFF6B7280);
      case _ReadingTheme.night:
        return const Color(0xFF94A3B8);
      case _ReadingTheme.sepia:
        return const Color(0xFF8B7355);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appBarBg = _theme == _ReadingTheme.night
        ? const Color(0xFF0F0F1A)
        : (_theme == _ReadingTheme.sepia
            ? const Color(0xFFEDDFBB)
            : Colors.white);

    return Scaffold(
      backgroundColor: _bgColor,
      body: Stack(
        children: [
          // Page content
          GestureDetector(
            onTap: () => setState(() => _showControls = !_showControls),
            child: PageView.builder(
              controller: _pageCtrl,
              onPageChanged: (i) => setState(() => _currentPage = i),
              itemCount: _pages.length,
              itemBuilder: (context, i) => _PageContent(
                content: _pages[i],
                fontSize: _fontSize,
                fontFamily: _fonts[_fontFamily]!,
                textColor: _textClr,
                bgColor: _bgColor,
                page: i + 1,
                totalPages: _pages.length,
                subColor: _subClr,
              ),
            ),
          ),

          // Top app bar
          AnimatedPositioned(
            duration: const Duration(milliseconds: 250),
            top: _showControls ? 0 : -100,
            left: 0,
            right: 0,
            child: Container(
              color: appBarBg,
              padding: EdgeInsets.fromLTRB(
                  4, MediaQuery.of(context).padding.top + 4, 16, 4),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: _textClr),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  Expanded(
                    child: Text(
                      widget.book.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _textClr,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.text_fields, color: _textClr),
                    onPressed: () => _showSettingsSheet(context),
                  ),
                ],
              ),
            ),
          ),

          // Bottom page indicator
          AnimatedPositioned(
            duration: const Duration(milliseconds: 250),
            bottom: _showControls ? 0 : -80,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                  24, 10, 24, MediaQuery.of(context).padding.bottom + 10),
              color: appBarBg,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: _currentPage > 0
                        ? () => _pageCtrl.previousPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            )
                        : null,
                    child: Icon(Icons.chevron_left,
                        color: _currentPage > 0
                            ? _textClr
                            : _subClr,
                        size: 28),
                  ),
                  Text(
                    'Page ${_currentPage + 1} of ${_pages.length}',
                    style: TextStyle(fontSize: 12, color: _subClr),
                  ),
                  GestureDetector(
                    onTap: _currentPage < _pages.length - 1
                        ? () => _pageCtrl.nextPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            )
                        : null,
                    child: Icon(Icons.chevron_right,
                        color: _currentPage < _pages.length - 1
                            ? _textClr
                            : _subClr,
                        size: 28),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSettingsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSheet) => Container(
          padding: EdgeInsets.fromLTRB(
              24, 16, 24, MediaQuery.of(context).padding.bottom + 24),
          decoration: BoxDecoration(
            color: _bgColor,
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: _subClr.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),

              Text('Reading Settings',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: _textClr)),
              const SizedBox(height: 20),

              // Font size
              Text('Font Size',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _subClr)),
              const SizedBox(height: 8),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (_fontSize > 12) {
                        setState(() => _fontSize -= 2);
                        setSheet(() {});
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _subClr.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child:
                          Icon(Icons.remove, color: _textClr, size: 18),
                    ),
                  ),
                  Expanded(
                    child: Slider(
                      value: _fontSize,
                      min: 12,
                      max: 26,
                      divisions: 7,
                      activeColor: const Color(0xFFEC5B13),
                      onChanged: (v) {
                        setState(() => _fontSize = v);
                        setSheet(() {});
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_fontSize < 26) {
                        setState(() => _fontSize += 2);
                        setSheet(() {});
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _subClr.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.add, color: _textClr, size: 18),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('${_fontSize.round()}pt',
                      style: TextStyle(
                          fontSize: 12,
                          color: _textClr,
                          fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 16),

              // Font family
              Text('Font',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _subClr)),
              const SizedBox(height: 8),
              Row(
                children: _fontFamilies.map((f) {
                  final active = _fontFamily == f;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        setState(() => _fontFamily = f);
                        setSheet(() {});
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: active
                              ? const Color(0xFFEC5B13)
                              : _subClr.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          f,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color:
                                active ? Colors.white : _textClr,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Theme
              Text('Reading Mode',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _subClr)),
              const SizedBox(height: 8),
              Row(
                children: [
                  _ThemeBtn(
                    label: 'Day',
                    icon: Icons.wb_sunny_outlined,
                    bg: const Color(0xFFFAF8F3),
                    textC: const Color(0xFF1E1E1E),
                    isActive: _theme == _ReadingTheme.day,
                    onTap: () {
                      setState(() => _theme = _ReadingTheme.day);
                      setSheet(() {});
                    },
                  ),
                  const SizedBox(width: 8),
                  _ThemeBtn(
                    label: 'Sepia',
                    icon: Icons.brightness_medium,
                    bg: const Color(0xFFF4E8D0),
                    textC: const Color(0xFF4A3728),
                    isActive: _theme == _ReadingTheme.sepia,
                    onTap: () {
                      setState(() => _theme = _ReadingTheme.sepia);
                      setSheet(() {});
                    },
                  ),
                  const SizedBox(width: 8),
                  _ThemeBtn(
                    label: 'Night',
                    icon: Icons.nightlight_round,
                    bg: const Color(0xFF1A1A2E),
                    textC: const Color(0xFFE8E8E8),
                    isActive: _theme == _ReadingTheme.night,
                    onTap: () {
                      setState(() => _theme = _ReadingTheme.night);
                      setSheet(() {});
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PageContent extends StatelessWidget {
  final String content;
  final double fontSize;
  final String fontFamily;
  final Color textColor;
  final Color bgColor;
  final Color subColor;
  final int page;
  final int totalPages;

  const _PageContent({
    required this.content,
    required this.fontSize,
    required this.fontFamily,
    required this.textColor,
    required this.bgColor,
    required this.subColor,
    required this.page,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
          24,
          MediaQuery.of(context).padding.top + 64,
          24,
          MediaQuery.of(context).padding.bottom + 80),
      child: Text(
        content,
        style: TextStyle(
          fontSize: fontSize,
          height: 1.8,
          color: textColor,
          fontFamily: fontFamily == 'sans-serif' ? null : fontFamily,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

class _ThemeBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color bg;
  final Color textC;
  final bool isActive;
  final VoidCallback onTap;

  const _ThemeBtn({
    required this.label,
    required this.icon,
    required this.bg,
    required this.textC,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isActive
                ? const Color(0xFFEC5B13)
                : Colors.grey.withOpacity(0.3),
            width: isActive ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: textC, size: 16),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: textC,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _ReadingTheme { day, sepia, night }
