import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../service/api_service.dart';
import 'kids_home_screen.dart';

// ── Full question pool (rotates daily) ───────────────────────────────────────
const _pool = [
  _Question('What was the first thing God created?',
      [_Option('Light','💡'),_Option('Water','💧'),_Option('Trees','🌲'),_Option('Animals','🐾')], 0),
  _Question('How many loaves did Jesus use to feed 5,000 people?',
      [_Option('5 Loaves','🍞'),_Option('10 Loaves','🔢'),_Option('2 Loaves','2️⃣'),_Option('7 Loaves','7️⃣')], 0),
  _Question('Who built a big ark to save animals from the flood?',
      [_Option('Moses','🧔'),_Option('Noah','⛵'),_Option('David','⭐'),_Option('Abraham','👴')], 1),
  _Question('How many days after death did Jesus rise again?',
      [_Option('1 Day','1️⃣'),_Option('2 Days','2️⃣'),_Option('3 Days','3️⃣'),_Option('7 Days','7️⃣')], 2),
  _Question('Who was swallowed by a giant fish?',
      [_Option('Elijah','🔥'),_Option('Jonah','🐳'),_Option('Paul','⚓'),_Option('Peter','🌊')], 1),
  _Question('What did Jesus turn water into at the wedding in Cana?',
      [_Option('Juice','🧃'),_Option('Wine','🍷'),_Option('Milk','🥛'),_Option('Oil','🫙')], 1),
  _Question('How many disciples did Jesus choose?',
      [_Option('7','7️⃣'),_Option('10','🔟'),_Option('12','🔢'),_Option('14','🔢')], 2),
  _Question('Who betrayed Jesus for 30 pieces of silver?',
      [_Option('Peter','🐟'),_Option('Thomas','🤔'),_Option('Judas','💰'),_Option('James','🎣')], 2),
  _Question('What did David use to defeat Goliath?',
      [_Option('Sword','⚔️'),_Option('Arrow','🏹'),_Option('Slingshot','🪃'),_Option('Spear','🗡️')], 2),
  _Question('In which city was Jesus born?',
      [_Option('Jerusalem','🕌'),_Option('Nazareth','🏘️'),_Option('Bethlehem','⭐'),_Option('Jericho','🌴')], 2),
  _Question('Who was the mother of Jesus?',
      [_Option('Martha','🏡'),_Option('Mary','👼'),_Option('Ruth','🌾'),_Option('Esther','👑')], 1),
  _Question('What did God use to lead the Israelites by night in the desert?',
      [_Option('Star','⭐'),_Option('Angel','👼'),_Option('Pillar of Fire','🔥'),_Option('Cloud','☁️')], 2),
  _Question('How many days was Jonah inside the fish?',
      [_Option('1 Day','1️⃣'),_Option('2 Days','2️⃣'),_Option('3 Days','3️⃣'),_Option('7 Days','7️⃣')], 2),
  _Question('Who was the strongest man in the Bible?',
      [_Option('Goliath','🦁'),_Option('Solomon','👑'),_Option('Samson','💪'),_Option('Moses','🪨')], 2),
  _Question('What river did Jesus get baptised in?',
      [_Option('Nile','🌊'),_Option('Jordan','💧'),_Option('Euphrates','🏞️'),_Option('Tigris','🌿')], 1),
  _Question('Which book of the Bible comes first?',
      [_Option('Exodus','🌵'),_Option('Psalms','🎵'),_Option('Genesis','🌍'),_Option('Matthew','📖')], 2),
  _Question('What did the wise men follow to find baby Jesus?',
      [_Option('A dove','🕊️'),_Option('An angel','👼'),_Option('A star','⭐'),_Option('A map','🗺️')], 2),
  _Question('Who wrote most of the Psalms?',
      [_Option('Solomon','👑'),_Option('Moses','🪨'),_Option('David','🎵'),_Option('Elijah','🔥')], 2),
  _Question('What was the name of the garden where Adam and Eve lived?',
      [_Option('Gethsemane','🌿'),_Option('Eden','🌺'),_Option('Canaan','🏔️'),_Option('Galilee','🌊')], 1),
  _Question('Who did God ask to sacrifice his son as a test of faith?',
      [_Option('Moses','🌵'),_Option('Noah','⛵'),_Option('Abraham','🔥'),_Option('Isaac','🐑')], 2),
];

// Returns today's date string YYYY-MM-DD
String _todayKey() {
  final now = DateTime.now();
  return '${now.year}-${now.month.toString().padLeft(2,'0')}-${now.day.toString().padLeft(2,'0')}';
}

