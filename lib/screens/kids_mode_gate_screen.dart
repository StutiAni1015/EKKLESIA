import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'child_selector_screen.dart';

// PIN stored locally — only gates the UI, not server data.
const _kPinKey = 'kids_mode_pin';

class KidsModeGateScreen extends StatefulWidget {
  const KidsModeGateScreen({super.key});

  @override
  State<KidsModeGateScreen> createState() => _KidsModeGateScreenState();
}

class _KidsModeGateScreenState extends State<KidsModeGateScreen>
    with SingleTickerProviderStateMixin {
  static const _primary   = Color(0xFF1E3A5F);
  static const _accent    = Color(0xFFFF7947);
  static const _surface   = Color(0xFFF5F6F7);

  String  _entered   = '';
  bool    _isSetMode = false; // true = first time, set new PIN
  String  _confirm   = '';
  bool    _awaitConfirm = false;
  bool    _shaking   = false;
  late AnimationController _shakeCtrl;
  late Animation<double>   _shakeAnim;

  @override
  void initState() {
    super.initState();
    _shakeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _shakeAnim = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _shakeCtrl, curve: Curves.elasticOut));
    _checkPinExists();
  }

  @override
  void dispose() {
    _shakeCtrl.dispose();
    super.dispose();
  }

  Future<void> _checkPinExists() async {
    final prefs = await SharedPreferences.getInstance();
    final pin   = prefs.getString(_kPinKey);
    setState(() => _isSetMode = (pin == null || pin.isEmpty));
  }

  void _onDigit(String d) {
    if (_entered.length >= 4) return;
    setState(() => _entered += d);
    if (_entered.length == 4) _evaluate();
  }

  void _onDelete() => setState(() {
        if (_entered.isNotEmpty) _entered = _entered.substring(0, _entered.length - 1);
      });

  Future<void> _evaluate() async {
    await Future.delayed(const Duration(milliseconds: 100));

    if (_isSetMode) {
      if (!_awaitConfirm) {
        setState(() { _confirm = _entered; _entered = ''; _awaitConfirm = true; });
      } else {
        if (_entered == _confirm) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_kPinKey, _entered);
          if (mounted) _proceed();
        } else {
          _shake();
          setState(() { _entered = ''; _confirm = ''; _awaitConfirm = false; });
        }
      }
      return;
    }

    // Verify mode
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_kPinKey) ?? '';
    if (_entered == saved) {
      if (mounted) _proceed();
    } else {
      _shake();
      setState(() => _entered = '');
    }
  }

  void _shake() {
    HapticFeedback.mediumImpact();
    _shakeCtrl.forward(from: 0);
  }

  void _proceed() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const ChildSelectorScreen()),
    );
  }

  String get _title {
    if (_isSetMode) return _awaitConfirm ? 'Confirm PIN' : 'Create a PIN';
    return 'Parent Access';
  }

  String get _subtitle {
    if (_isSetMode) {
      return _awaitConfirm
          ? 'Enter the same PIN again to confirm'
          : 'Choose a 4-digit PIN to protect Kids Mode';
    }
    return 'Enter your PIN to open Kids Mode';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _surface,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 8)],
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: _primary),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // ── Lock icon ────────────────────────────────────────────────
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                color: _primary,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: _primary.withAlpha(60), blurRadius: 24, offset: const Offset(0, 8))],
              ),
              child: const Icon(Icons.lock_rounded, color: Colors.white, size: 36),
            ),
            const SizedBox(height: 24),

            Text(_title,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: _primary, letterSpacing: -0.4)),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(_subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.grey[600], height: 1.4)),
            ),
            const SizedBox(height: 40),

            // ── PIN dots ─────────────────────────────────────────────────
            AnimatedBuilder(
              animation: _shakeAnim,
              builder: (_, child) {
                final offset = _shakeCtrl.isAnimating
                    ? 12 * (1 - _shakeAnim.value) * ((_shakeAnim.value * 8).toInt() % 2 == 0 ? 1 : -1)
                    : 0.0;
                return Transform.translate(offset: Offset(offset, 0), child: child);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (i) {
                  final filled = i < _entered.length;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    width: 18, height: 18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: filled ? _primary : Colors.transparent,
                      border: Border.all(color: filled ? _primary : Colors.grey[400]!, width: 2),
                    ),
                  );
                }),
              ),
            ),

            const Spacer(),

            // ── Number pad ───────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 0, 40, 40),
              child: Column(
                children: [
                  for (final row in [['1','2','3'], ['4','5','6'], ['7','8','9'], ['','0','⌫']])
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: row.map((k) {
                          if (k.isEmpty) return const SizedBox(width: 72, height: 72);
                          return GestureDetector(
                            onTap: () {
                              HapticFeedback.selectionClick();
                              if (k == '⌫') _onDelete(); else _onDigit(k);
                            },
                            child: Container(
                              width: 72, height: 72,
                              decoration: BoxDecoration(
                                color: k == '⌫' ? Colors.transparent : Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: k == '⌫' ? [] : [
                                  BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 8, offset: const Offset(0, 2))
                                ],
                              ),
                              child: Center(
                                child: k == '⌫'
                                    ? const Icon(Icons.backspace_outlined, color: _primary, size: 22)
                                    : Text(k, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: _primary)),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                ],
              ),
            ),

            // ── Forgot PIN ──────────────────────────────────────────────
            if (!_isSetMode)
              GestureDetector(
                onTap: _showResetDialog,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Text('Forgot PIN?',
                      style: TextStyle(fontSize: 13, color: _accent, fontWeight: FontWeight.w600)),
                ),
              )
            else
              const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Reset PIN', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text(
            'This will clear your Kids Mode PIN. You will be asked to create a new one next time.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: _accent, foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove(_kPinKey);
              if (mounted) {
                Navigator.pop(context);
                setState(() { _entered = ''; _isSetMode = true; _awaitConfirm = false; _confirm = ''; });
              }
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}
