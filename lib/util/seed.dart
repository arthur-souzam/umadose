import '../models/bar.dart';
import '../models/evento.dart';
import 'db.dart';
import 'localizacao_service.dart';

class Seed {
  static const _baseLat = LocalizacaoService.campusLat;
  static const _baseLng = LocalizacaoService.campusLng;

  static Future<void> popularSeNecessario() async {
    final qtdBares = await DBUtil.count('bares');
    if (qtdBares == 0) {
      for (final bar in _bares()) {
        await DBUtil.insert('bares', bar.toMap());
      }
    }
    final qtdEventos = await DBUtil.count('eventos');
    if (qtdEventos == 0) {
      for (final ev in _eventos()) {
        await DBUtil.insert('eventos', ev.toMap());
      }
    }
  }

  static List<Bar> _bares() => [
        Bar(
          nome: "Boteco do Zé",
          descricao:
              "Boteco clássico de esquina, chopp gelado e o melhor pastel da região. Ponto de encontro da galera depois da aula.",
          lat: _baseLat + 0.0012,
          lng: _baseLng + 0.0008,
          preco: "\$\$",
          temComida: true,
          temBebida: true,
          temSemAlcool: true,
          musicaAoVivo: true,
          fechaHora: "2h",
          tags: ["Chopp", "Drinks", "Petiscos", "Sem álcool", "Música ao vivo"],
          // seg, ter, qua, qui, sex, sáb, dom
          movimento: [0.25, 0.20, 0.35, 0.85, 0.95, 0.80, 0.30],
        ),
        Bar(
          nome: "Bar do Mercado",
          descricao:
              "Cervejas artesanais e tábua de frios. Vibe tranquila pra conversar sem gritar.",
          lat: _baseLat - 0.0018,
          lng: _baseLng + 0.0021,
          preco: "\$\$",
          temComida: true,
          temBebida: true,
          temSemAlcool: false,
          musicaAoVivo: false,
          fechaHora: "0h",
          tags: ["Cerveja", "Petiscos"],
          movimento: [0.30, 0.25, 0.40, 0.55, 0.70, 0.65, 0.35],
        ),
        Bar(
          nome: "Quintal 22",
          descricao:
              "Quintal aberto com samba ao vivo nas quintas. Caipirinha e porção de mandioca campeãs.",
          lat: _baseLat + 0.0024,
          lng: _baseLng - 0.0015,
          preco: "\$\$",
          temComida: true,
          temBebida: true,
          temSemAlcool: true,
          musicaAoVivo: true,
          fechaHora: "3h",
          tags: ["Samba", "Caipirinha", "Comida", "Sem álcool"],
          movimento: [0.20, 0.30, 0.45, 0.90, 0.85, 0.95, 0.55],
        ),
        Bar(
          nome: "Subsolo Club",
          descricao:
              "Balada universitária no subsolo. Festas temáticas e open ocasional.",
          lat: _baseLat - 0.0030,
          lng: _baseLng - 0.0026,
          preco: "\$\$\$",
          temComida: false,
          temBebida: true,
          temSemAlcool: true,
          musicaAoVivo: false,
          fechaHora: "5h",
          tags: ["Festa", "Drinks", "Eletrônica"],
          movimento: [0.10, 0.15, 0.25, 0.50, 0.95, 0.98, 0.20],
        ),
        Bar(
          nome: "Empório da Esquina",
          descricao:
              "Empório com rótulos especiais e mesa na calçada. Bom pra um esquenta antes do rolê.",
          lat: _baseLat + 0.0006,
          lng: _baseLng - 0.0009,
          preco: "\$",
          temComida: true,
          temBebida: true,
          temSemAlcool: true,
          musicaAoVivo: false,
          fechaHora: "23h",
          tags: ["Cerveja", "Vinho", "Tábua", "Sem álcool"],
          movimento: [0.35, 0.40, 0.45, 0.60, 0.75, 0.55, 0.40],
        ),
      ];

  static List<Evento> _eventos() => [
        Evento(
          nome: "Samba no Quintal",
          local: "Quintal 22",
          lat: _baseLat + 0.0024,
          lng: _baseLng - 0.0015,
          categoria: "Samba",
          dia: "Quinta",
          hora: "20h",
          entrada: "entrada free",
          destaque: true,
        ),
        Evento(
          nome: "Esquenta Sertanejo",
          local: "Bar do Mercado",
          lat: _baseLat - 0.0018,
          lng: _baseLng + 0.0021,
          categoria: "Sertanejo",
          dia: "Sexta",
          hora: "22h",
          entrada: "couvert R\$ 10",
          destaque: false,
        ),
        Evento(
          nome: "Festa da Calourada",
          local: "Subsolo Club",
          lat: _baseLat - 0.0030,
          lng: _baseLng - 0.0026,
          categoria: "Festa univ.",
          dia: "Sexta",
          hora: "23h",
          entrada: "lista amiga",
          destaque: false,
        ),
        Evento(
          nome: "Open Bar do Zé",
          local: "Boteco do Zé",
          lat: _baseLat + 0.0012,
          lng: _baseLng + 0.0008,
          categoria: "Open",
          dia: "Sábado",
          hora: "21h",
          entrada: "open",
          destaque: false,
        ),
      ];
}
