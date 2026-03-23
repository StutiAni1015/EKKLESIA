import 'package:flutter/material.dart';
import 'church_creation_review_screen.dart';

const _indigo = Color(0xFF4F46E5);
const _indigoLight = Color(0xFFE0E7FF);
const _blue600 = Color(0xFF2563EB);

class ChurchCreationMediaScreen extends StatefulWidget {
  const ChurchCreationMediaScreen({super.key});

  @override
  State<ChurchCreationMediaScreen> createState() =>
      _ChurchCreationMediaScreenState();
}

class _ChurchCreationMediaScreenState
    extends State<ChurchCreationMediaScreen> {
  final _websiteCtrl = TextEditingController();
  final _youtubeCtrl = TextEditingController();
  final _instagramCtrl = TextEditingController();

  bool _hasLogo = false;
  bool _hasCover = false;

  @override
  void dispose() {
    _websiteCtrl.dispose();
    _youtubeCtrl.dispose();
    _instagramCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final subColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final labelColor =
        isDark ? const Color(0xFFCBD5E1) : const Color(0xFF475569);
    final inputBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final cardBg = isDark
        ? const Color(0xFF1E293B).withOpacity(0.6)
        : Colors.white.withOpacity(0.7);
    final borderColor =
        isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF221610),
                    const Color(0xFF1A1040),
                    const Color(0xFF221610),
                  ]
                : [
                    const Color(0xFFDBEAFE), // pastel blue
                    Colors.white,
                    const Color(0xFFFCE7F3), // pastel rose
                  ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding:
                    const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.maybePop(context),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: _indigo.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: _indigo,
                              size: 18,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Step 3 of 4',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _blue600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2),
                      child: LinearProgressIndicator(
                        value: 3 / 4,
                        minHeight: 5,
                        backgroundColor: isDark
                            ? const Color(0xFF334155)
                            : const Color(0xFFDBEAFE),
                        valueColor:
                            const AlwaysStoppedAnimation(_blue600),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Media & Socials',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.3,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Add visuals and connect your online presence',
                            style: TextStyle(
                              fontSize: 13,
                              color: subColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Scrollable form
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                      20,
                      20,
                      20,
                      MediaQuery.of(context).padding.bottom + 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Church Logo
                      _SectionLabel('CHURCH LOGO', labelColor),
                      const SizedBox(height: 10),
                      Center(
                        child: GestureDetector(
                          onTap: () =>
                              setState(() => _hasLogo = !_hasLogo),
                          child: AnimatedContainer(
                            duration:
                                const Duration(milliseconds: 200),
                            width: 96,
                            height: 96,
                            decoration: BoxDecoration(
                              color: _hasLogo
                                  ? _indigoLight
                                  : isDark
                                      ? const Color(0xFF1E293B)
                                      : const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: _hasLogo
                                    ? _indigo
                                    : const Color(0xFFCBD5E1),
                                width: 2,
                                strokeAlign:
                                    BorderSide.strokeAlignInside,
                              ),
                            ),
                            child: _hasLogo
                                ? const Icon(_iconUploadDone,
                                    color: _indigo, size: 32)
                                : Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add,
                                        color: subColor,
                                        size: 28,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'UPLOAD',
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.2,
                                          color: subColor,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Center(
                        child: Text(
                          'Square image, min 256×256px',
                          style:
                              TextStyle(fontSize: 11, color: subColor),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Cover Image
                      _SectionLabel('COVER IMAGE', labelColor),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () =>
                            setState(() => _hasCover = !_hasCover),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          height: 140,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: _hasCover
                                ? _indigoLight
                                : isDark
                                    ? const Color(0xFF1E293B)
                                    : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: _hasCover
                                  ? _indigo
                                  : const Color(0xFFCBD5E1),
                              width: 2,
                            ),
                          ),
                          child: _hasCover
                              ? const Icon(_iconUploadDone,
                                  color: _indigo, size: 40)
                              : Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.image_outlined,
                                        color: subColor, size: 32),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Tap to upload cover image',
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: subColor),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Recommended: 1200×400px',
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: subColor.withOpacity(
                                              0.7)),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Online Presence divider
                      Row(
                        children: [
                          Expanded(
                              child: Divider(color: borderColor)),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12),
                            child: Text(
                              'ONLINE PRESENCE',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                                color: subColor,
                              ),
                            ),
                          ),
                          Expanded(
                              child: Divider(color: borderColor)),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Website
                      _SectionLabel('WEBSITE', labelColor),
                      const SizedBox(height: 8),
                      _PrefixInput(
                        controller: _websiteCtrl,
                        prefix: 'https://',
                        hint: 'yourchurch.org',
                        bg: inputBg,
                        textColor: textColor,
                        hintColor: subColor,
                        prefixColor: subColor,
                        cardBg: cardBg,
                        borderColor: borderColor,
                      ),
                      const SizedBox(height: 16),

                      // YouTube
                      _SectionLabel('YOUTUBE / LIVE FEED', labelColor),
                      const SizedBox(height: 8),
                      _PrefixInput(
                        controller: _youtubeCtrl,
                        prefixIcon: Icons.play_circle_fill,
                        prefixIconColor: const Color(0xFFEF4444),
                        hint: 'youtube.com/c/yourchurch',
                        bg: inputBg,
                        textColor: textColor,
                        hintColor: subColor,
                        prefixColor: subColor,
                        cardBg: cardBg,
                        borderColor: borderColor,
                      ),
                      const SizedBox(height: 16),

                      // Instagram
                      _SectionLabel('INSTAGRAM HANDLE', labelColor),
                      const SizedBox(height: 8),
                      _PrefixInput(
                        controller: _instagramCtrl,
                        prefix: '@',
                        hint: 'yourchurchhandle',
                        bg: inputBg,
                        textColor: textColor,
                        hintColor: subColor,
                        prefixColor: const Color(0xFFEC4899),
                        cardBg: cardBg,
                        borderColor: borderColor,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // Bottom buttons
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(
            20, 12, 20, MediaQuery.of(context).padding.bottom + 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [Colors.transparent, const Color(0xFF221610)]
                : [Colors.transparent, Colors.white],
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 54,
                child: OutlinedButton(
                  onPressed: () => Navigator.maybePop(context),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: borderColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    foregroundColor: textColor,
                  ),
                  child: const Text(
                    'Back',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const ChurchCreationReviewScreen(),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _blue600,
                    foregroundColor: Colors.white,
                    elevation: 6,
                    shadowColor: _blue600.withOpacity(0.35),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Next Step',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 6),
                      Icon(Icons.arrow_forward, size: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Constant for upload-done icon
const _iconUploadDone = Icons.check_circle_outline;

// ─── Supporting widgets ──────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  final Color color;
  const _SectionLabel(this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.3,
        color: color,
      ),
    );
  }
}

class _PrefixInput extends StatelessWidget {
  final TextEditingController controller;
  final String? prefix;
  final IconData? prefixIcon;
  final Color? prefixIconColor;
  final String hint;
  final Color bg;
  final Color textColor;
  final Color hintColor;
  final Color prefixColor;
  final Color cardBg;
  final Color borderColor;

  const _PrefixInput({
    required this.controller,
    this.prefix,
    this.prefixIcon,
    this.prefixIconColor,
    required this.hint,
    required this.bg,
    required this.textColor,
    required this.hintColor,
    required this.prefixColor,
    required this.cardBg,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: prefixIcon != null
                  ? Colors.transparent
                  : prefixColor.withOpacity(0.05),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                bottomLeft: Radius.circular(14),
              ),
            ),
            child: prefixIcon != null
                ? Icon(
                    prefixIcon,
                    color: prefixIconColor ?? prefixColor,
                    size: 20,
                  )
                : Text(
                    prefix ?? '',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: prefixColor,
                    ),
                  ),
          ),
          Container(
            width: 1,
            height: 30,
            color: borderColor,
          ),
          Expanded(
            child: TextField(
              controller: controller,
              style: TextStyle(fontSize: 14, color: textColor),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle:
                    TextStyle(color: hintColor, fontSize: 14),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 16),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
