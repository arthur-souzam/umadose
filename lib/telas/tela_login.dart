import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../util/cores.dart';
import '../util/rotas.dart';
import '../widgets/botao_primario.dart';
import '../widgets/campo_texto.dart';
import '../widgets/logo_1d.dart';

enum ModoLogin { login, cadastro }

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final _formKey = GlobalKey<FormState>();
  ModoLogin _modo = ModoLogin.login;

  final _dados = {'nome': '', 'email': '', 'senha': '', 'faculdade': ''};

  bool get _ehLogin => _modo == ModoLogin.login;

  Future<void> _submeter() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    _formKey.currentState?.save();
    final auth = context.read<AuthProvider>();
    try {
      if (_ehLogin) {
        await auth.login(_dados['email']!, _dados['senha']!);
      } else {
        await auth.cadastrar(_dados['nome']!, _dados['email']!,
            _dados['senha']!, _dados['faculdade']!);
      }
      if (mounted && auth.estaAutenticado) {
        Navigator.of(context).pushReplacementNamed(Rotas.principal);
      }
    } catch (e) {
      _mostrarErro(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> _google() async {
    final auth = context.read<AuthProvider>();
    await auth.entrarComGoogle();
    if (mounted && auth.estaAutenticado) {
      Navigator.of(context).pushReplacementNamed(Rotas.principal);
    }
  }

  void _mostrarErro(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Cores.tomate),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: Cores.noite,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 28),
                const Center(child: Logo1D(tamanho: 96)),
                const SizedBox(height: 36),
                Text(
                  _ehLogin ? "Bora?\nO rolê tá te esperando." : "Cria sua conta\ne bora pro rolê.",
                  style: const TextStyle(
                    color: Cores.creme,
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 28),

                if (!_ehLogin) ...[
                  CampoTexto(
                    rotulo: "Nome",
                    icone: Icons.person_outline,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? "Diz teu nome" : null,
                    onSaved: (v) => _dados['nome'] = v!.trim(),
                  ),
                  const SizedBox(height: 14),
                ],

                CampoTexto(
                  rotulo: "E-mail",
                  icone: Icons.email_outlined,
                  tipo: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return "Informe o e-mail";
                    if (!v.contains('@')) return "E-mail inválido";
                    return null;
                  },
                  onSaved: (v) => _dados['email'] = v!.trim(),
                ),
                const SizedBox(height: 14),

                CampoTexto(
                  rotulo: "Senha",
                  icone: Icons.lock_outline,
                  senha: true,
                  validator: (v) => (v == null || v.length < 6)
                      ? "Mínimo de 6 caracteres"
                      : null,
                  onSaved: (v) => _dados['senha'] = v!,
                ),

                if (!_ehLogin) ...[
                  const SizedBox(height: 14),
                  CampoTexto(
                    rotulo: "Faculdade (opcional)",
                    icone: Icons.school_outlined,
                    onSaved: (v) => _dados['faculdade'] = v?.trim() ?? '',
                  ),
                ],

                const SizedBox(height: 24),
                BotaoPrimario(
                  texto: _ehLogin ? "Entrar" : "Criar conta",
                  carregando: auth.carregando,
                  onPressed: _submeter,
                ),
                const SizedBox(height: 12),
                BotaoSecundario(
                  texto: "Continuar com Google",
                  icone: Icons.g_mobiledata,
                  onPressed: _google,
                ),
                const SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () => setState(() {
                      _modo = _ehLogin ? ModoLogin.cadastro : ModoLogin.login;
                    }),
                    child: Text(
                      _ehLogin
                          ? "Não tem conta? Cadastra-se"
                          : "Já tenho conta",
                      style: const TextStyle(color: Cores.cinza),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Center(
                  child: Text(
                    "+18 · beba com moderação",
                    style: TextStyle(color: Cores.cinza, fontSize: 12),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
