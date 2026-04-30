import 'dart:async';
import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../service/api_service.dart';
import 'my_spiritual_journal_screen.dart';

// ─── Palette ────────────────────────────────────────────────────────────────
const _violet     = Color(0xFF7C3AED);
const _violetSoft = Color(0xFF8B5CF6);
const _violetBg   = Color(0xFFF5F0FF);
const _gold       = Color(0xFFF59E0B);

// ─── Mode ───────────────────────────────────────────────────────────────────
enum EzerMode { ask, counsel, quiz, notes }

extension _ModeLabel on EzerMode {
  String get label => switch (this) {
        EzerMode.ask    => 'Bible Q&A',
        EzerMode.counsel => 'Counsel Me',
        EzerMode.quiz   => 'Quiz Me',
        EzerMode.notes  => 'My Notes',
      };
  String get emoji => switch (this) {
        EzerMode.ask    => '📖',
        EzerMode.counsel => '🕊️',
        EzerMode.quiz   => '✏️',
        EzerMode.notes  => '📝',
      };
  String get hint => switch (this) {
        EzerMode.ask    => 'Ask any Bible question…',
        EzerMode.counsel => 'Share what\'s on your heart…',
        EzerMode.quiz   => 'Say "Quiz me" or pick a topic…',
        EzerMode.notes  => 'Write a reflection to save…',
      };
  String get systemNote => switch (this) {
        EzerMode.ask    => 'The user wants Bible Q&A. Answer with scripture references.',
        EzerMode.counsel => 'The user is seeking spiritual counselling. Be especially warm and compassionate.',
        EzerMode.quiz   => 'The user wants a Bible quiz. Generate one quiz question at a time; wait for their answer before revealing the correct one.',
        EzerMode.notes  => 'The user is writing a personal reflection or note. Help them explore and deepen it. If they seem done, remind them they can save it with the bookmark icon.',
      };
}

// ─── Message model ───────────────────────────────────────────────────────────
class _Msg {
  final String role;   // 'user' | 'assistant'
  final String text;
  final bool isSaved;
  const _Msg({required this.role, required this.text, this.isSaved = false});
  _Msg copyWith({bool? isSaved}) =>
      _Msg(role: role, text: text, isSaved: isSaved ?? this.isSaved);
}

// ─── Screen ─────────────────────────────────────────────────────────────────
class EzerScreen extends StatefulWidget {
  const EzerScreen({super.key});

  @override
  State<EzerScreen> createState() => _EzerScreenState();
}

