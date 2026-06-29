import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/usuario.dart';
import '../util/db.dart';

class AuthProvider extends ChangeNotifier {
  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Usuario? _usuario;
  bool _carregando = false;

  Usuario? get usuario => _usuario;
  bool get estaAutenticado => _usuario != null;
  bool get carregando => _carregando;

  Future<void> restaurarSessao() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _sincronizarLocal(user, null);
      }
    } catch (_) {
      // Firebase ainda não configurado: segue para o login.
    }
  }

  Future<void> cadastrar(
      String nome, String email, String senha, String faculdade) async {
    _setCarregando(true);
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: senha,
      );
      await cred.user?.updateDisplayName(nome);
      await _sincronizarLocal(cred.user!, faculdade, nomeManual: nome);
    } on fb.FirebaseAuthException catch (e) {
      throw Exception(_traduzErro(e));
    } finally {
      _setCarregando(false);
    }
  }

  Future<void> login(String email, String senha) async {
    _setCarregando(true);
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );
      await _sincronizarLocal(cred.user!, null);
    } on fb.FirebaseAuthException catch (e) {
      throw Exception(_traduzErro(e));
    } finally {
      _setCarregando(false);
    }
  }

  Future<void> entrarComGoogle() async {
    _setCarregando(true);
    try {
      final GoogleSignInAccount? gUser = await _googleSignIn.signIn();
      if (gUser == null) {
        _setCarregando(false);
        return;
      }
      final GoogleSignInAuthentication gAuth = await gUser.authentication;
      final credential = fb.GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );
      final cred = await _auth.signInWithCredential(credential);
      await _sincronizarLocal(cred.user!, null);
    } on fb.FirebaseAuthException catch (e) {
      throw Exception(_traduzErro(e));
    } finally {
      _setCarregando(false);
    }
  }

  Future<void> sair() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
    await _auth.signOut();
    _usuario = null;
    notifyListeners();
  }

  Future<void> _sincronizarLocal(fb.User user, String? faculdade,
      {String? nomeManual}) async {
    final email = user.email ?? '${user.uid}@1dose.app';
    final nome = nomeManual ?? user.displayName ?? email.split('@').first;

    final existentes = await DBUtil.where('usuarios', 'email = ?', [email]);
    if (existentes.isNotEmpty) {
      final u = Usuario.fromMap(existentes.first);
      if (faculdade != null && faculdade.isNotEmpty && faculdade != u.faculdade) {
        final atualizado = Usuario(
          id: u.id,
          nome: u.nome,
          email: email,
          senha: '',
          faculdade: faculdade,
        );
        await DBUtil.insert('usuarios', atualizado.toMap());
        _usuario = atualizado;
      } else {
        _usuario = u;
      }
    } else {
      final novo = Usuario(
        nome: nome,
        email: email,
        senha: '',
        faculdade: faculdade ?? '',
      );
      novo.id = await DBUtil.insert('usuarios', novo.toMap());
      _usuario = novo;
    }
    notifyListeners();
  }

  String _traduzErro(fb.FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Esse e-mail já tem conta. Bora entrar?';
      case 'invalid-email':
        return 'E-mail inválido.';
      case 'weak-password':
        return 'Senha muito fraca (mínimo 6 caracteres).';
      case 'user-not-found':
        return 'Não achei esse e-mail. Cria uma conta?';
      case 'wrong-password':
      case 'invalid-credential':
        return 'E-mail ou senha incorretos.';
      case 'network-request-failed':
        return 'Sem internet. Verifica a conexão.';
      default:
        return e.message ?? 'Erro de autenticação.';
    }
  }

  void _setCarregando(bool v) {
    _carregando = v;
    notifyListeners();
  }
}
