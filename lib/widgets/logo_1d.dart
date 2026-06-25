import 'package:flutter/material.dart';
import '../util/cores.dart';

class Logo1D extends StatelessWidget {
  final double tamanho;
  final bool comFaisca;

  const Logo1D({super.key, this.tamanho = 120, this.comFaisca = true});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: tamanho,
      height: tamanho * (200 / 220),
      child: CustomPaint(
        painter: _Logo1DPainter(comFaisca: comFaisca),
      ),
    );
  }
}

class _Logo1DPainter extends CustomPainter {
  final bool comFaisca;
  _Logo1DPainter({required this.comFaisca});

  @override
  void paint(Canvas canvas, Size size) {

    final sx = size.width / 220;
    final sy = size.height / 200;
    canvas.scale(sx, sy);

    final tomate = Paint()..color = Cores.tomate..isAntiAlias = true;
    final ambar = Paint()..color = Cores.ambar..isAntiAlias = true;
    final fundo = Paint()..color = Cores.noite..isAntiAlias = true;

  
    if (comFaisca) {
      final faisca = Paint()
        ..color = Cores.creme
        ..strokeWidth = 7
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
      canvas.drawLine(const Offset(110, 36), const Offset(110, 21), faisca);
      canvas.drawLine(const Offset(95, 40), const Offset(84, 29), faisca);
      canvas.drawLine(const Offset(125, 40), const Offset(136, 29), faisca);
    }

   
    canvas.save();
    canvas.translate(54, 170);
    canvas.rotate(6.5 * 3.1415926 / 180);
    final um = Path()
      ..moveTo(-14, -116)
      ..lineTo(14, -116)
      ..lineTo(14, 0)
      ..lineTo(-14, 0)
      ..close();
    
    final bandeira = Path()
      ..moveTo(-14, -116)
      ..lineTo(-42, -97)
      ..lineTo(-42, -71)
      ..lineTo(-14, -89)
      ..close();
    canvas.drawPath(um, tomate);
    canvas.drawPath(bandeira, tomate);

    final onda = Path()
      ..moveTo(-20, -66)
      ..cubicTo(-4, -66, 0, -71, 7, -71)
      ..cubicTo(13, -71, 12, -61, 18, -61)
      ..cubicTo(24, -61, 26, -65, 34, -65)
      ..lineTo(34, -53)
      ..cubicTo(26, -53, 24, -49, 18, -49)
      ..cubicTo(12, -49, 13, -59, 7, -59)
      ..cubicTo(0, -59, -4, -54, -20, -54)
      ..close();
    canvas.drawPath(onda, fundo);
    // respingos
    canvas.drawCircle(const Offset(19, -82), 3.4, fundo);
    canvas.drawCircle(const Offset(25, -89), 2.3, fundo);
    canvas.restore();

    // ---- "D" (âmbar), inclinado -6.5° sobre a base (162,170) ----
    canvas.save();
    canvas.translate(162, 170);
    canvas.rotate(-6.5 * 3.1415926 / 180);
    final d = Path()
      ..moveTo(-42, -116)
      ..lineTo(6, -116)
      ..arcToPoint(const Offset(42, -80), radius: const Radius.circular(36))
      ..lineTo(42, -36)
      ..arcToPoint(const Offset(6, 0), radius: const Radius.circular(36))
      ..lineTo(-42, 0)
      ..close();
    canvas.drawPath(d, ambar);

  
    final pin = Path()
      ..moveTo(-8.5, -48.6)
      ..arcToPoint(const Offset(12.5, -48.6),
          radius: const Radius.circular(17), largeArc: true)
      ..quadraticBezierTo(8, -40, 2, -28)
      ..quadraticBezierTo(-4, -40, -8.5, -48.6)
      ..close();
    canvas.drawPath(pin, fundo);
    canvas.drawCircle(const Offset(2, -64), 7.5, ambar);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _Logo1DPainter old) =>
      old.comFaisca != comFaisca;
}
