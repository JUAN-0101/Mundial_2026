class FormResultadoModel {
  final int partidoId;
  final int marcadorEquipo1;
  final int marcadorEquipo2;

  FormResultadoModel({
    required this.partidoId,
    required this.marcadorEquipo1,
    required this.marcadorEquipo2,
  });

  Map<String, dynamic> toJson() {
    return {
      'partido': partidoId,
      'marcador_equipo1': marcadorEquipo1,
      'marcador_equipo2': marcadorEquipo2,
    };
  }
}
