import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../util/cores.dart';
import '../util/rotas.dart';
import '../widgets/logo_1d.dart';

class TelaHome extends StatelessWidget {
  const TelaHome({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final usuario = auth.usuario;

    return Scaffold(
      backgroundColor: Cores.noite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  tooltip: 'Sair',
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
              const Spacer(),
              const Logo1D(tamanho: 120),
              const SizedBox(height: 28),
              // avatar com iniciais
              Container(
                width: 88,
                height: 88,
                decoration: const BoxDecoration(
                  gradient: Cores.gradBrinde,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  usuario?.iniciais ?? "?",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Bora, ${usuario?.nome ?? 'visitante'}!",
                style: const TextStyle(
                  color: Cores.creme,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                usuario?.email ?? '',
                style: const TextStyle(color: Cores.cinza, fontSize: 14),
              ),
              const SizedBox(height: 18),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Cores.lima.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: Cores.lima),
                ),
                child: const Text(
                  "✓ Autenticado com Firebase",
                  style: TextStyle(
                    color: Cores.lima,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
              const Spacer(),
              const Text(
                "Em breve: mapa de bares, movimento por dia e eventos.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Cores.cinza, fontSize: 13),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
