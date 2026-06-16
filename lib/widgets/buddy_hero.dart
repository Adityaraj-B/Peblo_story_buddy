import 'package:flutter/material.dart';

enum BuddyMood { ready, reading, happy, worried }

class BuddyHero extends StatelessWidget {
  const BuddyHero({required this.mood, super.key});

  final BuddyMood mood;

  @override
  Widget build(BuildContext context) {
    final isHappy = mood == BuddyMood.happy;
    final isReading = mood == BuddyMood.reading;
    final isWorried = mood == BuddyMood.worried;

    return SizedBox(
      height: 212,
      child: Center(
        child: AnimatedScale(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutBack,
          scale: isHappy ? 1.04 : 1,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Positioned(
                bottom: 0,
                child: Container(
                  width: 132,
                  height: 86,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1AA6B7),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: const Color(0xFF17324D),
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF17324D).withValues(alpha: 0.16),
                        blurRadius: 18,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      isHappy
                          ? Icons.celebration_rounded
                          : Icons.settings_suggest_rounded,
                      color: const Color(0xFFFFD166),
                      size: 38,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 68,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 240),
                  width: 164,
                  height: 124,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isWorried
                          ? const [Color(0xFFFFF0B8), Color(0xFFFFB58C)]
                          : const [Color(0xFFFFFFFF), Color(0xFFDFF9FF)],
                    ),
                    borderRadius: BorderRadius.circular(34),
                    border: Border.all(
                      color: const Color(0xFF17324D),
                      width: 3,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _Eye(isHappy: isHappy, isWorried: isWorried),
                          const SizedBox(width: 28),
                          _Eye(isHappy: isHappy, isWorried: isWorried),
                        ],
                      ),
                      const SizedBox(height: 16),
                      CustomPaint(
                        size: const Size(58, 22),
                        painter: _MouthPainter(
                          happy: isHappy,
                          worried: isWorried,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 0,
                child: Column(
                  children: [
                    Container(
                      width: 5,
                      height: 28,
                      decoration: BoxDecoration(
                        color: const Color(0xFF17324D),
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                    Container(
                      width: 28,
                      height: 18,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6F61),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: const Color(0xFF17324D),
                          width: 3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (isReading)
                const Positioned(right: -34, top: 62, child: _ReadingBadge()),
            ],
          ),
        ),
      ),
    );
  }
}

class _Eye extends StatelessWidget {
  const _Eye({required this.isHappy, required this.isWorried});

  final bool isHappy;
  final bool isWorried;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 26,
      height: isHappy ? 9 : 26,
      decoration: BoxDecoration(
        color: const Color(0xFF17324D),
        borderRadius: BorderRadius.circular(99),
      ),
      child: isWorried
          ? Center(
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  shape: BoxShape.circle,
                ),
              ),
            )
          : null,
    );
  }
}

class _ReadingBadge extends StatelessWidget {
  const _ReadingBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: const Color(0xFFFFD166),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFF17324D), width: 3),
      ),
      child: const Icon(
        Icons.graphic_eq_rounded,
        color: Color(0xFF17324D),
        size: 34,
      ),
    );
  }
}

class _MouthPainter extends CustomPainter {
  const _MouthPainter({required this.happy, required this.worried});

  final bool happy;
  final bool worried;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF17324D)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final path = Path();
    if (worried) {
      path
        ..moveTo(size.width * 0.18, size.height * 0.72)
        ..quadraticBezierTo(
          size.width * 0.50,
          size.height * 0.12,
          size.width * 0.82,
          size.height * 0.72,
        );
    } else {
      path
        ..moveTo(
          size.width * 0.14,
          happy ? size.height * 0.18 : size.height * 0.34,
        )
        ..quadraticBezierTo(
          size.width * 0.50,
          happy ? size.height * 0.96 : size.height * 0.64,
          size.width * 0.86,
          happy ? size.height * 0.18 : size.height * 0.34,
        );
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _MouthPainter oldDelegate) {
    return oldDelegate.happy != happy || oldDelegate.worried != worried;
  }
}
