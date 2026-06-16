import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/providers/dio_provider.dart';
import 'resultados_notifier.dart';

final resultadosProvider =
    StateNotifierProvider<ResultadosNotifier, ResultadosState>((ref) {
  final dio = ref.watch(dioProvider);
  return ResultadosNotifier(dio);
});
