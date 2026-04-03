import 'package:flutter/material.dart';
import 'kids_home_screen.dart';
import 'know_jesus_screen.dart';
import 'watch_stories_screen.dart';

class QuizTimeScreen extends StatefulWidget {
  const QuizTimeScreen({super.key});

  @override
  State<QuizTimeScreen> createState() => _QuizTimeScreenState();
}

class _QuizTimeScreenState extends State<QuizTimeScreen> {
  static const kPrimary = Color(0xFFA53500);
  static const kPrimaryContainer = Color(0xFFFF7947);
  static const kSecondary = Color(0xFF006289);
  static const kSurface = Color(0xFFF5F6F7);
  static const kSurfaceContainerLowest = Color(0xFFFFFFFF);
  static const kOnSurface = Color(0xFF2C2F30);
  static const kOnSurfaceVariant = Color(0xFF595C5D);

  static const _questions = [
    _Question(
      question: 'What was the first thing God created?',
      options: [
        _Option('Light', Icons.light_mode_rounded, '💡'),
        _Option('Water', Icons.water_drop_rounded, '💧'),
        _Option('Trees', Icons.park_rounded, '🌲'),
        _Option('Animals', Icons.pets_rounded, '🐾'),
      ],
      correctIndex: 0,
    ),
    _Question(
      question: 'How many loaves of bread did Jesus use to feed 5,000 people?',
      options: [
        _Option('5 Loaves', Icons.bakery_dining_rounded, '🍞'),
        _Option('10 Loaves', Icons.numbers_rounded, '🔢'),
        _Option('2 Loaves', Icons.numbers_rounded, '2️⃣'),
        _Option('7 Loaves', Icons.numbers_rounded, '7️⃣'),
      ],
      correctIndex: 0,
    ),
    _Question(
      question: 'Who built a big ark to save the animals from the flood?',
      options: [
        _Option('Moses', Icons.person_rounded, '🧔'),
        _Option('Noah', Icons.sailing_rounded, '⛵'),
        _Option('David', Icons.star_rounded, '⭐'),
        _Option('Abraham', Icons.account_circle_rounded, '👴'),
      ],
      correctIndex: 1,
    ),
    _Question(
      question: 'How many days did Jesus rise after he was crucified?',
      options: [
        _Option('1 Day', Icons.looks_one_rounded, '1️⃣'),
        _Option('2 Days', Icons.looks_two_rounded, '2️⃣'),
        _Option('3 Days', Icons.looks_3_rounded, '3️⃣'),
        _Option('7 Days', Icons.looks_rounded, '7️⃣'),
      ],
      correctIndex: 2,
    ),
    _Question(
      question: 'Who was swallowed by a giant fish?',
      options: [
        _Option('Elijah', Icons.fire_truck_rounded, '🔥'),
        _Option('Jonah', Icons.set_meal_rounded, '🐳'),
        _Option('Paul', Icons.anchor_rounded, '⚓'),
        _Option('Peter', Icons.waves_rounded, '🌊'),
      ],
      correctIndex: 1,
    ),
  ];

  int _currentQuestion = 0;
  int? _selectedOption;
  bool _answered = false;
  int _score = 0;
  bool _quizComplete = false;

