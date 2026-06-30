import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/bares_provider.dart';
import '../providers/prefs_provider.dart';
import '../util/cores.dart';
import '../util/rotas.dart';

class TelaPerfil extends StatelessWidget {
  const TelaPerfil({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final prefs = context.watch<PrefsProvider>();
    final baresProv = context.watch<BaresProvider>();
    final usuario = auth.usuario;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                onPressed: () async {
                  await auth.sair();
                  if (context.mounted) {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(Rotas.login, (r) => false);
                  }
                },
                icon: const Icon(Icons.logout, color: Cores.cinza),
              ),
            ),
            // avatar
            Container(
              width: 96,
              height: 96,
              decoration: const BoxDecoration(
                gradient: Cores.gradBrinde,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                usuario?.iniciais ?? "?",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              usuario?.nome ?? "Visitante",
              style: const TextStyle(
                color: Cores.creme,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            if ((usuario?.faculdade ?? '').isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  usuario!.faculdade,
                  style: const TextStyle(
                      color: Cores.ambar, fontWeight: FontWeight.w600),
                ),
              ),
            const SizedBox(height: 20),

            // estatísticas
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    valor: "${baresProv.totalSalvos}",
                    rotulo: "bares salvos",
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FutureBuilder<int>(
                    future: usuario == null
                        ? Future.value(0)
                        : baresProv.totalCheckins(usuario.id!),
                    builder: (context, snap) => _StatCard(
                      valor: "${snap.data ?? 0}",
                      rotulo: "check-ins",
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            _LinhaMenu(
              icone: Icons.bookmark,
              corIcone: Cores.tomate,
              titulo: "Bares salvos",
              subtitulo: "${baresProv.totalSalvos} lugares pra não esquecer",
            ),
            const SizedBox(height: 10),
            const _LinhaMenu(
              icone: Icons.check_circle,
              corIcone: Cores.ambar,
              titulo: "Meus check-ins",
              subtitulo: "rolês registrados",
            ),

            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Cores.superficie,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Cores.borda),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Preferências",
                    style: TextStyle(
                        color: Cores.creme,
                        fontSize: 16,
                        fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 6),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    activeColor: Cores.tomate,
                    title: const Text("Mostrar opções sem álcool",
                        style: TextStyle(color: Cores.creme, fontSize: 14)),
                    value: prefs.mostrarSemAlcool,
                    onChanged: prefs.setSemAlcool,
                  ),
                  const Divider(color: Cores.borda, height: 1),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    activeColor: Cores.tomate,
                    title: const Text("Notificar quando um bar perto bombar",
                        style: TextStyle(color: Cores.creme, fontSize: 14)),
                    value: prefs.notificarBombando,
                    onChanged: prefs.setNotificar,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              "beba com moderação, role com vontade",
              style: TextStyle(color: Cores.cinza, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String valor;
  final String rotulo;
  const _StatCard({required this.valor, required this.rotulo});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: Cores.superficie,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Cores.borda),
      ),
      child: Column(
        children: [
          Text(valor,
              style: const TextStyle(
                  color: Cores.creme,
                  fontSize: 22,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(rotulo,
              style: const TextStyle(color: Cores.cinza, fontSize: 12.5)),
        ],
      ),
    );
  }
}

class _LinhaMenu extends StatelessWidget {
  final IconData icone;
  final Color corIcone;
  final String titulo;
  final String subtitulo;
  const _LinhaMenu({
    required this.icone,
    required this.corIcone,
    required this.titulo,
    required this.subtitulo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Cores.superficie,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Cores.borda),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: corIcone.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icone, color: corIcone, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo,
                    style: const TextStyle(
                        color: Cores.creme,
                        fontWeight: FontWeight.w700,
                        fontSize: 14.5)),
                Text(subtitulo,
                    style: const TextStyle(color: Cores.cinza, fontSize: 12.5)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Cores.cinza),
        ],
      ),
    );
  }
}
