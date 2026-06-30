import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/prefs_provider.dart';
import '../util/cores.dart';
import '../util/db.dart';
import '../util/rotas.dart';
import '../util/seed.dart';
import '../widgets/logo_1d.dart';

class TelaSplash extends StatefulWidget {
  const TelaSplash({super.key});

  @override
  State<TelaSplash> createState() => _TelaSplashState();
}

class _TelaSplashState extends State<TelaSplash>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _escala;
  late final Animation<double> _opacidade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _escala = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut),
    );
    _opacidade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: const Interval(0.0, 0.5)),
    );
    _ctrl.forward();
    _inicializar();
  }

  Future<void> _inicializar() async {
    await DBUtil.getDB();
    await Seed.popularSeNecessario();

    if (!mounted) return;
    final auth = context.read<AuthProvider>();
    final prefs = context.read<PrefsProvider>();
    await prefs.carregar();
    await auth.restaurarSessao();

    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;

    Navigator.of(context).pushReplacementNamed(
      auth.estaAutenticado ? Rotas.principal : Rotas.login,
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Cores.noite,
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            radius: 0.9,
            colors: [Color(0xFF241310), Cores.noite],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _opacidade,
            child: ScaleTransition(
              scale: _escala,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Logo1D(tamanho: 180),
                  SizedBox(height: 24),
                  Text(
                    "A dose certa de rolê",
                    style: TextStyle(
                      color: Cores.creme,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
