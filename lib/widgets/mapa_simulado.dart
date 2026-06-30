import 'package:flutter/material.dart';
import '../models/bar.dart';
import '../util/cores.dart';
import '../util/localizacao_service.dart';

class MapaSimulado extends StatelessWidget {
  final List<Bar> bares;
  final Posicao? usuario;
  final void Function(Bar)? aoTocarBar;

  const MapaSimulado({
    super.key,
    required this.bares,
    this.usuario,
    this.aoTocarBar,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;
        final lats = [
          if (usuario != null) usuario!.lat,
          ...bares.map((b) => b.lat),
        ];
        final lngs = [
          if (usuario != null) usuario!.lng,
          ...bares.map((b) => b.lng),
        ];
        if (lats.isEmpty) return const SizedBox();
        final minLat = lats.reduce((a, b) => a < b ? a : b);
        final maxLat = lats.reduce((a, b) => a > b ? a : b);
        final minLng = lngs.reduce((a, b) => a < b ? a : b);
        final maxLng = lngs.reduce((a, b) => a > b ? a : b);

        Offset projetar(double lat, double lng) {
          const margem = 0.18;
          double nx = (lng - minLng) / ((maxLng - minLng) == 0 ? 1 : (maxLng - minLng));
          double ny = (lat - minLat) / ((maxLat - minLat) == 0 ? 1 : (maxLat - minLat));
          final x = (margem + nx * (1 - 2 * margem)) * w;
          final y = (1 - (margem + ny * (1 - 2 * margem))) * h; 
          return Offset(x, y);
        }

        Bar? maisProximo;
        for (final b in bares) {
          if (maisProximo == null ||
              (b.distanciaMetros ?? 1e9) < (maisProximo.distanciaMetros ?? 1e9)) {
            maisProximo = b;
          }
        }

        return ClipRRect(
          borderRadius: BorderRadius.circular(0),
          child: Stack(
            children: [
              // ruas
              Positioned.fill(
                child: CustomPaint(painter: _RuasPainter()),
              ),
              if (usuario != null)
                _ponto(
                  projetar(usuario!.lat, usuario!.lng),
                  child: _PontoUsuario(),
                ),
              ...bares.map((bar) {
                final p = projetar(bar.lat, bar.lng);
                final destaque = bar == maisProximo;
                return _ponto(
                  p,
                  alturaPin: 54,
                  child: GestureDetector(
                    onTap: () => aoTocarBar?.call(bar),
                    child: _PinBar(bar: bar, destaque: destaque),
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _ponto(Offset p, {required Widget child, double alturaPin = 18}) {
    return Positioned(
      left: p.dx - 22,
      top: p.dy - alturaPin,
      child: SizedBox(width: 44, child: child),
    );
  }
}

class _RuasPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
        Offset.zero & size, Paint()..color = const Color(0xFF15151C));
    final rua = Paint()
      ..color = const Color(0xFF24242E)
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round;
    for (double y = size.height * 0.2; y < size.height; y += size.height * 0.3) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y - 18), rua);
    }
    for (double x = size.width * 0.22; x < size.width; x += size.width * 0.3) {
      canvas.drawLine(Offset(x, 0), Offset(x + 18, size.height), rua);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PontoUsuario extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: Cores.lima,
            shape: BoxShape.circle,
            border: Border.all(color: Cores.noite, width: 3),
          ),
        ),
      ],
    );
  }
}

class _PinBar extends StatelessWidget {
  final Bar bar;
  final bool destaque;
  const _PinBar({required this.bar, required this.destaque});

  @override
  Widget build(BuildContext context) {
    final cor = destaque ? Cores.ambar : Cores.tomate;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (destaque)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            margin: const EdgeInsets.only(bottom: 2),
            decoration: BoxDecoration(
              color: Cores.creme,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              bar.nome,
              style: const TextStyle(
                  color: Cores.noite, fontSize: 10, fontWeight: FontWeight.w700),
            ),
          ),
        Icon(Icons.location_on, color: cor, size: destaque ? 38 : 30),
      ],
    );
  }
}
