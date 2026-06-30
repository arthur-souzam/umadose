import 'package:flutter/material.dart';
import '../models/evento.dart';
import '../util/cores.dart';
import 'chip_filtro.dart';

class CardEvento extends StatelessWidget {
  final Evento evento;
  const CardEvento({super.key, required this.evento});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Cores.superficie,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Cores.borda),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Cores.superficie2,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.celebration, color: Cores.ambar),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        evento.nome,
                        style: const TextStyle(
                          color: Cores.creme,
                          fontSize: 15.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Selo(
                      texto: evento.categoria,
                      cor: evento.categoria.contains("univ")
                          ? Cores.lima
                          : Cores.tomate,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  "${evento.local}${evento.distanciaMetros != null ? ' · ${evento.distanciaMetros!.round()} m do campus' : ''}",
                  style: const TextStyle(color: Cores.cinza, fontSize: 12.5),
                ),
                const SizedBox(height: 6),
                Text(
                  "${evento.dia} · ${evento.hora} · ${evento.entrada}",
                  style: const TextStyle(
                      color: Cores.ambar,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CardEventoDestaque extends StatelessWidget {
  final Evento evento;
  const CardEventoDestaque({super.key, required this.evento});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Cores.superficie,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Cores.borda),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Cores.tomate.withValues(alpha: 0.5),
                  Cores.noite,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 12,
                  left: 12,
                  child: Selo(texto: evento.categoria, cor: Cores.ambar),
                ),
                const Positioned(
                  top: 12,
                  right: 12,
                  child: Selo(texto: "em destaque", cor: Cores.lima),
                ),
                const Center(
                  child: Icon(Icons.celebration, color: Cores.creme, size: 40),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  evento.nome,
                  style: const TextStyle(
                    color: Cores.creme,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${evento.local}${evento.distanciaMetros != null ? ' · ${evento.distanciaMetros!.round()} m do campus' : ''}",
                  style: const TextStyle(color: Cores.cinza, fontSize: 13.5),
                ),
                const SizedBox(height: 6),
                Text(
                  "${evento.dia} · ${evento.hora} · ${evento.entrada}",
                  style: const TextStyle(
                      color: Cores.ambar,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
