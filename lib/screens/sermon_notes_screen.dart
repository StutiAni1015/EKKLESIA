import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class SermonNotesScreen extends StatefulWidget {
  final String sermonTitle;
  final String sermonInfo;

  const SermonNotesScreen({
    super.key,
    this.sermonTitle = 'The Power of Grace',
    this.sermonInfo = 'Sunday, Oct 27 • Pastor Sarah Jenkins',
  });

  @override
  State<SermonNotesScreen> createState() => _SermonNotesScreenState();
}

class _SermonNotesScreenState extends State<SermonNotesScreen> {
  late final TextEditingController _titleCtrl;
  final TextEditingController _notesCtrl = TextEditingController();
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.sermonTitle);
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  void _save() {
    FocusScope.of(context).unfocus();
    setState(() => _saved = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notes saved.'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final toolbarBg =
        isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor =
        isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(4, 4, 16, 4),
              decoration: BoxDecoration(
                color: bg.withOpacity(0.8),
                border: Border(
                  bottom:
                      BorderSide(color: AppColors.primary.withOpacity(0.1)),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: textColor),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  Expanded(
                    child: Text(
                      'Sermon Notes',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.3,
                        color: textColor,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _saved ? Colors.green : AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder(),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      elevation: 2,
                      shadowColor: AppColors.primary.withOpacity(0.3),
                    ),
                    child: Text(
                      _saved ? 'Saved!' : 'Save',
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                        24, 20, 24, MediaQuery.of(context).padding.bottom + 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Sermon label
                        Text(
                          'CURRENT SERMON',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Title
                        TextField(
                          controller: _titleCtrl,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                            color: textColor,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Sermon Title',
                            hintStyle: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: subColor.withOpacity(0.4),
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),

                        // Subtitle
                        Row(
                          children: [
                            Icon(Icons.calendar_today,
                                size: 13, color: subColor),
                            const SizedBox(width: 6),
                            Text(
                              widget.sermonInfo,
                              style:
                                  TextStyle(fontSize: 13, color: subColor),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        Divider(
                          color: AppColors.primary.withOpacity(0.08),
                          height: 1,
                        ),
                        const SizedBox(height: 20),

                        // Notes textarea
                        TextField(
                          controller: _notesCtrl,
                          maxLines: null,
                          minLines: 12,
                          style: TextStyle(
                            fontSize: 17,
                            height: 1.7,
                            color: textColor.withOpacity(0.85),
                          ),
                          decoration: InputDecoration(
                            hintText:
                                'Start capturing your thoughts and inspirations here...',
                            hintStyle: TextStyle(
                              fontSize: 17,
                              height: 1.7,
                              color: subColor.withOpacity(0.5),
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Inspirational quote card
                        Center(
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColors.primary.withOpacity(0.1),
                              ),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  '"For by grace you have been saved through faith. And this is not your own doing; it is the gift of God."',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontStyle: FontStyle.italic,
                                    height: 1.6,
                                    color: textColor.withOpacity(0.75),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'Ephesians 2:8',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Floating toolbar
                  Positioned(
                    bottom: MediaQuery.of(context).padding.bottom + 16,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: toolbarBg,
                          borderRadius: BorderRadius.circular(99),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.2),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.12),
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _ToolbarBtn(
                                icon: Icons.format_bold,
                                onTap: () {}),
                            _ToolbarBtn(
                                icon: Icons.format_italic,
                                onTap: () {}),
                            _ToolbarBtn(
                                icon: Icons.format_list_bulleted,
                                onTap: () {},
                                hasDivider: true),
                            _ToolbarBtn(
                                icon: Icons.image_outlined,
                                onTap: () {}),
                            _ToolbarBtn(
                                icon: Icons.link,
                                onTap: () {}),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ToolbarBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool hasDivider;

  const _ToolbarBtn({
    required this.icon,
    required this.onTap,
    this.hasDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(99),
            ),
            child: Icon(
              icon,
              size: 22,
              color: isDark
                  ? const Color(0xFFCBD5E1)
                  : const Color(0xFF475569),
            ),
          ),
        ),
        if (hasDivider)
          Container(
            width: 1,
            height: 24,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            color: AppColors.primary.withOpacity(0.15),
          ),
      ],
    );
  }
}
