import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class CreatePollScreen extends StatefulWidget {
  const CreatePollScreen({super.key});

  @override
  State<CreatePollScreen> createState() => _CreatePollScreenState();
}

class _CreatePollScreenState extends State<CreatePollScreen> {
  final _questionCtrl = TextEditingController();
  final List<TextEditingController> _optionCtrls = [
    TextEditingController(),
    TextEditingController(),
  ];
  String _audience = 'All Members';
  DateTime? _expiryDate;
  bool _anonymous = false;
  bool _multiSelect = false;
  bool _submitting = false;
  bool _submitted = false;

  static const sage = Color(0xFFB6C9BB);
  static const babyBlue = Color(0xFFB9CFDF);

  static const _audiences = [
    'All Members',
    'Committee Members',
    'Worship Team',
    'Youth Ministry',
    'Small Group Leaders',
  ];

  @override
  void dispose() {
    _questionCtrl.dispose();
    for (final c in _optionCtrls) {
      c.dispose();
    }
    super.dispose();
  }

  void _addOption() {
    if (_optionCtrls.length >= 6) return;
    setState(() => _optionCtrls.add(TextEditingController()));
  }

  void _removeOption(int i) {
    if (_optionCtrls.length <= 2) return;
    final ctrl = _optionCtrls.removeAt(i);
    ctrl.dispose();
    setState(() {});
  }

