import 'package:geolocator/geolocator.dart';

class LocalizacaoService {
  static const double campusLat = -28.4713;
  static const double campusLng = -49.0137;

  static Future<Posicao> posicaoAtual() async {
    try {
      bool servicoAtivo = await Geolocator.isLocationServiceEnabled();
      if (!servicoAtivo) {
        return const Posicao(campusLat, campusLng, real: false);
      }

      LocationPermission permissao = await Geolocator.checkPermission();
      if (permissao == LocationPermission.denied) {
        permissao = await Geolocator.requestPermission();
      }
      if (permissao == LocationPermission.denied ||
          permissao == LocationPermission.deniedForever) {
        return const Posicao(campusLat, campusLng, real: false);
      }

      final ultima = await Geolocator.getLastKnownPosition();
      if (ultima != null) {
        return Posicao(ultima.latitude, ultima.longitude, real: true);
      }

      final p = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
        ),
      ).timeout(const Duration(seconds: 6));
      return Posicao(p.latitude, p.longitude, real: true);
    } catch (_) {
      return const Posicao(campusLat, campusLng, real: false);
    }
  }

  static double distanciaMetros(
      double lat1, double lng1, double lat2, double lng2) {
    return Geolocator.distanceBetween(lat1, lng1, lat2, lng2);
  }

  static String formatar(double metros) {
    final minutos = (metros / 80).ceil();
    if (metros < 1000) {
      return "${metros.round()} m · $minutos min a pé";
    }
    final km = (metros / 1000).toStringAsFixed(1);
    return "$km km · $minutos min a pé";
  }
}

class Posicao {
  final double lat;
  final double lng;
  final bool real;
  const Posicao(this.lat, this.lng, {required this.real});
}
