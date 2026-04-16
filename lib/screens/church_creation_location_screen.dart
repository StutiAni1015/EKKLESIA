import 'package:flutter/material.dart';
import '../core/user_session.dart';
import 'church_creation_media_screen.dart';

const _indigo = Color(0xFF4F46E5);
const _indigoLight = Color(0xFFE0E7FF);

class ChurchCreationLocationScreen extends StatefulWidget {
  const ChurchCreationLocationScreen({super.key});

  @override
  State<ChurchCreationLocationScreen> createState() =>
      _ChurchCreationLocationScreenState();
}

class _ChurchCreationLocationScreenState
    extends State<ChurchCreationLocationScreen> {
  final _addressCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  String? _country;

  static const _countries = [
    ('US', 'United States'),
    ('UK', 'United Kingdom'),
    ('NG', 'Nigeria'),
    ('CA', 'Canada'),
    ('AU', 'Australia'),
    ('ZA', 'South Africa'),
  ];

  @override
  void dispose() {
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final draft = churchDraftNotifier.value;
    draft.address = _addressCtrl.text.trim();
    draft.city    = _cityCtrl.text.trim();
    draft.country = _country ?? '';
    draft.phone   = _phoneCtrl.text.trim();
    draft.email   = _emailCtrl.text.trim();
    churchDraftNotifier.notifyListeners();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ChurchCreationMediaScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final subColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final inputBg = isDark ? const Color(0xFF1E293B) : Colors.white;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF221610),
                    const Color(0xFF1E293B),
                  ]
                : [
                    const Color(0xFFFDFCFB),
                    const Color(0xFFE2D1C3),
                  ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 448),
              child: Column(
                children: [
                  // Glass card wrapper
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF1E293B).withOpacity(0.8)
                              : Colors.white.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(36),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          children: [
                            // Header
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  24, 28, 24, 0),
                              child: Column(
                                children: [
                                  // Step dots
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      _StepDot(active: false),
                                      const SizedBox(width: 6),
                                      _StepDot(active: true, wide: true),
                                      const SizedBox(width: 6),
                                      _StepDot(active: false),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'Location & Contact',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                      color: textColor,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Help people find your church',
                                    style: TextStyle(
                                        fontSize: 13, color: subColor),
                                  ),
                                ],
                              ),
                            ),

                            // Scrollable form
                            Expanded(
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.fromLTRB(
                                    24, 20, 24, 100),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    // Address
                                    _Label('Church Address', subColor),
                                    const SizedBox(height: 6),
                                    _GlassInput(
                                      controller: _addressCtrl,
                                      hint:
                                          'Street address, building name, floor...',
                                      maxLines: 3,
                                      bg: inputBg,
                                      textColor: textColor,
                                      hintColor: subColor,
                                    ),
                                    const SizedBox(height: 16),

                                    // City + Country row
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              _Label('City', subColor),
                                              const SizedBox(height: 6),
                                              _GlassInput(
                                                controller: _cityCtrl,
                                                hint: 'e.g. London',
                                                bg: inputBg,
                                                textColor: textColor,
                                                hintColor: subColor,
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
                                              _Label('Country', subColor),
                                              const SizedBox(height: 6),
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: inputBg,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          18),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(
                                                              0.05),
                                                      blurRadius: 6,
                                                    ),
                                                  ],
                                                ),
                                                padding: const EdgeInsets
                                                    .symmetric(
                                                    horizontal: 12),
                                                child:
                                                    DropdownButtonHideUnderline(
                                                  child:
                                                      DropdownButton<String>(
                                                    value: _country,
                                                    hint: Text(
                                                      'Select...',
                                                      style: TextStyle(
                                                          color: subColor,
                                                          fontSize: 13),
                                                    ),
                                                    isExpanded: true,
                                                    dropdownColor: inputBg,
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: textColor,
                                                    ),
                                                    icon: Icon(
                                                        Icons.expand_more,
                                                        color: subColor,
                                                        size: 18),
                                                    items: _countries
                                                        .map((c) =>
                                                            DropdownMenuItem(
                                                              value: c.$1,
                                                              child: Text(
                                                                  c.$2),
                                                            ))
                                                        .toList(),
                                                    onChanged: (v) =>
                                                        setState(() =>
                                                            _country = v),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),

                                    // Map placeholder
                                    _Label('Location Verification',
                                        subColor),
                                    const SizedBox(height: 6),
                                    Container(
                                      height: 148,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: isDark
                                            ? const Color(0xFF0F172A)
                                            : _indigoLight,
                                        borderRadius:
                                            BorderRadius.circular(20),
                                        border: Border.all(
                                          color: Colors.white
                                              .withOpacity(0.4),
                                          width: 3,
                                        ),
                                      ),
                                      child: Stack(
                                        children: [
                                          // Dot grid
                                          Positioned.fill(
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      17),
                                              child: CustomPaint(
                                                painter: _DotGridPainter(
                                                    isDark: isDark),
                                              ),
                                            ),
                                          ),

                                          // Bouncing pin
                                          Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                _BouncingPin(),
                                                Container(
                                                  width: 16,
                                                  height: 4,
                                                  decoration: BoxDecoration(
                                                    color: Colors.black
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius
                                                            .circular(99),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          // Label
                                          Positioned(
                                            bottom: 8,
                                            right: 10,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                              decoration: BoxDecoration(
                                                color: isDark
                                                    ? Colors.black
                                                        .withOpacity(0.6)
                                                    : Colors.white
                                                        .withOpacity(0.8),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        6),
                                              ),
                                              child: Text(
                                                'MAP PREVIEW',
                                                style: TextStyle(
                                                  fontSize: 9,
                                                  fontWeight:
                                                      FontWeight.bold,
                                                  letterSpacing: 1.5,
                                                  color: subColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 16),

                                    // Phone
                                    _Label('Phone Number', subColor),
                                    const SizedBox(height: 6),
                                    _GlassInput(
                                      controller: _phoneCtrl,
                                      hint: '+1 (234) 567-890',
                                      keyboardType: TextInputType.phone,
                                      bg: inputBg,
                                      textColor: textColor,
                                      hintColor: subColor,
                                    ),
                                    const SizedBox(height: 16),

                                    // Email
                                    _Label('Official Email', subColor),
                                    const SizedBox(height: 6),
                                    _GlassInput(
                                      controller: _emailCtrl,
                                      hint: 'contact@yourchurch.org',
                                      keyboardType:
                                          TextInputType.emailAddress,
                                      bg: inputBg,
                                      textColor: textColor,
                                      hintColor: subColor,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Back + Next Step buttons
                  Container(
                    padding: EdgeInsets.fromLTRB(
                        16,
                        12,
                        16,
                        MediaQuery.of(context).padding.bottom + 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: isDark
                            ? [
                                Colors.transparent,
                                const Color(0xFF221610),
                              ]
                            : [
                                Colors.transparent,
                                const Color(0xFFE2D1C3),
                              ],
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 54,
                            child: OutlinedButton(
                              onPressed: () =>
                                  Navigator.maybePop(context),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: isDark
                                      ? const Color(0xFF334155)
                                      : const Color(0xFFE2E8F0),
                                ),
                                backgroundColor: isDark
                                    ? const Color(0xFF1E293B)
                                    : const Color(0xFFF1F5F9),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(18),
                                ),
                              ),
                              child: Text(
                                'Back',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? const Color(0xFFCBD5E1)
                                      : const Color(0xFF475569),
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
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _indigo,
                                foregroundColor: Colors.white,
                                elevation: 6,
                                shadowColor:
                                    _indigoLight.withOpacity(0.8),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(18),
                                ),
                              ),
                              child: const Text(
                                'Next Step',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
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
          ),
        ),
      ),
    );
  }
}