  Future<void> _pickExpiry() async {
    final d = await showDatePicker(
      context: context,
      initialDate:
          DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (d != null) setState(() => _expiryDate = d);
  }

  Future<void> _submit() async {
    if (_questionCtrl.text.trim().isEmpty) return;
    setState(() => _submitting = true);
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;
    setState(() {
      _submitting = false;
      _submitted = true;
    });
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Poll published to community!'),
        backgroundColor: sage,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
    Navigator.maybePop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg =
        isDark ? AppColors.backgroundDark : const Color(0xFFF8F6F6);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textColor =
        isDark ? Colors.white : const Color(0xFF1E293B);
    final subColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final borderColor =
        isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final inputBg =
        isDark ? const Color(0xFF1E293B) : Colors.white;

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
                      'Create Poll',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: sage.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.poll_outlined,
                            color: sage, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          'New Poll',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? const Color(0xFFCBD5E1)
                                : const Color(0xFF374151),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: borderColor),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                    16, 20, 16,
                    MediaQuery.of(context).padding.bottom + 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hero icon
                    Center(
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: sage.withOpacity(0.12),
                          border: Border.all(
                              color: sage.withOpacity(0.3)),
                        ),
                        child: Icon(Icons.how_to_vote_outlined,
                            color: sage, size: 30),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: Text(
                        'Community Poll',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: textColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Center(
                      child: Text(
                        'Gather structured input from your members',
                        style: TextStyle(
                            fontSize: 13, color: subColor),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Question
                    _Label('Poll Question', textColor),
                    Container(
                      decoration: BoxDecoration(
                        color: inputBg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: borderColor),
                      ),
                      child: TextField(
                        controller: _questionCtrl,
                        maxLines: 3,
                        style:
                            TextStyle(fontSize: 14, color: textColor),
                        decoration: InputDecoration(
                          hintText:
                              'e.g. What time should Sunday service start?',
                          hintStyle: TextStyle(
                              fontSize: 13,
                              color: subColor.withOpacity(0.7),
                              height: 1.5),
                          contentPadding: const EdgeInsets.all(14),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Options
                    Row(
                      children: [
                        _Label('Answer Options', textColor),
                        const Spacer(),
                        Text(
                          '${_optionCtrls.length}/6',
                          style: TextStyle(
                              fontSize: 11, color: subColor),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ...List.generate(_optionCtrls.length, (i) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: sage.withOpacity(0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  String.fromCharCode(65 + i),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: sage,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  color: inputBg,
                                  borderRadius:
                                      BorderRadius.circular(12),
                                  border:
                                      Border.all(color: borderColor),
                                ),
                                child: TextField(
                                  controller: _optionCtrls[i],
                                  style: TextStyle(
                                      fontSize: 14, color: textColor),
                                  decoration: InputDecoration(
                                    hintText: 'Option ${i + 1}',
                                    hintStyle: TextStyle(
                                        fontSize: 13,
                                        color: subColor),
                                    contentPadding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 14),
                                    border: InputBorder.none,
                                    isDense: true,
                                  ),
                                ),
                              ),
                            ),
                            if (_optionCtrls.length > 2)
                              GestureDetector(
                                onTap: () => _removeOption(i),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8),
                                  child: Icon(Icons.remove_circle_outline,
                                      color: const Color(0xFFEF4444),
                                      size: 20),
                                ),
                              ),
                          ],
                        ),
                      );
                    }),
                    if (_optionCtrls.length < 6)
                      GestureDetector(
                        onTap: _addOption,
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: sage.withOpacity(0.4),
                                style: BorderStyle.solid),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.add_circle_outline,
                                    color: sage, size: 18),
                                const SizedBox(width: 6),
                                Text(
                                  'Add Option',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: sage,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),

                    // Settings row
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              _Label('Audience', textColor),
                              Container(
                                height: 48,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12),
                                decoration: BoxDecoration(
                                  color: inputBg,
                                  borderRadius:
                                      BorderRadius.circular(12),
                                  border: Border.all(
                                      color: borderColor),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _audience,
                                    isExpanded: true,
                                    dropdownColor: inputBg,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: textColor),
                                    icon: Icon(
                                        Icons.keyboard_arrow_down,
                                        color: subColor,
                                        size: 18),
                                    items: _audiences
                                        .map((a) => DropdownMenuItem(
                                            value: a,
                                            child: Text(a,
                                                overflow:
                                                    TextOverflow.ellipsis)))
                                        .toList(),
                                    onChanged: (v) {
                                      if (v != null)
                                        setState(
                                            () => _audience = v);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              _Label('Expires', textColor),
                              GestureDetector(
                                onTap: _pickExpiry,
                                child: Container(
                                  height: 48,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: inputBg,
                                    borderRadius:
                                        BorderRadius.circular(12),
                                    border: Border.all(
                                        color: borderColor),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                          Icons.calendar_today_outlined,
                                          size: 14,
                                          color: subColor),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          _expiryDate == null
                                              ? 'Pick date'
                                              : '${_expiryDate!.day}/${_expiryDate!.month}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: _expiryDate == null
                                                ? subColor
                                                : textColor,
                                          ),
                                          overflow:
                                              TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Toggles
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: borderColor),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.visibility_off_outlined,
                                  color: babyBlue, size: 18),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text('Anonymous Voting',
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: textColor)),
                                    Text('Responses won\'t show names',
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: subColor)),
                                  ],
                                ),
                              ),
                              Switch.adaptive(
                                value: _anonymous,
                                onChanged: (v) =>
                                    setState(() => _anonymous = v),
                                activeColor: babyBlue,
                              ),
                            ],
                          ),
                          Divider(
                              height: 1,
                              color: borderColor),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.checklist_outlined,
                                  color: sage, size: 18),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text('Allow Multi-select',
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: textColor)),
                                    Text(
                                        'Members can pick more than one',
                                        style: TextStyle(
                                            fontSize: 11,
                                            color: subColor)),
                                  ],
                                ),
                              ),
                              Switch.adaptive(
                                value: _multiSelect,
                                onChanged: (v) =>
                                    setState(() => _multiSelect = v),
                                activeColor: sage,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Publish button
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton.icon(
                        onPressed:
                            (_submitting || _submitted) ? null : _submit,
                        icon: Icon(
                          _submitted
                              ? Icons.check
                              : Icons.send_outlined,
                          size: 20,
                        ),
                        label: _submitting
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Text(
                                _submitted
                                    ? 'Poll Published!'
                                    : 'Publish Poll',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              _submitted ? const Color(0xFF22C55E) : sage,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: (_submitted
                                  ? const Color(0xFF22C55E)
                                  : sage)
                              .withOpacity(0.5),
                          elevation: 6,
                          shadowColor: sage.withOpacity(0.35),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        'Only committee members can create polls',
                        style: TextStyle(
                            fontSize: 11,
                            color: subColor.withOpacity(0.6)),
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
  }
}

class _Label extends StatelessWidget {
  final String text;
  final Color textColor;
  const _Label(this.text, this.textColor);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: textColor.withOpacity(0.8),
        ),
      ),
    );
  }
}
