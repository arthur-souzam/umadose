import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsProvider extends ChangeNotifier {
  bool _mostrarSemAlcool = true;
  bool _notificarBombando = true;

  bool get mostrarSemAlcool => _mostrarSemAlcool;
  bool get notificarBombando => _notificarBombando;

  static const _kSemAlcool = 'pref_sem_alcool';
  static const _kNotificar = 'pref_notificar';

  Future<void> carregar() async {
    final prefs = await SharedPreferences.getInstance();
    _mostrarSemAlcool = prefs.getBool(_kSemAlcool) ?? true;
    _notificarBombando = prefs.getBool(_kNotificar) ?? true;
    notifyListeners();
  }

  Future<void> setSemAlcool(bool v) async {
    _mostrarSemAlcool = v;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kSemAlcool, v);
  }

  Future<void> setNotificar(bool v) async {
    _notificarBombando = v;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kNotificar, v);
  }
}
