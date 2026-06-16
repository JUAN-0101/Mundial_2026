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
    Future.microtask(() {
      ref.read(resultadosProvider.notifier).getResultados();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(resultadosProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('🏆 Resultados'),
        backgroundColor: Colors.orange.shade700,
        foregroundColor: Colors.white,
      ),
      body: _buildBody(state),
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
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error: ${state.message}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref.read(resultadosProvider.notifier).getResultados();
              },
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (state is ResultadosData) {
      final resultados = state.resultados;

      if (resultados.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.emoji_events, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text('No hay resultados registrados'),
            ],
          ),
        );
      }

      return ListView.builder(
        itemCount: resultados.length,
        itemBuilder: (context, index) {
          final r = resultados[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            elevation: 3,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green.shade50, Colors.white],
                  begin: Alignment.topLeft,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.green.shade100,
                  child: const Icon(Icons.emoji_events,
                      size: 24, color: Colors.green),
                ),
                title: Text(
                  r.titulo,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(r.infoAdicional),
                trailing: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.green.shade700,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    r.resultado,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    }

    return const SizedBox.shrink();
  }
}
