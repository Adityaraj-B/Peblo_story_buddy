import 'package:flutter/material.dart';

class PebloBackdrop extends StatelessWidget {
  const PebloBackdrop({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomPaint(
      painter: _PebloBackdropPainter(),
      child: SizedBox.expand(),
    );
  }
}

class _PebloBackdropPainter extends CustomPainter {
  const _PebloBackdropPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final skyPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFDBF7FF), Color(0xFFFFF6DE), Color(0xFFFFE4B7)],
      ).createShader(Offset.zero & size);

    canvas.drawRect(Offset.zero & size, skyPaint);

    final topWave = Path()
      ..moveTo(0, size.height * 0.18)
      ..quadraticBezierTo(
        size.width * 0.28,
        size.height * 0.10,
        size.width * 0.55,
        size.height * 0.16,
      )
      ..quadraticBezierTo(
        size.width * 0.82,
        size.height * 0.22,
        size.width,
        size.height * 0.12,
      )
      ..lineTo(size.width, 0)
      ..lineTo(0, 0)
      ..close();
    canvas.drawPath(topWave, Paint()..color = const Color(0xFF7ED6E5));

    final hillBack = Path()
      ..moveTo(0, size.height * 0.78)
      ..quadraticBezierTo(
        size.width * 0.24,
        size.height * 0.70,
        size.width * 0.52,
        size.height * 0.79,
      )
      ..quadraticBezierTo(
        size.width * 0.78,
        size.height * 0.88,
        size.width,
        size.height * 0.76,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(hillBack, Paint()..color = const Color(0xFFFFD166));

    final hillFront = Path()
      ..moveTo(0, size.height * 0.88)
      ..quadraticBezierTo(
        size.width * 0.30,
        size.height * 0.80,
        size.width * 0.62,
        size.height * 0.90,
      )
      ..quadraticBezierTo(
        size.width * 0.82,
        size.height * 0.96,
        size.width,
        size.height * 0.86,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(hillFront, Paint()..color = const Color(0xFF56C596));

    final sparklePaint = Paint()
      ..color = const Color(0xFFFF6F61).withValues(alpha: 0.38)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    for (final point in <Offset>[
      Offset(size.width * 0.10, size.height * 0.28),
      Offset(size.width * 0.88, size.height * 0.28),
      Offset(size.width * 0.78, size.height * 0.49),
      Offset(size.width * 0.18, size.height * 0.56),
    ]) {
      canvas.drawLine(
        point.translate(-7, 0),
        point.translate(7, 0),
        sparklePaint,
      );
      canvas.drawLine(
        point.translate(0, -7),
        point.translate(0, 7),
        sparklePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
