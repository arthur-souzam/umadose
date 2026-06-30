import 'package:flutter/material.dart';
import '../util/cores.dart';

class ChipFiltro extends StatelessWidget {
  final String texto;
  final bool ativo;
  final VoidCallback onTap;
  final Color corAtivo;

  const ChipFiltro({
    super.key,
    required this.texto,
    required this.ativo,
    required this.onTap,
    this.corAtivo = Cores.lima,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: ativo ? corAtivo : Cores.superficie,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: ativo ? corAtivo : Cores.borda,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (ativo)
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                      color: Cores.noite, shape: BoxShape.circle),
                ),
              ),
            Text(
              texto,
              style: TextStyle(
                color: ativo ? Cores.noite : Cores.creme,
                fontWeight: ativo ? FontWeight.w700 : FontWeight.w500,
                fontSize: 13.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Selo extends StatelessWidget {
  final String texto;
  final Color cor;
  final bool preenchido;
  const Selo({
    super.key,
    required this.texto,
    required this.cor,
    this.preenchido = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: preenchido ? cor : Colors.transparent,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: cor),
      ),
      child: Text(
        texto,
        style: TextStyle(
          color: preenchido ? Cores.noite : cor,
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class Tag extends StatelessWidget {
  final String texto;
  final bool destaque;
  const Tag({super.key, required this.texto, this.destaque = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: Cores.superficie,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: destaque ? Cores.lima : Cores.borda),
      ),
      child: Text(
        texto,
        style: TextStyle(
          color: destaque ? Cores.lima : Cores.creme,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    );
  }
}
