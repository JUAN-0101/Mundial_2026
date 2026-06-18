import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/resultados_provider.dart';
import '../providers/resultados_notifier.dart';

class VerResultados extends ConsumerStatefulWidget {
  const VerResultados({super.key});

  @override
  ConsumerState<VerResultados> createState() => _VerResultadosState();
}

class _VerResultadosState extends ConsumerState<VerResultados> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(resultadosProvider.notifier).getResultados());
  }

  Future<void> _onRefresh() async {
    await ref.read(resultadosProvider.notifier).getResultados();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(resultadosProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Marcadores Finales')),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: const Color(0xFF1B5E20),
        child: _buildBody(state),
      ),
    );
  }

  Widget _buildBody(ResultadosState state) {
    if (state is ResultadosLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is ResultadosError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off_rounded, size: 80, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text('Ocurrió un error', style: Theme.of(context).textTheme.titleLarge),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(state.message, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
            ),
            ElevatedButton.icon(
              onPressed: _onRefresh,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (state is ResultadosData) {
      final resultados = state.resultados;

      if (resultados.isEmpty) {
        return ListView( // Usamos ListView para que el RefreshIndicator funcione incluso vacío
          children: const [
            SizedBox(height: 200),
            Center(
              child: Column(
                children: [
                  Icon(Icons.sports_score, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Aún no hay resultados', style: TextStyle(fontSize: 18, color: Colors.grey)),
                ],
              ),
            ),
          ],
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: resultados.length,
        itemBuilder: (context, index) {
          final r = resultados[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(r.titulo, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(r.infoAdicional, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1B5E20),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      r.resultado,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 2),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
    return const SizedBox.shrink();
  }
}