// Picks 5 questions for today based on a date-derived seed (rotates every day)
List<_Question> _dailyQuestions() {
  final now  = DateTime.now();
  final seed = now.year * 1000 + now.month * 31 + now.day;
  final start = seed % (_pool.length - 4); // ensure room for 5
  final indices = List.generate(5, (i) => (start + i * 3) % _pool.length);
  return indices.map((i) => _pool[i]).toList();
}

// ── Screen ────────────────────────────────────────────────────────────────────

class QuizTimeScreen extends StatefulWidget {
  final Map<String, dynamic>? child;
  const QuizTimeScreen({super.key, this.child});

  @override
  State<QuizTimeScreen> createState() => _QuizTimeScreenState();
}

class _QuizTimeScreenState extends State<QuizTimeScreen> {
  late List<_Question> _questions;

  int  _current  = 0;
  int? _selected;
  bool _answered = false;
  int  _score    = 0;
  bool _done     = false;

  bool _checking      = true;
  bool _alreadyDone   = false;
  int  _previousScore = 0;

  String get _childId  => widget.child?['_id'] as String? ?? 'guest';
  String get _today    => _todayKey();
  String get _doneKey  => 'quiz_done_${_childId}_$_today';
  String get _scoreKey => 'quiz_score_${_childId}_$_today';

  @override
  void initState() {
    super.initState();
    _questions = _dailyQuestions(); // fallback until AI loads
    _init();
  }

  Future<void> _init() async {
    // Try AI-generated questions (3-second timeout before falling back)
    try {
      final aiData = await ApiService.fetchDailyQuiz()
          .timeout(const Duration(seconds: 3));
      if (aiData != null && aiData.length >= 5 && mounted) {
        _questions = aiData.map((q) => _Question(
          q['question'] as String,
          (q['options'] as List).map((o) =>
              _Option(o['label'] as String, o['emoji'] as String)).toList(),
          q['correctIndex'] as int,
        )).toList();
      }
    } catch (_) {}

    final prefs = await SharedPreferences.getInstance();
    final done  = prefs.getBool(_doneKey) ?? false;
    final score = prefs.getInt(_scoreKey) ?? 0;
    if (mounted) setState(() { _checking = false; _alreadyDone = done; _previousScore = score; });
  }

  Future<void> _saveCompletion(int score) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_doneKey,  true);
    await prefs.setInt(_scoreKey,  score);
    final childId = widget.child?['_id'] as String?;
    if (childId != null) {
      final currentPts = (widget.child?['totalPoints'] as int?) ?? 0;
      ApiService.updateKidsProfile(childId, {'totalPoints': currentPts + (score * 10)})
          .catchError((_) => <String, dynamic>{});
    }
  }

  void _pick(int i) {
    if (_answered) return;
    setState(() {
      _selected = i;
      _answered = true;
      if (i == _questions[_current].correctIndex) _score++;
    });
  }

  void _next() {
    if (_current < _questions.length - 1) {
      setState(() { _current++; _selected = null; _answered = false; });
    } else {
      _saveCompletion(_score);
      setState(() { _done = true; _alreadyDone = true; _previousScore = _score; });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) {
      return const Scaffold(
        backgroundColor: kKidsSurface,
        body: Center(child: CircularProgressIndicator(color: kKidsPrimary)),
      );
    }

    if (_alreadyDone && !_done) {
      return _CompletedScreen(score: _previousScore, total: _questions.length, child: widget.child);
    }

    if (_done) return _Results(score: _score, total: _questions.length, child: widget.child);

    final q        = _questions[_current];
    final progress = _current / _questions.length;

    return Scaffold(
      backgroundColor: kKidsSurface,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => KidsHomeScreen(child: widget.child))),
                    child: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: kKidsSurfaceContLowest,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 8)],
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: kKidsPrimary),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Quiz Time 🎯',
                            style: GoogleFonts.plusJakartaSans(
                                fontSize: 18, fontWeight: FontWeight.w900, color: kKidsPrimary)),
                        Text("Today's daily quiz · refreshes tomorrow",
                            style: GoogleFonts.plusJakartaSans(
                                fontSize: 10, color: kKidsOnSurfaceVariant)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: kKidsTertiaryContainer.withAlpha(90),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.stars_rounded, color: kKidsTertiary, size: 16),
                        const SizedBox(width: 4),
                        Text('$_score pts',
                            style: GoogleFonts.plusJakartaSans(
                                fontWeight: FontWeight.w800, fontSize: 13, color: kKidsTertiary)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Progress ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Question ${_current + 1} of ${_questions.length}',
                          style: GoogleFonts.plusJakartaSans(
                              fontSize: 11, fontWeight: FontWeight.w800,
                              letterSpacing: 0.8, color: kKidsOnSurfaceVariant)),
                      Text('${(progress * 100).round()}% Complete',
                          style: GoogleFonts.plusJakartaSans(
                              fontSize: 11, fontWeight: FontWeight.w800,
                              letterSpacing: 0.8, color: kKidsPrimary)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: LinearProgressIndicator(
                      value: progress, minHeight: 10,
                      backgroundColor: const Color(0xFFE0E3E4),
                      valueColor: const AlwaysStoppedAnimation<Color>(kKidsPrimaryContainer),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: Column(
                  children: [
                    _QuestionCard(question: q.question),
                    const SizedBox(height: 20),
                    _OptionsGrid(
                      options: q.options,
                      correctIndex: q.correctIndex,
                      selected: _selected,
                      answered: _answered,
                      onPick: _pick,
                    ),
                    if (_answered) ...[
                      const SizedBox(height: 20),
                      _FeedbackBanner(
                        correct: _selected == q.correctIndex,
                        correctLabel: q.options[q.correctIndex].label,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity, height: 56,
                        child: ElevatedButton(
                          onPressed: _next,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kKidsPrimary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                            elevation: 6,
                            shadowColor: kKidsPrimary.withAlpha(90),
                          ),
                          child: Text(
                            _current == _questions.length - 1 ? 'See Results 🏆' : 'Next Question →',
                            style: GoogleFonts.plusJakartaSans(
                                fontSize: 16, fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            KidsBottomNav(activeIndex: kKidsTabQuiz, child: widget.child),
          ],
        ),
      ),
    );
  }
}

// ── Question card ─────────────────────────────────────────────────────────────

class _QuestionCard extends StatelessWidget {
  final String question;
  const _QuestionCard({required this.question});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: kKidsSurfaceContLowest,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(16),
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(40),
        ),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 24, offset: const Offset(0, 6))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: kKidsErrorContainer.withAlpha(40),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text('DAILY QUIZ',
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 10, fontWeight: FontWeight.w900,
                    color: const Color(0xFF9F0519), letterSpacing: 1.2)),
          ),
          const SizedBox(height: 16),
          Text(question,
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 22, fontWeight: FontWeight.w800,
                  color: kKidsOnSurface, height: 1.3, letterSpacing: -0.3)),
        ],
      ),
    );
  }
}

