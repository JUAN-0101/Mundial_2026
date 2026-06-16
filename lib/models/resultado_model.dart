class ResultadoModel {
  final int idResultado;
  final int partidoId;
  final int marcadorEquipo1;
  final int marcadorEquipo2;
  final String? equipoLocal;
  final String? equipoVisitante;
  final String? fase;
  final String? fecha;

  ResultadoModel({
    required this.idResultado,
    required this.partidoId,
    required this.marcadorEquipo1,
    required this.marcadorEquipo2,
    this.equipoLocal,
    this.equipoVisitante,
    this.fase,
    this.fecha,
  });

  factory ResultadoModel.fromJson(Map<String, dynamic> json) {
    return ResultadoModel(
      idResultado: json['id_resultado'] ?? 0,
      partidoId: json['partido'] ?? 0,
      marcadorEquipo1: json['marcador_equipo1'] ?? 0,
      marcadorEquipo2: json['marcador_equipo2'] ?? 0,
      equipoLocal: json['equipo_local'],
      equipoVisitante: json['equipo_visitante'],
      fase: json['fase'],
      fecha: json['fecha'],
    );
  }

  String get titulo {
    if (equipoLocal != null && equipoVisitante != null) {
      return '$equipoLocal vs $equipoVisitante';
    }
    return 'Partido #$partidoId';
  }

  String get resultado => '$marcadorEquipo1 - $marcadorEquipo2';

  String get resultadoCompleto {
    if (equipoLocal != null && equipoVisitante != null) {
      return '$equipoLocal $marcadorEquipo1 - $marcadorEquipo2 $equipoVisitante';
    }
    return resultado;
  }

  String get infoAdicional {
    String info = '';
    if (fase != null) info += fase!;
    if (fecha != null) info += ' • $fecha';
    return info;
  }
}
