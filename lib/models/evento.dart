import 'model.dart';

class Evento implements Model {
  int? _id;
  final String nome;
  final String local;
  final double lat;
  final double lng;
  final String categoria;
  final String dia;
  final String hora;
  final String entrada;
  final bool destaque;

  double? distanciaMetros;

  Evento({
    int? id,
    required this.nome,
    required this.local,
    required this.lat,
    required this.lng,
    required this.categoria,
    required this.dia,
    required this.hora,
    required this.entrada,
    required this.destaque,
  }) {
    _id = id;
  }

  @override
  int? get id => _id;

  @override
  set id(int id) => _id = id;

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'nome': nome,
      'local': local,
      'lat': lat,
      'lng': lng,
      'categoria': categoria,
      'dia': dia,
      'hora': hora,
      'entrada': entrada,
      'destaque': destaque ? 1 : 0,
    };
  }

  factory Evento.fromMap(Map<String, dynamic> map) {
    return Evento(
      id: map['id'] as int?,
      nome: map['nome'] as String,
      local: map['local'] as String,
      lat: (map['lat'] as num).toDouble(),
      lng: (map['lng'] as num).toDouble(),
      categoria: (map['categoria'] ?? '') as String,
      dia: (map['dia'] ?? '') as String,
      hora: (map['hora'] ?? '') as String,
      entrada: (map['entrada'] ?? '') as String,
      destaque: (map['destaque'] as int) == 1,
    );
  }
}
