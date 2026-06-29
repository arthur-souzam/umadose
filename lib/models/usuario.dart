import 'model.dart';

class Usuario implements Model {
  int? _id;
  final String nome;
  final String email;
  final String senha;
  final String faculdade;

  Usuario({
    int? id,
    required this.nome,
    required this.email,
    required this.senha,
    this.faculdade = '',
  }) {
    _id = id;
  }

  @override
  int? get id => _id;

  @override
  set id(int id) => _id = id;

  String get iniciais {
    final partes = nome.trim().split(RegExp(r'\s+'));
    if (partes.isEmpty || partes.first.isEmpty) return '?';
    if (partes.length == 1) return partes.first[0].toUpperCase();
    return (partes.first[0] + partes.last[0]).toUpperCase();
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'nome': nome,
      'email': email,
      'senha': senha,
      'faculdade': faculdade,
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'] as int?,
      nome: map['nome'] as String,
      email: map['email'] as String,
      senha: map['senha'] as String,
      faculdade: (map['faculdade'] ?? '') as String,
    );
  }
}
