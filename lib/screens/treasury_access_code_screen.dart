import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/app_colors.dart';
import '../core/user_session.dart';

/// Screen for the pastor or treasurer to generate a temporary treasury
/// access code (10 or 15 minutes). The code is displayed large and can be
/// shared verbally or via copy. It auto-expires after the chosen duration.
class TreasuryAccessCodeScreen extends StatefulWidget {
  /// 'Pastor' or 'Treasurer' — shown in the audit trail label
  final String role;

  const TreasuryAccessCodeScreen({
    super.key,
    this.role = 'Pastor',
  });

  @override
  State<TreasuryAccessCodeScreen> createState() =>
      _TreasuryAccessCodeScreenState();
}

class _TreasuryAccessCodeScreenState extends State<TreasuryAccessCodeScreen> {
  int _selectedMinutes = 10; // 10 or 15
  Timer? _ticker;

  // Live remaining time while a code is active
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _startTicker();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  void _startTicker() {
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      final code = treasuryUnlockCodeNotifier.value;
      if (code == null) {
        setState(() => _remaining = Duration.zero);
      } else if (code.isExpired) {
        // Auto-clear expired code
        treasuryUnlockCodeNotifier.value = null;
        setState(() => _remaining = Duration.zero);
      } else {
        setState(() => _remaining = code.expiresAt.difference(DateTime.now()));
      }
    });
  }

  void _generateCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'; // no 0/O/I/1 confusion
    final rng = Random.secure();
    final code = List.generate(6, (_) => chars[rng.nextInt(chars.length)])
        .join();

    treasuryUnlockCodeNotifier.value = TreasuryUnlockCode(
      code: code,
      durationMinutes: _selectedMinutes,
      createdAt: DateTime.now(),
      generatedBy: widget.role,
    );
    setState(() {});
  }

  void _revokeCode() {
    treasuryUnlockCodeNotifier.value = null;
    // Also clear any active member sessions
    treasuryAccessNotifier.value = null;
    setState(() {});
  }

  void _copyCode(String code) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 16),
            const SizedBox(width: 8),
            Text('Code "$code" copied to clipboard'),
          ],
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _fmtDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor =
        isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    return ValueListenableBuilder<TreasuryUnlockCode?>(
      valueListenable: treasuryUnlockCodeNotifier,
      builder: (context, activeCode, _) {
        final hasActive = activeCode != null && !activeCode.isExpired;

        return Scaffold(
          backgroundColor: bg,
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 4, 16, 4),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: textColor),
                        onPressed: () => Navigator.maybePop(context),
                      ),
                      Expanded(
                        child: Text(
                          'Treasury Access Code',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.3,
                            color: textColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                        24, 8, 24,
                        MediaQuery.of(context).padding.bottom + 32),
                    child: Column(
                      children: [
                        // Role badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(99),
                            border: Border.all(
                                color: AppColors.primary.withOpacity(0.2)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.admin_panel_settings,
                                  color: AppColors.primary, size: 14),
                              const SizedBox(width: 6),
                              Text(
                                '${widget.role} — Treasury Control',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),

                        if (hasActive) ...[
                          // ── Active code display ──────────────────────────
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFF1E293B),
                                  Color(0xFF0F172A),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.25),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // Active badge
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF22C55E)
                                        .withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(99),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 6,
                                        height: 6,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xFF22C55E),
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      const Text(
                                        'ACTIVE CODE',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 1,
                                          color: Color(0xFF22C55E),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // The code itself
                                Text(
                                  activeCode.code,
                                  style: const TextStyle(
                                    fontSize: 52,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    letterSpacing: 10,
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // Expiry countdown
                                Text(
                                  'Expires in ${_fmtDuration(_remaining)}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: _remaining.inSeconds < 120
                                        ? const Color(0xFFFBBF24)
                                        : Colors.white54,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),

                                // Progress bar
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: (_remaining.inSeconds /
                                            (activeCode.durationMinutes * 60))
                                        .clamp(0.0, 1.0),
                                    backgroundColor:
                                        Colors.white.withOpacity(0.1),
                                    valueColor: AlwaysStoppedAnimation(
                                      _remaining.inSeconds < 120
                                          ? const Color(0xFFFBBF24)
                                          : AppColors.primary,
                                    ),
                                    minHeight: 4,
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Copy + Revoke row
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton.icon(
                                        onPressed: () =>
                                            _copyCode(activeCode.code),
                                        icon: const Icon(
                                            Icons.copy_rounded,
                                            size: 16),
                                        label: const Text('Copy Code'),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: Colors.white70,
                                          side: const BorderSide(
                                              color: Colors.white24),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: _revokeCode,
                                        icon: const Icon(
                                            Icons.block_rounded,
                                            size: 16),
                                        label: const Text('Revoke'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFFEF4444),
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          elevation: 0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Audit info
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: cardBg,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: borderColor),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.history_outlined,
                                    color: AppColors.primary, size: 18),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Generated by ${activeCode.generatedBy} · '
                                    '${activeCode.durationMinutes} min window · '
                                    '${activeCode.createdAt.hour.toString().padLeft(2, '0')}:'
                                    '${activeCode.createdAt.minute.toString().padLeft(2, '0')}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: subColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        ] else ...[
                          // ── No active code — generate UI ─────────────────
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: cardBg,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: borderColor),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Generate Access Code',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: textColor,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Select how long members should have access. '
                                  'The code expires automatically.',
                                  style: TextStyle(
                                    fontSize: 13,
                                    height: 1.5,
                                    color: subColor,
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // Duration selector
                                Text(
                                  'ACCESS DURATION',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.5,
                                    color: subColor,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [10, 15].map((min) {
                                    final selected = _selectedMinutes == min;
                                    return Expanded(
                                      child: GestureDetector(
                                        onTap: () => setState(
                                            () => _selectedMinutes = min),
                                        child: AnimatedContainer(
                                          duration: const Duration(
                                              milliseconds: 200),
                                          margin: EdgeInsets.only(
                                              right: min == 10 ? 8 : 0),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 14),
                                          decoration: BoxDecoration(
                                            color: selected
                                                ? AppColors.primary
                                                    .withOpacity(0.08)
                                                : Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                              color: selected
                                                  ? AppColors.primary
                                                  : borderColor,
                                              width: selected ? 2 : 1,
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              Text(
                                                '$min',
                                                style: TextStyle(
                                                  fontSize: 26,
                                                  fontWeight: FontWeight.w800,
                                                  color: selected
                                                      ? AppColors.primary
                                                      : textColor,
                                                ),
                                              ),
                                              Text(
                                                'MINUTES',
                                                style: TextStyle(
                                                  fontSize: 9,
                                                  letterSpacing: 1,
                                                  fontWeight: selected
                                                      ? FontWeight.w700
                                                      : FontWeight.normal,
                                                  color: selected
                                                      ? AppColors.primary
                                                      : subColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Generate button
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton.icon(
                              onPressed: _generateCode,
                              icon: const Icon(Icons.vpn_key_rounded, size: 20),
                              label: Text(
                                'Generate $_selectedMinutes-Minute Code',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                elevation: 4,
                                shadowColor: AppColors.primary.withOpacity(0.3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Locked state visual hint
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF0F172A)
                                  : const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: borderColor),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.lock_rounded,
                                    color: Color(0xFFEF4444), size: 22),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Treasury is Currently Locked',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: textColor,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        'Members cannot access treasury until '
                                        'you generate an active code.',
                                        style: TextStyle(
                                          fontSize: 12,
                                          height: 1.4,
                                          color: subColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],

                        const SizedBox(height: 24),

                        // How it works section
                        _HowItWorks(isDark: isDark, subColor: subColor,
                            textColor: textColor),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HowItWorks extends StatelessWidget {
  final bool isDark;
  final Color subColor;
  final Color textColor;

  const _HowItWorks(
      {required this.isDark,
      required this.subColor,
      required this.textColor});

  @override
  Widget build(BuildContext context) {
    final borderColor =
        isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How It Works',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 12),
          ...[
            _Step(n: '1', text: 'Choose 10 or 15 minutes and tap Generate.'),
            _Step(n: '2',
                text: 'Share the 6-character code verbally with the member.'),
            _Step(n: '3',
                text: 'Member enters the code on the treasury lock screen.'),
            _Step(n: '4',
                text:
                    'Access expires automatically — no manual locking needed.'),
            _Step(n: '5',
                text: 'Tap Revoke at any time to lock treasury immediately.'),
          ].map((s) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary.withOpacity(0.12),
                      ),
                      child: Center(
                        child: Text(
                          s.n,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        s.text,
                        style: TextStyle(fontSize: 12, color: subColor, height: 1.4),
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class _Step {
  final String n;
  final String text;
  const _Step({required this.n, required this.text});
}
