class PartidoModel {
  final int id;
  final String equipoLocal;
  final String equipoVisitante;
  final String? grupo;
  final String? fecha;
  final String? hora;
  final int? golesLocal;
  final int? golesVisitante;

  PartidoModel({
    required this.id,
    required this.equipoLocal,
    required this.equipoVisitante,
    this.grupo,
    this.fecha,
    this.hora,
    this.golesLocal,
    this.golesVisitante,
  });

  factory PartidoModel.fromJson(Map<String, dynamic> json) {
    return PartidoModel(
      id: json['id'] ?? json['id_partido'] ?? 0,
      equipoLocal: json['equipo_local'] ?? '',
      equipoVisitante: json['equipo_visitante'] ?? '',
      grupo: json['grupo'],
      fecha: json['fecha'],
      hora: json['hora'],
      golesLocal: json['goles_local'],
      golesVisitante: json['goles_visitante'],
    );
  }

  String get titulo => '$equipoLocal vs $equipoVisitante';

  String get resultado {
    if (golesLocal != null && golesVisitante != null) {
      return '$equipoLocal $golesLocal - $golesVisitante $equipoVisitante';
    }
    return 'Sin resultado';
  }

  String get infoAdicional {
    if (grupo != null && fecha != null && hora != null) {
      return '$grupo • $fecha • $hora';
    }
    return '';
  }

  bool get tieneResultado => golesLocal != null && golesVisitante != null;
}
