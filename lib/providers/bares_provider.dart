import 'package:flutter/material.dart';

import '../models/bar.dart';
import '../util/db.dart';
import '../util/localizacao_service.dart';

enum Filtro { abertoAgora, temComida, semAlcool, eventoHoje }

class BaresProvider extends ChangeNotifier {
  List<Bar> _bares = [];
  final Set<Filtro> _filtros = {};
  final Set<int> _salvos = {};
  Posicao? _posicao;
  bool _carregando = false;

  List<Bar> get todos => _bares;
  Set<Filtro> get filtros => _filtros;
  bool get carregando => _carregando;
  Posicao? get posicao => _posicao;
  int get totalSalvos => _salvos.length;

  List<Bar> get baresFiltrados {
    var lista = _bares.where((bar) {
      if (_filtros.contains(Filtro.temComida) && !bar.temComida) return false;
      if (_filtros.contains(Filtro.semAlcool) && !bar.temSemAlcool) return false;
      return true;
    }).toList();
    lista.sort((a, b) =>
        (a.distanciaMetros ?? 1e9).compareTo(b.distanciaMetros ?? 1e9));
    return lista;
  }

  int get quantidadeAbertos => _bares.length;

  bool estaSalvo(int barId) => _salvos.contains(barId);

  Future<void> carregar(int? usuarioId) async {
    _carregando = true;
    notifyListeners();

    final dados = await DBUtil.list('bares');
    _bares = dados.map((m) => Bar.fromMap(m)).toList();

    _posicao = await LocalizacaoService.posicaoAtual();
    for (final bar in _bares) {
      bar.distanciaMetros = LocalizacaoService.distanciaMetros(
        _posicao!.lat,
        _posicao!.lng,
        bar.lat,
        bar.lng,
      );
    }

    if (usuarioId != null) {
      final salvos = await DBUtil.where('salvos', 'usuarioId = ?', [usuarioId]);
      _salvos
        ..clear()
        ..addAll(salvos.map((m) => m['barId'] as int));
    }

    _carregando = false;
    notifyListeners();
  }

  void alternarFiltro(Filtro filtro) {
    if (_filtros.contains(filtro)) {
      _filtros.remove(filtro);
    } else {
      _filtros.add(filtro);
    }
    notifyListeners();
  }

  Bar? porId(int id) {
    for (final b in _bares) {
      if (b.id == id) return b;
    }
    return null;
  }

  Future<void> alternarSalvo(int usuarioId, int barId) async {
    if (_salvos.contains(barId)) {
      _salvos.remove(barId);
      await DBUtil.delete(
          'salvos', 'usuarioId = ? AND barId = ?', [usuarioId, barId]);
    } else {
      _salvos.add(barId);
      await DBUtil.insert('salvos', {'usuarioId': usuarioId, 'barId': barId});
    }
    notifyListeners();
  }

  List<Bar> baresSalvos() =>
      _bares.where((b) => _salvos.contains(b.id)).toList();

  Future<void> fazerCheckin(int usuarioId, int barId) async {
    await DBUtil.insert('checkins', {
      'usuarioId': usuarioId,
      'barId': barId,
      'quando': DateTime.now().toIso8601String(),
    });
    notifyListeners();
  }

  Future<int> totalCheckins(int usuarioId) async {
    final res = await DBUtil.where('checkins', 'usuarioId = ?', [usuarioId]);
    return res.length;
  }
}