class _EzerScreenState extends State<EzerScreen>
    with TickerProviderStateMixin {
  final _controller   = TextEditingController();
  final _scrollCtrl   = ScrollController();
  final _inputFocus   = FocusNode();

  EzerMode _mode = EzerMode.ask;
  final List<_Msg> _messages = [];
  bool _loading = false;

  // Typing animation
  late final AnimationController _dotAnim = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    _scrollCtrl.dispose();
    _inputFocus.dispose();
    _dotAnim.dispose();
    super.dispose();
  }

  // ── Helpers ─────────────────────────────────────────────────────────────────

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _loading) return;

    _controller.clear();
    _inputFocus.unfocus();

    setState(() {
      _messages.add(_Msg(role: 'user', text: text));
      _loading = true;
    });
    _scrollToBottom();

    try {
      final history = <Map<String, String>>[];

      // Inject mode context on the first message
      if (_messages.where((m) => m.role == 'user').length == 1) {
        history.add({
          'role': 'user',
          'content': '[Mode: ${_mode.label}] ${_mode.systemNote}\n\n$text',
        });
      } else {
        for (final m in _messages) {
          if (m.role == 'user' || m.role == 'assistant') {
            history.add({'role': m.role, 'content': m.text});
          }
        }
      }

      final reply = await ApiService.askCompanion(history);

      if (mounted) {
        setState(() {
          _messages.add(_Msg(role: 'assistant', text: reply));
          _loading = false;
        });
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages.add(const _Msg(
            role: 'assistant',
            text: 'I\'m having trouble connecting right now. Please check your connection and try again.',
          ));
          _loading = false;
        });
        _scrollToBottom();
      }
    }
  }

  Future<void> _saveToJournal(_Msg msg, int index) async {
    final content = msg.role == 'assistant'
        ? 'Ezer said:\n\n${msg.text}'
        : msg.text;

    try {
      await ApiService.createJournal(
        title: 'Ezer — ${_mode.label}',
        content: content,
      );
      if (mounted) {
        setState(() {
          _messages[index] = msg.copyWith(isSaved: true);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Saved to your journal ✓'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: const Color(0xFF7C3AED),
            action: SnackBarAction(
              label: 'View',
              textColor: Colors.white,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MySpiritualJournalScreen()),
              ),
            ),
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not save right now. Try again.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _changeMode(EzerMode mode) {
    if (mode == _mode) return;
    setState(() {
      _mode = mode;
      _messages.clear();
    });
  }

  // ── Build ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : const Color(0xFFFAF8FF);

    return Scaffold(
      backgroundColor: bg,
      floatingActionButton: FloatingActionButton(
        heroTag: 'center_fab',
        onPressed: null, // already on Ezer — no action
        backgroundColor: _violet,
        elevation: 4,
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('✨', style: TextStyle(fontSize: 22, height: 1)),
            SizedBox(height: 1),
            Text(
              'Ezer',
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(isDark),
            _buildModePicker(isDark),
            Expanded(child: _buildMessages(isDark)),
            _buildInput(isDark),
          ],
        ),
      ),
    );
  }

  // ── Header ───────────────────────────────────────────────────────────────────
  Widget _buildHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(15),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                size: 16,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [_violet, _violetSoft],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text('✨', style: TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ezer',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                  ),
                ),
                Text(
                  'Your helper — faith, scripture & counsel',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          if (_messages.isNotEmpty)
            GestureDetector(
              onTap: () => setState(() => _messages.clear()),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : _violetBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.refresh, size: 18, color: _violetSoft),
              ),
            ),
        ],
      ),
    );
  }

  // ── Mode picker ──────────────────────────────────────────────────────────────
  Widget _buildModePicker(bool isDark) {
    return SizedBox(
      height: 52,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: EzerMode.values.map((mode) {
          final selected = _mode == mode;
          return GestureDetector(
            onTap: () => _changeMode(mode),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: selected
                    ? _violet
                    : isDark
                        ? const Color(0xFF1E293B)
                        : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: _violet.withAlpha(76),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        )
                      ]
                    : [],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(mode.emoji, style: const TextStyle(fontSize: 13)),
                  const SizedBox(width: 5),
                  Text(
                    mode.label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: selected
                          ? Colors.white
                          : isDark
                              ? const Color(0xFF94A3B8)
                              : const Color(0xFF475569),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── Messages ─────────────────────────────────────────────────────────────────
  Widget _buildMessages(bool isDark) {
    if (_messages.isEmpty) return _buildWelcome(isDark);

    return ListView.builder(
      controller: _scrollCtrl,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      itemCount: _messages.length + (_loading ? 1 : 0),
      itemBuilder: (context, i) {
        if (_loading && i == _messages.length) {
          return _buildTypingIndicator(isDark);
        }
        return _buildBubble(_messages[i], i, isDark);
      },
    );
  }

  Widget _buildWelcome(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [_violet, _violetSoft],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: _violet.withAlpha(76),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Center(
              child: Text('✨', style: TextStyle(fontSize: 40)),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Hello, I am Ezer\nThe Helper !!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF1E293B),
              height: 1.3,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'ezer — Hebrew for "helper"',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontStyle: FontStyle.italic,
              color: _violetSoft,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Ask me anything about the Bible, share what\'s on your heart, take a quiz, or write a reflection.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: isDark
                  ? const Color(0xFF94A3B8)
                  : const Color(0xFF64748B),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 28),
          ..._starterPrompts().map((p) => _StarterChip(
                text: p,
                isDark: isDark,
                onTap: () {
                  _controller.text = p;
                  _send();
                },
              )),
        ],
      ),
    );
  }

  List<String> _starterPrompts() => switch (_mode) {
        EzerMode.ask => [
            'Who was King David?',
            'What does John 3:16 mean?',
            'Explain the Sermon on the Mount',
            'What is the armor of God?',
          ],
        EzerMode.counsel => [
            'I\'m feeling anxious and need peace',
            'I\'m struggling with forgiveness',
            'Help me trust God more',
            'I feel distant from God lately',
          ],
        EzerMode.quiz => [
            'Quiz me on the Gospels',
            'Give me an Old Testament quiz',
            'Quiz me on the Psalms',
            'Test my knowledge of the apostles',
          ],
        EzerMode.notes => [
            'I want to write about my faith journey',
            'Help me reflect on today\'s scripture',
            'I\'d like to journal a prayer',
            'Help me process a difficult situation',
          ],
      };

  Widget _buildBubble(_Msg msg, int index, bool isDark) {
    final isUser = msg.role == 'user';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser)
            Container(
              width: 30, height: 30,
              margin: const EdgeInsets.only(right: 8, bottom: 4),
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [_violet, _violetSoft]),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text('✨', style: TextStyle(fontSize: 14)),
              ),
            ),
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: isUser
                        ? _violet
                        : isDark
                            ? const Color(0xFF1E293B)
                            : Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(isUser ? 18 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 18),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(10),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    msg.text,
                    style: TextStyle(
                      fontSize: 14,
                      color: isUser
                          ? Colors.white
                          : isDark
                              ? const Color(0xFFE2E8F0)
                              : const Color(0xFF1E293B),
                      height: 1.5,
                    ),
                  ),
                ),
                if (!isUser) ...[
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: msg.isSaved ? null : () => _saveToJournal(msg, index),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          msg.isSaved ? Icons.bookmark : Icons.bookmark_border,
                          size: 14,
                          color: msg.isSaved ? _gold : const Color(0xFF94A3B8),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          msg.isSaved ? 'Saved to journal' : 'Save to journal',
                          style: TextStyle(
                            fontSize: 11,
                            color: msg.isSaved ? _gold : const Color(0xFF94A3B8),
                            fontWeight: msg.isSaved
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (isUser) const SizedBox(width: 4),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator(bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            width: 30, height: 30,
            margin: const EdgeInsets.only(right: 8, bottom: 4),
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [_violet, _violetSoft]),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('✨', style: TextStyle(fontSize: 14)),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomRight: Radius.circular(18),
                bottomLeft: Radius.circular(4),
              ),
            ),
            child: AnimatedBuilder(
              animation: _dotAnim,
              builder: (context, _) => Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(3, (i) {
                  final opacity = ((_dotAnim.value * 3) - i).clamp(0.0, 1.0);
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    width: 7, height: 7,
                    decoration: BoxDecoration(
                      color: _violetSoft.withAlpha((opacity * 255).round()),
                      shape: BoxShape.circle,
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Input bar ────────────────────────────────────────────────────────────────
  Widget _buildInput(bool isDark) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 10,
        bottom: MediaQuery.of(context).padding.bottom + 80,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDark : const Color(0xFFFAF8FF),
        border: Border(
          top: BorderSide(
            color: isDark
                ? const Color(0xFF334155)
                : const Color(0xFFEDE9FE),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(10),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _controller,
                focusNode: _inputFocus,
                maxLines: 4,
                minLines: 1,
                textCapitalization: TextCapitalization.sentences,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                ),
                decoration: InputDecoration(
                  hintText: _mode.hint,
                  hintStyle: const TextStyle(
                      fontSize: 14, color: Color(0xFF94A3B8)),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                ),
                onSubmitted: (_) => _send(),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: _loading ? null : _send,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 46, height: 46,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _loading
                      ? [Colors.grey.shade400, Colors.grey.shade400]
                      : [_violet, _violetSoft],
                ),
                shape: BoxShape.circle,
                boxShadow: _loading
                    ? []
                    : [
                        BoxShadow(
                          color: _violet.withAlpha(76),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
              ),
              child: const Icon(Icons.send_rounded,
                  color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Starter chip ─────────────────────────────────────────────────────────────
class _StarterChip extends StatelessWidget {
  final String text;
  final bool isDark;
  final VoidCallback onTap;

  const _StarterChip({
    required this.text,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark
                ? const Color(0xFF334155)
                : const Color(0xFFEDE9FE),
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.auto_awesome_outlined,
                size: 16, color: _violetSoft),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark
                      ? const Color(0xFFCBD5E1)
                      : const Color(0xFF475569),
                ),
              ),
            ),
            const Icon(Icons.chevron_right,
                size: 18, color: Color(0xFF94A3B8)),
          ],
        ),
      ),
    );
  }
}