// ── Options grid ──────────────────────────────────────────────────────────────

class _OptionsGrid extends StatelessWidget {
  final List<_Option> options;
  final int correctIndex;
  final int? selected;
  final bool answered;
  final void Function(int) onPick;

  const _OptionsGrid({
    required this.options, required this.correctIndex,
    required this.selected, required this.answered, required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.1,
      ),
      itemCount: options.length,
      itemBuilder: (_, i) {
        final isCorrect = answered && i == correctIndex;
        final isWrong   = answered && selected == i && i != correctIndex;
        final isPicked  = selected == i && !answered;

        final bgColor = isCorrect ? kKidsTertiaryContainer.withAlpha(60)
            : isWrong ? kKidsErrorContainer.withAlpha(40)
            : isPicked ? kKidsPrimaryContainer.withAlpha(30)
            : kKidsSurfaceContLowest;
        final borderColor = isCorrect ? kKidsTertiary
            : isWrong ? const Color(0xFFB31B25)
            : isPicked ? kKidsPrimary
            : Colors.transparent;
        final labelColor = isCorrect ? kKidsTertiary
            : isWrong ? const Color(0xFFB31B25)
            : kKidsOnSurface;

        return GestureDetector(
          onTap: () => onPick(i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderColor, width: 2.5),
              boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 12, offset: const Offset(0, 3))],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(options[i].emoji, style: const TextStyle(fontSize: 32)),
                const SizedBox(height: 10),
                Text(options[i].label,
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 14, fontWeight: FontWeight.w800, color: labelColor),
                    textAlign: TextAlign.center),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ── Feedback banner ───────────────────────────────────────────────────────────

class _FeedbackBanner extends StatelessWidget {
  final bool correct;
  final String correctLabel;
  const _FeedbackBanner({required this.correct, required this.correctLabel});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: correct ? kKidsTertiaryContainer.withAlpha(65) : kKidsErrorContainer.withAlpha(38),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Text(correct ? '🎉' : '😅', style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(correct ? 'Correct! Great job!' : 'Not quite right',
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 15, fontWeight: FontWeight.w800,
                        color: correct ? const Color(0xFF265600) : const Color(0xFF570008))),
                if (!correct)
                  Text('The answer is: $correctLabel',
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 12, color: const Color(0xFF570008))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Results screen ────────────────────────────────────────────────────────────

class _Results extends StatelessWidget {
  final int score;
  final int total;
  final Map<String, dynamic>? child;

