import 'package:flutter/material.dart';

import '../models/evento.dart';
import '../util/db.dart';
import '../util/localizacao_service.dart';

class EventosProvider extends ChangeNotifier {
  List<Evento> _eventos = [];
  String _filtroDia = 'Hoje';
  bool _carregando = false;

  List<Evento> get todos => _eventos;
  String get filtroDia => _filtroDia;
  bool get carregando => _carregando;

  Evento? get destaque {
    for (final e in _eventos) {
      if (e.destaque) return e;
    }
    return _eventos.isNotEmpty ? _eventos.first : null;
  }

  List<Evento> get semDestaque =>
      _eventos.where((e) => e != destaque).toList();

  Future<void> carregar(Posicao? posicao) async {
    _carregando = true;
    notifyListeners();

    final dados = await DBUtil.list('eventos');
    _eventos = dados.map((m) => Evento.fromMap(m)).toList();

    if (posicao != null) {
      for (final ev in _eventos) {
        ev.distanciaMetros = LocalizacaoService.distanciaMetros(
          posicao.lat,
          posicao.lng,
          ev.lat,
          ev.lng,
        );
      }
      _eventos.sort((a, b) =>
          (a.distanciaMetros ?? 1e9).compareTo(b.distanciaMetros ?? 1e9));
    }

    _carregando = false;
    notifyListeners();
  }

  void selecionarDia(String dia) {
    _filtroDia = dia;
    notifyListeners();
  }
}
