import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/bares_provider.dart';
import '../util/cores.dart';
import '../util/rotas.dart';
import '../widgets/card_bar.dart';

class TelaSalvos extends StatelessWidget {
  const TelaSalvos({super.key});

  @override
  Widget build(BuildContext context) {
    final baresProv = context.watch<BaresProvider>();
    final salvos = baresProv.baresSalvos();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Bares salvos",
              style: TextStyle(
                color: Cores.creme,
                fontSize: 28,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "${salvos.length} lugares pra não esquecer",
              style: const TextStyle(color: Cores.cinza, fontSize: 13.5),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: salvos.isEmpty
                  ? const _Vazio()
                  : ListView.builder(
                      itemCount: salvos.length,
                      itemBuilder: (context, i) => CardBar(
                        bar: salvos[i],
                        onTap: () => Navigator.of(context).pushNamed(
                          Rotas.detalheBar,
                          arguments: salvos[i].id,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Vazio extends StatelessWidget {
  const _Vazio();
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.bookmark_border, color: Cores.cinza, size: 48),
          SizedBox(height: 12),
          Text(
            "Nenhum bar salvo ainda.\nToca no marcador de um bar pra guardar.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Cores.cinza),
          ),
        ],
      ),
    );
  }
}
