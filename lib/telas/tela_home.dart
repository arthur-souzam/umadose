import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/bar.dart';
import '../providers/bares_provider.dart';
import '../util/cores.dart';
import '../util/rotas.dart';
import '../widgets/card_bar.dart';
import '../widgets/chip_filtro.dart';
import '../widgets/mapa_simulado.dart';

class TelaHome extends StatelessWidget {
  const TelaHome({super.key});

  void _abrirDetalhe(BuildContext context, Bar bar) {
    Navigator.of(context).pushNamed(Rotas.detalheBar, arguments: bar.id);
  }

  @override
  Widget build(BuildContext context) {
    final baresProv = context.watch<BaresProvider>();

    if (baresProv.carregando && baresProv.todos.isEmpty) {
      return const Center(child: CircularProgressIndicator(color: Cores.tomate));
    }

    final bares = baresProv.baresFiltrados;

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Oi 👋 o que tá rolando perto da facul?",
                  style: TextStyle(
                    color: Cores.creme,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: Cores.creme,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.search, color: Cores.noite),
                      hintText: "Buscar bar, rua ou rolê...",
                      hintStyle: TextStyle(color: Color(0xFF6B6757)),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(color: Cores.noite),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),

          // Chips de filtro
          SizedBox(
            height: 42,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                ChipFiltro(
                  texto: "Aberto agora",
                  ativo: baresProv.filtros.contains(Filtro.abertoAgora),
                  onTap: () => baresProv.alternarFiltro(Filtro.abertoAgora),
                ),
                const SizedBox(width: 8),
                ChipFiltro(
                  texto: "Tem comida",
                  ativo: baresProv.filtros.contains(Filtro.temComida),
                  onTap: () => baresProv.alternarFiltro(Filtro.temComida),
                ),
                const SizedBox(width: 8),
                ChipFiltro(
                  texto: "Sem álcool",
                  ativo: baresProv.filtros.contains(Filtro.semAlcool),
                  onTap: () => baresProv.alternarFiltro(Filtro.semAlcool),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Mapa
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: SizedBox(
                height: 220,
                child: MapaSimulado(
                  bares: bares,
                  usuario: baresProv.posicao,
                  aoTocarBar: (bar) => _abrirDetalhe(context, bar),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Lista "Perto de você"
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Perto de você",
                  style: TextStyle(
                    color: Cores.creme,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  "${baresProv.quantidadeAbertos} bares abertos",
                  style: const TextStyle(color: Cores.cinza, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: bares.length,
              itemBuilder: (context, i) => CardBar(
                bar: bares[i],
                onTap: () => _abrirDetalhe(context, bares[i]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
