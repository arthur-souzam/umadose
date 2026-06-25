import 'package:flutter/material.dart';
import '../util/cores.dart';

class CampoTexto extends StatelessWidget {
  final String rotulo;
  final IconData? icone;
  final bool senha;
  final TextInputType tipo;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final TextEditingController? controller;

  const CampoTexto({
    super.key,
    required this.rotulo,
    this.icone,
    this.senha = false,
    this.tipo = TextInputType.text,
    this.validator,
    this.onSaved,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: senha,
      keyboardType: tipo,
      style: const TextStyle(color: Cores.creme),
      cursorColor: Cores.tomate,
      validator: validator,
      onSaved: onSaved,
      decoration: InputDecoration(
        labelText: rotulo,
        labelStyle: const TextStyle(color: Cores.cinza),
        prefixIcon: icone != null ? Icon(icone, color: Cores.cinza) : null,
        filled: true,
        fillColor: Cores.superficie,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Cores.borda),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Cores.tomate, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Cores.tomate),
        ),
      ),
    );
  }
}
