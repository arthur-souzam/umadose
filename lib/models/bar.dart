import 'model.dart';

class Bar implements Model {
  int? _id;
  final String nome;
  final String descricao;
  final double lat;
  final double lng;
  final String preco;
  final bool temComida;
  final bool temBebida;
  final bool temSemAlcool;
  final bool musicaAoVivo;
  final String fechaHora;
  final List<String> tags;

  final List<double> movimento;

  double? distanciaMetros;

  Bar({
    int? id,
    required this.nome,
    required this.descricao,
    required this.lat,
    required this.lng,
    required this.preco,
    required this.temComida,
    required this.temBebida,
    required this.temSemAlcool,
    required this.musicaAoVivo,
    required this.fechaHora,
    required this.tags,
    required this.movimento,
  }) {
    _id = id;
  }

  @override
  int? get id => _id;

  @override
  set id(int id) => _id = id;

  static int hojeIndice() {
    return DateTime.now().weekday - 1;
  }

  double get movimentoHoje => movimento[hojeIndice()];

  bool get estaBombando => movimentoHoje >= 0.65;

  String get statusMovimento => estaBombando ? "Bombando" : "Tranquilo";

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'nome': nome,
      'descricao': descricao,
      'lat': lat,
      'lng': lng,
      'preco': preco,
      'temComida': temComida ? 1 : 0,
      'temBebida': temBebida ? 1 : 0,
      'temSemAlcool': temSemAlcool ? 1 : 0,
      'musicaAoVivo': musicaAoVivo ? 1 : 0,
      'fechaHora': fechaHora,
      'tags': tags.join(','),
      'movimento': movimento.map((e) => e.toStringAsFixed(2)).join(','),
    };
  }

  factory Bar.fromMap(Map<String, dynamic> map) {
    final bar = Bar(
      id: map['id'] as int?,
      nome: map['nome'] as String,
      descricao: (map['descricao'] ?? '') as String,
      lat: (map['lat'] as num).toDouble(),
      lng: (map['lng'] as num).toDouble(),
      preco: (map['preco'] ?? '\$\$') as String,
      temComida: (map['temComida'] as int) == 1,
      temBebida: (map['temBebida'] as int) == 1,
      temSemAlcool: (map['temSemAlcool'] as int) == 1,
      musicaAoVivo: (map['musicaAoVivo'] as int) == 1,
      fechaHora: (map['fechaHora'] ?? '') as String,
      tags: (map['tags'] as String).isEmpty
          ? <String>[]
          : (map['tags'] as String).split(','),
      movimento: (map['movimento'] as String)
          .split(',')
          .map((e) => double.tryParse(e) ?? 0.0)
          .toList(),
    );
    return bar;
  }
}