  void _selectOption(int index) {
    if (_answered) return;
    setState(() {
      _selectedOption = index;
      _answered = true;
      if (index == _questions[_currentQuestion].correctIndex) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestion < _questions.length - 1) {
      setState(() {
        _currentQuestion++;
        _selectedOption = null;
        _answered = false;
      });
    } else {
      setState(() => _quizComplete = true);
    }
  }

  void _restartQuiz() {
    setState(() {
      _currentQuestion = 0;
      _selectedOption = null;
      _answered = false;
      _score = 0;
      _quizComplete = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_quizComplete) return _buildResults(context);

    final q = _questions[_currentQuestion];
    final progress = (_currentQuestion + 1) / _questions.length;

    return Scaffold(
      backgroundColor: kSurface,
      bottomNavigationBar: _KidsBottomNav(activeIndex: kKidsTabQuiz),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            // Progress bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Question ${_currentQuestion + 1} of ${_questions.length}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.0,
                          color: kOnSurfaceVariant,
                        ),
                      ),
                      Text(
                        '${(progress * 100).round()}% Complete',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.0,
                          color: kPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRounded(
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 12,
                      backgroundColor: const Color(0xFFE0E3E4),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          kPrimaryContainer),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: Column(
                  children: [
                    _buildQuestionCard(q),
                    const SizedBox(height: 24),
                    _buildOptionsGrid(q),
                    const SizedBox(height: 24),
                    if (_answered) _buildCheckAnswerButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 10, 16, 16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded,
                color: kOnSurface, size: 20),
            onPressed: () => Navigator.maybePop(context),
          ),
          const Expanded(
            child: Text(
              'Quiz Time 🎯',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: kPrimary,
                letterSpacing: -0.3,
              ),
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF9EEC69).withOpacity(0.35),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.stars_rounded,
                    color: Color(0xFF306800), size: 16),
                const SizedBox(width: 4),
                Text(
                  '$_score pts',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    color: Color(0xFF306800),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(_Question q) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Decorative element
        Positioned(
          top: -10,
          right: -10,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF9FD9FF).withOpacity(0.25),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: kSurfaceContainerLowest,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(12),
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(32),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 24,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFfb5151).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'QUIZ TIME',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF9f0519),
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                q.question,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: kOnSurface,
                  height: 1.3,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOptionsGrid(_Question q) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemCount: q.options.length,
      itemBuilder: (ctx, i) {
        final opt = q.options[i];
        final isSelected = _selectedOption == i;
        final isCorrect = _answered && i == q.correctIndex;
        final isWrong = _answered && isSelected && i != q.correctIndex;

        Color borderColor = Colors.transparent;
        Color bgColor = kSurfaceContainerLowest;

        if (isCorrect) {
          borderColor = const Color(0xFF306800);
          bgColor = const Color(0xFF9EEC69).withOpacity(0.2);
        } else if (isWrong) {
          borderColor = const Color(0xFFb31b25);
          bgColor = const Color(0xFFfb5151).withOpacity(0.12);
        } else if (isSelected) {
          borderColor = kPrimary;
          bgColor = kPrimaryContainer.withOpacity(0.1);
        }

        return GestureDetector(
          onTap: () => _selectOption(i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: borderColor, width: 2.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(opt.emoji,
                    style: const TextStyle(fontSize: 32)),
                const SizedBox(height: 10),
                Text(
                  opt.label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: isCorrect
                        ? const Color(0xFF306800)
                        : isWrong
                            ? const Color(0xFFb31b25)
                            : kOnSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCheckAnswerButton() {
    final isCorrect = _selectedOption == _questions[_currentQuestion].correctIndex;
    final isLast = _currentQuestion == _questions.length - 1;

    return Column(
      children: [
        if (_answered)
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isCorrect
                  ? const Color(0xFF9EEC69).withOpacity(0.25)
                  : const Color(0xFFfb5151).withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Text(
                  isCorrect ? '🎉' : '😅',
                  style: const TextStyle(fontSize: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isCorrect ? 'Correct! Great job!' : 'Not quite right',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: isCorrect
                              ? const Color(0xFF265600)
                              : const Color(0xFF570008),
                        ),
                      ),
                      if (!isCorrect)
                        Text(
                          'The answer is: ${_questions[_currentQuestion].options[_questions[_currentQuestion].correctIndex].label}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF570008),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _nextQuestion,
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              elevation: 6,
              shadowColor: kPrimary.withOpacity(0.35),
            ),
            child: Text(
              isLast ? 'See Results 🏆' : 'Next Question →',
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w800),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResults(BuildContext context) {
    final total = _questions.length;
    final pct = (_score / total * 100).round();
    final emoji = pct >= 80
        ? '🏆'
        : pct >= 60
            ? '⭐'
            : '💪';
    final message = pct >= 80
        ? 'Amazing! You\'re a Bible champion!'
        : pct >= 60
            ? 'Great job! Keep learning!'
            : 'Good try! Practice makes perfect!';

    return Scaffold(
      backgroundColor: kSurface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 80)),
              const SizedBox(height: 20),
              Text(
                '$_score / $total',
                style: const TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.w900,
                  color: kPrimary,
                  letterSpacing: -2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: kOnSurface,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'You scored $pct%',
                style: const TextStyle(
                  fontSize: 14,
                  color: kOnSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _restartQuiz,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 6,
                    shadowColor: kPrimary.withOpacity(0.35),
                  ),
                  child: const Text(
                    'Try Again 🔄',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              TextButton(
                onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const KidsHomeScreen()),
                  (r) => false,
                ),
                child: const Text(
                  'Back to Kids Home',
                  style: TextStyle(
                    color: kOnSurfaceVariant,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ClipRounded helper for progress bar
class ClipRounded extends StatelessWidget {
  final Widget child;
  const ClipRounded({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(99),
      child: child,
    );
  }
}

class _Question {
  final String question;
  final List<_Option> options;
  final int correctIndex;
  const _Question(
      {required this.question,
      required this.options,
      required this.correctIndex});
}

class _Option {
  final String label;
  final IconData icon;
  final String emoji;
  const _Option(this.label, this.icon, this.emoji);
}

// ── Shared Kids Bottom Nav ─────────────────────────────────────────────────────

class _KidsBottomNav extends StatelessWidget {
  final int activeIndex;
  const _KidsBottomNav({required this.activeIndex});

  void _onTap(BuildContext context, int index) {
    if (index == activeIndex) return;
    Widget dest;
    switch (index) {
      case kKidsTabHome:
        dest = const KidsHomeScreen();
        break;
      case kKidsTabWatch:
        dest = const WatchStoriesScreen();
        break;
      case kKidsTabKnowJesus:
        dest = const KnowJesusScreen();
        break;
      case kKidsTabQuiz:
        dest = const QuizTimeScreen();
        break;
      default:
        return;
    }
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => dest),
      (r) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      _KidsTab(Icons.home_rounded, 'Home'),
      _KidsTab(Icons.play_circle_rounded, 'Watch'),
      _KidsTab(Icons.auto_awesome_rounded, 'Know Jesus'),
      _KidsTab(Icons.extension_rounded, 'Quiz'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 24,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(tabs.length, (i) {
              final isActive = activeIndex == i;
              return GestureDetector(
                onTap: () => _onTap(context, i),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isActive
                        ? const Color(0xFFFF7947).withOpacity(0.14)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        tabs[i].icon,
                        size: 22,
                        color: isActive
                            ? const Color(0xFFA53500)
                            : const Color(0xFF9CA3AF),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        tabs[i].label,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                          color: isActive
                              ? const Color(0xFFA53500)
                              : const Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _KidsTab {
  final IconData icon;
  final String label;
  _KidsTab(this.icon, this.label);
}
