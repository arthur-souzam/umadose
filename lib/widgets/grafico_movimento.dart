import 'package:flutter/material.dart';
import '../util/cores.dart';

class GraficoMovimento extends StatelessWidget {
  final List<double> valores; 
  final int diaAtual; 

  const GraficoMovimento({
    super.key,
    required this.valores,
    required this.diaAtual,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: CustomPaint(
        size: Size.infinite,
        painter: _GraficoPainter(valores: valores, diaAtual: diaAtual),
      ),
    );
  }
}

class _GraficoPainter extends CustomPainter {
  final List<double> valores;
  final int diaAtual;
  static const _dias = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];

  _GraficoPainter({required this.valores, required this.diaAtual});

  @override
  void paint(Canvas canvas, Size size) {
    const alturaRotulo = 22.0;
    final alturaBarras = size.height - alturaRotulo;
    final n = valores.length;
    final espaco = size.width / n;
    final largura = espaco * 0.56;

    final maxVal = valores.reduce((a, b) => a > b ? a : b);

    for (int i = 0; i < n; i++) {
      final v = valores[i];
      final h = (v / (maxVal == 0 ? 1 : maxVal)) * (alturaBarras - 10);
      final x = espaco * i + (espaco - largura) / 2;
      final y = alturaBarras - h;

      final cheio = v >= 0.65;
      final ehHoje = i == diaAtual;
      final cor = (cheio || ehHoje)
          ? Cores.tomate
          : Cores.tomate.withValues(alpha: 0.28);

      final rrect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, largura, h),
        const Radius.circular(7),
      );
      canvas.drawRRect(rrect, Paint()..color = cor);

      final tp = TextPainter(
        text: TextSpan(
          text: _dias[i],
          style: TextStyle(
            color: ehHoje ? Cores.tomate : Cores.cinza,
            fontSize: 12,
            fontWeight: ehHoje ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(
        canvas,
        Offset(espaco * i + (espaco - tp.width) / 2, size.height - 16),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _GraficoPainter old) =>
      old.valores != valores || old.diaAtual != diaAtual;
}
