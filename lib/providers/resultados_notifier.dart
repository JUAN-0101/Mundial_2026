import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/resultado_model.dart';
import '../models/form_resultado_model.dart';

// Estados posibles
abstract class ResultadosState {}

class ResultadosLoading extends ResultadosState {}

class ResultadosData extends ResultadosState {
  final List<ResultadoModel> resultados;
  ResultadosData(this.resultados);
}

class ResultadosError extends ResultadosState {
  final String message;
  ResultadosError(this.message);
}

class ResultadosNotifier extends StateNotifier<ResultadosState> {
  final Dio dio;

  ResultadosNotifier(this.dio) : super(ResultadosLoading());

  // GET /api/resultados
  Future<void> getResultados() async {
    try {
      state = ResultadosLoading();

      final response = await dio.get('/resultados');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final resultados =
            data.map((json) => ResultadoModel.fromJson(json)).toList();
        state = ResultadosData(resultados);
      } else {
        state = ResultadosError('Error al cargar resultados');
      }
    } catch (e) {
      state = ResultadosError('Error de conexión: ${e.toString()}');
    }
  }

  // POST /api/resultados
  Future<bool> registrarResultado(FormResultadoModel form) async {
    try {
      final response = await dio.post(
        '/resultados',
        data: form.toJson(),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        await getResultados();
        return true;
      }
      return false;
    } catch (e) {
      print('Error POST: $e');
      return false;
    }
  }

  // PUT /api/resultados/:id
  Future<bool> actualizarResultado(
      int idResultado, FormResultadoModel form) async {
    try {
      final response = await dio.put(
        '/resultados/$idResultado',
        data: form.toJson(),
      );

      if (response.statusCode == 200) {
        await getResultados();
        return true;
      }
      return false;
    } catch (e) {
      print('Error PUT: $e');
      return false;
    }
  }
}