  const _Results({required this.score, required this.total, this.child});

  @override
  Widget build(BuildContext context) {
    final pct     = (score / total * 100).round();
    final emoji   = pct >= 80 ? '🏆' : pct >= 60 ? '⭐' : '💪';
    final message = pct >= 80 ? "Amazing! You're a Bible champion!"
        : pct >= 60 ? 'Great job! Keep learning!'
        : 'Good try! Practice makes perfect!';

    return Scaffold(
      backgroundColor: kKidsSurface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 80)),
              const SizedBox(height: 20),
              Text('$score / $total',
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 56, fontWeight: FontWeight.w900,
                      color: kKidsPrimary, letterSpacing: -2)),
              const SizedBox(height: 8),
              Text(message, textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 20, fontWeight: FontWeight.w700,
                      color: kKidsOnSurface, height: 1.3)),
              const SizedBox(height: 6),
              Text('You scored $pct% · +${score * 10} points!',
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 13, color: kKidsTertiary, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: kKidsPrimaryContainer.withAlpha(25),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: kKidsPrimaryContainer.withAlpha(80)),
                ),
                child: Text('🔄 A new quiz waits for you tomorrow!',
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 12, color: kKidsPrimary, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity, height: 56,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => KidsHomeScreen(child: child)),
                    (r) => false,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kKidsPrimary, foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                    elevation: 6, shadowColor: kKidsPrimary.withAlpha(90),
                  ),
                  child: Text('Back to Kids Home 🏠',
                      style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w800)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Already-completed screen ──────────────────────────────────────────────────

class _CompletedScreen extends StatelessWidget {
  final int score;
  final int total;
  final Map<String, dynamic>? child;

  const _CompletedScreen({required this.score, required this.total, this.child});

  @override
  Widget build(BuildContext context) {
    final pct   = (score / total * 100).round();
    final emoji = pct >= 80 ? '🏆' : pct >= 60 ? '⭐' : '💪';
    final now   = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final hoursLeft = tomorrow.difference(now).inHours;

    return Scaffold(
      backgroundColor: kKidsSurface,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => KidsHomeScreen(child: child)),
                      (r) => false),
                  child: Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: kKidsSurfaceContLowest,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 8)],
                    ),
                    child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: kKidsPrimary),
                  ),
                ),
              ),
            ),
            const Spacer(),
            const Text('🌟', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            Text("Today's Quiz Done!",
                style: GoogleFonts.plusJakartaSans(
                    fontSize: 24, fontWeight: FontWeight.w900, color: kKidsPrimary)),
            const SizedBox(height: 8),
            Text('${child?['name'] ?? 'You'} already completed today\'s quiz.',
                style: GoogleFonts.plusJakartaSans(fontSize: 14, color: kKidsOnSurfaceVariant)),
            const SizedBox(height: 28),
            // Score card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
              decoration: BoxDecoration(
                color: kKidsSurfaceContLowest,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(40),
                ),
                boxShadow: [BoxShadow(color: Colors.black.withAlpha(13), blurRadius: 16, offset: const Offset(0, 6))],
              ),
              child: Column(
                children: [
                  Text(emoji, style: const TextStyle(fontSize: 48)),
                  const SizedBox(height: 8),
                  Text('$score / $total',
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 42, fontWeight: FontWeight.w900,
                          color: kKidsPrimary, letterSpacing: -1)),
                  const SizedBox(height: 4),
                  Text('$pct% · +${score * 10} pts earned',
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 13, color: kKidsTertiary, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Countdown chip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: kKidsPrimaryContainer.withAlpha(25),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: kKidsPrimaryContainer.withAlpha(80)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('⏰', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  Text('New quiz in ~$hoursLeft hour${hoursLeft == 1 ? '' : 's'}',
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 13, color: kKidsPrimary, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity, height: 56,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => KidsHomeScreen(child: child)),
                    (r) => false,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kKidsPrimary, foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                    elevation: 6, shadowColor: kKidsPrimary.withAlpha(90),
                  ),
                  child: Text('Back to Kids Home 🏠',
                      style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w800)),
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

// ── Data ──────────────────────────────────────────────────────────────────────

class _Question {
  final String question;
  final List<_Option> options;
  final int correctIndex;
  const _Question(this.question, this.options, this.correctIndex);
}

class _Option {
  final String label;
  final String emoji;
  const _Option(this.label, this.emoji);
}
