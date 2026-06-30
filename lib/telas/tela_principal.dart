import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../providers/bares_provider.dart';
import '../providers/eventos_provider.dart';
import '../util/cores.dart';
import 'tela_eventos.dart';
import 'tela_home.dart';
import 'tela_perfil.dart';
import 'tela_salvos.dart';


class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  int _indice = 0;

  final _telas = const [
    TelaHome(),
    TelaEventos(),
    TelaSalvos(),
    TelaPerfil(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _carregarDados());
  }

  Future<void> _carregarDados() async {
    final auth = context.read<AuthProvider>();
    final baresProv = context.read<BaresProvider>();
    final eventosProv = context.read<EventosProvider>();

    await baresProv.carregar(auth.usuario?.id);
    await eventosProv.carregar(baresProv.posicao);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Cores.noite,
      body: IndexedStack(index: _indice, children: _telas),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Cores.borda)),
        ),
        child: BottomNavigationBar(
          currentIndex: _indice,
          onTap: (i) => setState(() => _indice = i),
          backgroundColor: Cores.noite,
          selectedItemColor: Cores.tomate,
          unselectedItemColor: Cores.cinza,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.location_on_outlined),
                activeIcon: Icon(Icons.location_on),
                label: "Mapa"),
            BottomNavigationBarItem(
                icon: Icon(Icons.event_outlined),
                activeIcon: Icon(Icons.event),
                label: "Eventos"),
            BottomNavigationBarItem(
                icon: Icon(Icons.bookmark_border),
                activeIcon: Icon(Icons.bookmark),
                label: "Salvos"),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: "Perfil"),
          ],
        ),
      ),
    );
  }
}
