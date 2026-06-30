import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/eventos_provider.dart';
import '../util/cores.dart';
import '../widgets/card_evento.dart';
import '../widgets/chip_filtro.dart';

class TelaEventos extends StatelessWidget {
  const TelaEventos({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<EventosProvider>();

    if (prov.carregando && prov.todos.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: Cores.tomate));
    }

    final destaque = prov.destaque;
    final lista = prov.semDestaque;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        children: [
          const Text(
            "Rolês por perto",
            style: TextStyle(
              color: Cores.creme,
              fontSize: 28,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: ['Hoje', 'Amanhã', 'Fim de semana'].map((dia) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChipFiltro(
                  texto: dia,
                  ativo: prov.filtroDia == dia,
                  corAtivo: Cores.tomate,
                  onTap: () => prov.selecionarDia(dia),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          if (destaque != null) CardEventoDestaque(evento: destaque),
          ...lista.map((e) => CardEvento(evento: e)),
        ],
      ),
    );
  }
}
