import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import 'sermon_notes_screen.dart';

class SermonPlayerScreen extends StatefulWidget {
  final String title;
  final String pastor;
  final String date;
  final String series;

  const SermonPlayerScreen({
    super.key,
    this.title = 'The Power of Grace',
    this.pastor = 'Pastor Sarah Miller',
    this.date = 'Sunday, Oct 22, 2023',
    this.series = 'The Kingdom Within',
  });

  @override
  State<SermonPlayerScreen> createState() => _SermonPlayerScreenState();
}

class _SermonPlayerScreenState extends State<SermonPlayerScreen> {
  bool _isPlaying = false;
  bool _amened = false;
  bool _saved = false;
  double _progress = 0.31; // 12:45 of 42:10

  static const _gradients = [
    [Color(0xFF4A6741), Color(0xFF8BA888)],
    [Color(0xFF3D5A4E), Color(0xFFB8C4B5)],
    [Color(0xFF6B4E3D), Color(0xFFD7A49A)],
  ];

  static const _related = [
    ('Finding Peace', 'Pastor David Chen'),
    ('Walking in Faith', 'Min. Jessica Roe'),
    ('New Beginnings', 'Pastor Sarah Miller'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.backgroundDark : AppColors.backgroundLight;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
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
                color: bg,
                border: Border(
                  bottom: BorderSide(
                      color: AppColors.primary.withOpacity(0.1)),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back,
                        color: AppColors.primary),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  Expanded(
                    child: Text(
                      'Now Playing',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.3,
                        color: textColor,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert,
                        color: AppColors.primary),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Scrollable
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom + 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Video player
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              // Background gradient
                              Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFF4A3728),
                                      Color(0xFF8B6654),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.6),
                                    ],
                                    stops: const [0.3, 1.0],
                                  ),
                                ),
                              ),
                              // Play/Pause button
                              GestureDetector(
                                onTap: () =>
                                    setState(() => _isPlaying = !_isPlaying),
                                child: Center(
                                  child: Container(
                                    width: 64,
                                    height: 64,
                                    decoration: BoxDecoration(
                                      color:
                                          AppColors.primary.withOpacity(0.9),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.primary
                                              .withOpacity(0.4),
                                          blurRadius: 20,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      _isPlaying
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                      color: Colors.white,
                                      size: 36,
                                    ),
                                  ),
                                ),
                              ),
                              // Progress bar + timestamps
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    children: [
                                      SliderTheme(
                                        data: SliderThemeData(
                                          thumbShape:
                                              const RoundSliderThumbShape(
                                                  enabledThumbRadius: 7),
                                          trackHeight: 3,
                                          activeTrackColor:
                                              AppColors.primary,
                                          inactiveTrackColor:
                                              Colors.white.withOpacity(0.3),
                                          thumbColor: AppColors.primary,
                                          overlayColor: AppColors.primary
                                              .withOpacity(0.2),
                                        ),
                                        child: Slider(
                                          value: _progress,
                                          onChanged: (v) =>
                                              setState(() => _progress = v),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            _formatTime(
                                                (_progress * 2530).toInt()),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const Text(
                                            '42:10',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
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

                    // Sermon info
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.3,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                widget.pastor,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                              Text(
                                '  •  ',
                                style: TextStyle(
                                    color: subColor, fontSize: 14),
                              ),
                              Text(
                                widget.date,
                                style: TextStyle(
                                    fontSize: 14, color: subColor),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Playback controls
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.replay_5,
                                size: 32, color: subColor),
                            onPressed: () => setState(() {
                              _progress =
                                  (_progress - 5 / 2530).clamp(0.0, 1.0);
                            }),
                          ),
                          const SizedBox(width: 24),
                          GestureDetector(
                            onTap: () =>
                                setState(() => _isPlaying = !_isPlaying),
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _isPlaying ? Icons.pause : Icons.play_arrow,
                                size: 36,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 24),
                          IconButton(
                            icon: Icon(Icons.forward_5,
                                size: 32, color: subColor),
                            onPressed: () => setState(() {
                              _progress =
                                  (_progress + 5 / 2530).clamp(0.0, 1.0);
                            }),
                          ),
                        ],
                      ),
                    ),

                    // Divider
                    Divider(
                        color: AppColors.primary.withOpacity(0.05),
                        height: 1),
                    const SizedBox(height: 8),

                    // Quick actions
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _QuickAction(
                            icon: _amened
                                ? Icons.favorite
                                : Icons.favorite_outline,
                            label: 'Amen',
                            active: _amened,
                            onTap: () =>
                                setState(() => _amened = !_amened),
                          ),
                          _QuickAction(
                            icon: Icons.share_outlined,
                            label: 'Share',
                            onTap: () {},
                          ),
                          _QuickAction(
                            icon: _saved
                                ? Icons.download_done
                                : Icons.download_outlined,
                            label: 'Save',
                            active: _saved,
                            onTap: () =>
                                setState(() => _saved = !_saved),
                          ),
                          _QuickAction(
                            icon: Icons.edit_note,
                            label: 'Notes',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SermonNotesScreen(
                                  sermonTitle: widget.title,
                                  sermonInfo:
                                      '${widget.date} • ${widget.pastor}',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Divider(
                        color: AppColors.primary.withOpacity(0.05),
                        height: 1),

                    // Sermon description
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sermon Description',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'In this powerful session, ${widget.pastor} explores the transformative nature of grace in our daily lives. Learn how letting go of perfection can lead to a more fulfilling spiritual journey and deeper connection with your community.',
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.7,
                              color: subColor,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Related sermons
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Related Sermons',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: const Text(
                              'View All',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 168,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        separatorBuilder: (_, __) =>
                            const SizedBox(width: 14),
                        itemCount: _related.length,
                        itemBuilder: (ctx, i) {
                          return GestureDetector(
                            onTap: () => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SermonPlayerScreen(
                                  title: _related[i].$1,
                                  pastor: _related[i].$2,
                                ),
                              ),
                            ),
                            child: SizedBox(
                              width: 180,
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(12),
                                    child: Container(
                                      height: 100,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: _gradients[i]
                                              .map((c) => c as Color)
                                              .toList(),
                                        ),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.play_circle_outline,
                                          color:
                                              Colors.white.withOpacity(0.4),
                                          size: 36,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    _related[i].$1,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    _related[i].$2,
                                    style: TextStyle(
                                        fontSize: 11, color: subColor),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
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

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: active
                  ? AppColors.primary.withOpacity(0.15)
                  : AppColors.primary.withOpacity(0.06),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
              color: Color(0xFF94A3B8),
            ),
          ),
        ],
      ),
    );
  }
}
