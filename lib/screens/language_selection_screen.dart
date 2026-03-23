import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../core/app_localizations.dart';
import 'welcome_screen.dart';

class _Language {
  final String nativeName;
  final String englishName;
  final String code;

  const _Language(this.nativeName, this.englishName, this.code);
}

const _languages = [
  _Language('English', 'English', 'en'),
  _Language('Español', 'Spanish', 'es'),
  _Language('Français', 'French', 'fr'),
  _Language('Português', 'Portuguese', 'pt'),
  _Language('한국어', 'Korean', 'ko'),
  _Language('中文', 'Chinese', 'zh'),
  _Language('हिन्दी', 'Hindi', 'hi'),
  _Language('العربية', 'Arabic', 'ar'),
  _Language('Kiswahili', 'Swahili', 'sw'),
  _Language('Filipino', 'Filipino', 'tl'),
];

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String _selectedCode = 'en';
  String _search = '';

  List<_Language> get _filtered {
    if (_search.isEmpty) return _languages;
    final q = _search.toLowerCase();
    return _languages
        .where((l) =>
            l.nativeName.toLowerCase().contains(q) ||
            l.englishName.toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.ivory,
      body: Stack(
        children: [
          // Decorative blobs
          Positioned(
            top: -40,
            right: -40,
            child: Container(
              width: 128,
              height: 128,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.babyBlue.withOpacity(0.2),
              ),
            ),
          ),
          Positioned(
            bottom: 160,
            left: -96,
            child: Container(
              width: 192,
              height: 192,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.dustyRose.withOpacity(0.2),
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Column(
              children: [
                // Top app bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                        onPressed: () => Navigator.maybePop(context),
                      ),
                      Expanded(
                        child: Text(
                          l.chooseLanguage,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.3,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),

                // Scrollable body
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      // Header
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                          child: Column(
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.sage.withOpacity(0.2),
                                ),
                                child: const Icon(
                                  Icons.language,
                                  color: AppColors.sage,
                                  size: 32,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Welcome to our community',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.4,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Please select your preferred language to continue your spiritual journey with us.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                  height: 1.5,
                                  color: isDark
                                      ? Colors.white60
                                      : Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Search bar
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF2A2A2A)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isDark
                                    ? Colors.white24
                                    : AppColors.nude,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 14),
                                  child: Icon(
                                    Icons.search,
                                    color: Colors.grey,
                                    size: 22,
                                  ),
                                ),
                                Expanded(
                                  child: TextField(
                                    onChanged: (v) =>
                                        setState(() => _search = v),
                                    decoration: InputDecoration(
                                      hintText: l.findYourLanguage,
                                      hintStyle:
                                          const TextStyle(color: Colors.grey),
                                      border: InputBorder.none,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 10),
                                    ),
                                    style: TextStyle(
                                      fontSize: 15,
                                      color:
                                          isDark ? Colors.white : Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Language list
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final lang = _filtered[index];
                              final selected = lang.code == _selectedCode;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: GestureDetector(
                                  onTap: () => setState(
                                      () => _selectedCode = lang.code),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 150),
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? const Color(0xFF2A2A2A)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: selected
                                            ? AppColors.sage
                                            : isDark
                                                ? Colors.white24
                                                : AppColors.nude,
                                        width: selected ? 1.5 : 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: Radio<String>(
                                            value: lang.code,
                                            groupValue: _selectedCode,
                                            onChanged: (v) => setState(
                                                () => _selectedCode = v!),
                                            activeColor: AppColors.primary,
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Text(
                                            lang.nativeName,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: isDark
                                                  ? Colors.white
                                                  : Colors.black87,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          lang.englishName,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            childCount: _filtered.length,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Fixed bottom button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: (isDark ? AppColors.backgroundDark : AppColors.ivory)
                  .withOpacity(0.95),
              padding: EdgeInsets.fromLTRB(
                  16, 12, 16, MediaQuery.of(context).padding.bottom + 12),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    final selected = _languages.firstWhere(
                      (l) => l.code == _selectedCode,
                    );
                    // Update the global locale — rebuilds entire app
                    appLocaleNotifier.value = Locale(selected.code);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => WelcomeScreen(
                          languageCode: selected.code,
                          languageNativeName: selected.nativeName,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    l.continueLabel,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
