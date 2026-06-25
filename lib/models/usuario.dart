import 'package:firebase_auth/firebase_auth.dart' as fb;

class Usuario {
  final String uid;
  final String nome;
  final String email;
  final String faculdade;

  Usuario({
    required this.uid,
    required this.nome,
    required this.email,
    this.faculdade = '',
  });

  factory Usuario.fromFirebase(fb.User u) {
    return Usuario(
      uid: u.uid,
      nome: u.displayName ?? (u.email?.split('@').first ?? 'Usuário'),
      email: u.email ?? '',
    );
  }

  String get iniciais {
    final partes = nome.trim().split(RegExp(r'\s+'));
    if (partes.isEmpty || partes.first.isEmpty) return '?';
    if (partes.length == 1) return partes.first[0].toUpperCase();
    return (partes.first[0] + partes.last[0]).toUpperCase();
  }
}
