import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/bar.dart';
import '../providers/auth_provider.dart';
import '../providers/bares_provider.dart';
import '../providers/eventos_provider.dart';
import '../util/cores.dart';
import '../util/localizacao_service.dart';
import '../widgets/botao_primario.dart';
import '../widgets/card_evento.dart';
import '../widgets/chip_filtro.dart';
import '../widgets/grafico_movimento.dart';


class TelaDetalheBar extends StatelessWidget {
  const TelaDetalheBar({super.key});

  @override
  Widget build(BuildContext context) {
    final barId = ModalRoute.of(context)!.settings.arguments as int;
    final baresProv = context.watch<BaresProvider>();
    final auth = context.read<AuthProvider>();
    final bar = baresProv.porId(barId);

    if (bar == null) {
      return const Scaffold(
        backgroundColor: Cores.noite,
        body: Center(
          child: Text("Bar não encontrado", style: TextStyle(color: Cores.creme)),
        ),
      );
    }

    final salvo = baresProv.estaSalvo(barId);
    final eventosProv = context.read<EventosProvider>();
    final eventosDoBar =
        eventosProv.todos.where((e) => e.local == bar.nome).toList();

    return Scaffold(
      backgroundColor: Cores.noite,
      body: CustomScrollView(
        slivers: [
          // Cabeçalho com "foto"
          SliverToBoxAdapter(
            child: Stack(
              children: [
                Container(
                  height: 240,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Cores.ambar.withValues(alpha: 0.35),
                        Cores.noite,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: const Center(
                    child: Icon(Icons.storefront, color: Cores.creme, size: 56),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _botaoCircular(
                          Icons.arrow_back_ios_new,
                          () => Navigator.of(context).pop(),
                        ),
                        _botaoCircular(
                          salvo ? Icons.bookmark : Icons.bookmark_border,
                          () {
                            if (auth.usuario != null) {
                              baresProv.alternarSalvo(auth.usuario!.id!, barId);
                            }
                          },
                          cor: salvo ? Cores.tomate : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Text(
                  bar.nome,
                  style: const TextStyle(
                    color: Cores.creme,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      bar.distanciaMetros == null
                          ? "—"
                          : LocalizacaoService.formatar(bar.distanciaMetros!),
                      style: const TextStyle(color: Cores.cinza, fontSize: 13.5),
                    ),
                    const Text("  ·  ",
                        style: TextStyle(color: Cores.cinza)),
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                          color: Cores.lima, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "Aberto até ${bar.fechaHora}",
                      style: const TextStyle(
                          color: Cores.lima,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
                const Text(
                  "Movimento por dia",
                  style: TextStyle(
                      color: Cores.creme,
                      fontSize: 18,
                      fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 4),
                Text(
                  _legendaMovimento(bar),
                  style: const TextStyle(color: Cores.cinza, fontSize: 13),
                ),
                const SizedBox(height: 12),
                GraficoMovimento(
                  valores: bar.movimento,
                  diaAtual: Bar.hojeIndice(),
                ),

                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "O que rola aqui",
                      style: TextStyle(
                          color: Cores.creme,
                          fontSize: 18,
                          fontWeight: FontWeight.w800),
                    ),
                    Text(
                      bar.preco,
                      style: const TextStyle(
                          color: Cores.ambar,
                          fontSize: 18,
                          fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: bar.tags
                      .map((t) => Tag(
                            texto: t,
                            destaque: t.toLowerCase().contains("sem álcool"),
                          ))
                      .toList(),
                ),

                if (eventosDoBar.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  const Text(
                    "Eventos por perto",
                    style: TextStyle(
                        color: Cores.creme,
                        fontSize: 18,
                        fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 12),
                  ...eventosDoBar.map((e) => CardEvento(evento: e)),
                ],

                const SizedBox(height: 8),
                BotaoSecundario(
                  texto: "Cheguei (check-in)",
                  icone: Icons.check_circle_outline,
                  onPressed: () async {
                    if (auth.usuario != null) {
                      await baresProv.fazerCheckin(auth.usuario!.id!, barId);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Check-in feito! Tim-tim 🍻"),
                            backgroundColor: Cores.tomate,
                          ),
                        );
                      }
                    }
                  },
                ),
              ]),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        color: Cores.noite,
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
        child: BotaoPrimario(
          texto: "Como chegar",
          icone: Icons.navigation,
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Abrindo rota no mapa..."),
                backgroundColor: Cores.tomate,
              ),
            );
          },
        ),
      ),
    );
  }

  String _legendaMovimento(Bar bar) {
    const dias = ['segunda', 'terça', 'quarta', 'quinta', 'sexta', 'sábado', 'domingo'];
    final indices = List.generate(7, (i) => i);
    indices.sort((a, b) => bar.movimento[b].compareTo(bar.movimento[a]));
    final d1 = dias[indices[0]];
    final d2 = dias[indices[1]];
    return "$d1 e $d2 são os dias cheios";
  }

  Widget _botaoCircular(IconData icone, VoidCallback onTap, {Color? cor}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Cores.noite.withValues(alpha: 0.6),
          shape: BoxShape.circle,
        ),
        child: Icon(icone, color: cor ?? Cores.creme, size: 20),
      ),
    );
  }
}
