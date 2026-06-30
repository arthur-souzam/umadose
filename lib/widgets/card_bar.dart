import 'package:flutter/material.dart';
import '../models/bar.dart';
import '../util/cores.dart';
import '../util/localizacao_service.dart';
import 'chip_filtro.dart';

class CardBar extends StatelessWidget {
  final Bar bar;
  final VoidCallback onTap;

  const CardBar({super.key, required this.bar, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bombando = bar.estaBombando;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Cores.superficie,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Cores.borda),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Cores.tomate.withValues(alpha: 0.4),
                    Cores.ambar.withValues(alpha: 0.25),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.local_bar, color: Cores.creme),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          bar.nome,
                          style: const TextStyle(
                            color: Cores.creme,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Selo(
                        texto: bar.statusMovimento,
                        cor: bombando ? Cores.bombando : Cores.tranquilo,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    bar.distanciaMetros == null
                        ? "—"
                        : LocalizacaoService.formatar(bar.distanciaMetros!),
                    style: const TextStyle(color: Cores.cinza, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      if (bar.temBebida) _mini(Icons.sports_bar, "bebida"),
                      if (bar.temComida) _mini(Icons.restaurant, "comida"),
                      if (bar.temSemAlcool) _mini(Icons.local_drink, "sem álcool"),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _mini(IconData icone, String texto) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: Cores.superficie2,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icone, size: 13, color: Cores.ambar),
          const SizedBox(width: 5),
          Text(texto,
              style: const TextStyle(color: Cores.cinza, fontSize: 11.5)),
        ],
      ),
    );
  }
}