// ─── Supporting widgets ──────────────────────────────────────────

class _StepDot extends StatelessWidget {
  final bool active;
  final bool wide;
  const _StepDot({required this.active, this.wide = false});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: wide ? 32 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: active ? _indigo : const Color(0xFFCBD5E1),
        borderRadius: BorderRadius.circular(99),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  final Color color;
  const _Label(this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: color,
      ),
    );
  }
}

class _GlassInput extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final TextInputType? keyboardType;
  final Color bg;
  final Color textColor;
  final Color hintColor;

  const _GlassInput({
    required this.controller,
    required this.hint,
    this.maxLines = 1,
    this.keyboardType,
    required this.bg,
    required this.textColor,
    required this.hintColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: TextStyle(fontSize: 14, color: textColor),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: hintColor, fontSize: 14),
          contentPadding: const EdgeInsets.all(16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide:
                const BorderSide(color: _indigo, width: 1.5),
          ),
          filled: true,
          fillColor: bg,
        ),
      ),
    );
  }
}

class _BouncingPin extends StatefulWidget {
  @override
  State<_BouncingPin> createState() => _BouncingPinState();
}

class _BouncingPinState extends State<_BouncingPin>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0, end: -8).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Transform.translate(
        offset: Offset(0, _anim.value),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.red.shade400,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2.5),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Center(
            child: CircleAvatar(
              radius: 4,
              backgroundColor: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _DotGridPainter extends CustomPainter {
  final bool isDark;
  _DotGridPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (isDark ? Colors.white : const Color(0xFF94A3B8))
          .withOpacity(0.2)
      ..style = PaintingStyle.fill;
    const spacing = 20.0;
    const radius = 1.5;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DotGridPainter old) => old.isDark != isDark;
}
