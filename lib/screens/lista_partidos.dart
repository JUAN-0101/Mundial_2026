import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/resultados_provider.dart';
import '../providers/resultados_notifier.dart';
import 'registrar_resultado.dart';

class ListaPartidos extends ConsumerStatefulWidget {
  const ListaPartidos({super.key});

  @override
  ConsumerState<ListaPartidos> createState() => _ListaPartidosState();
}

class _ListaPartidosState extends ConsumerState<ListaPartidos> {
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
        title: const Text('📋 Lista de Partidos'),
        backgroundColor: Colors.blue.shade700,
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
              Icon(Icons.sports_soccer, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text('No hay resultados registrados'),
              Text('Aún no hay partidos con marcador'),
            ],
          ),
        );
      }

      return ListView.builder(
        itemCount: resultados.length,
        itemBuilder: (context, index) {
          final resultado = resultados[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            elevation: 3,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.green.shade100,
                child: const Icon(Icons.sports_soccer,
                    size: 24, color: Colors.green),
              ),
              title: Text(
                resultado.titulo,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(resultado.infoAdicional),
              trailing: ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RegistrarResultado(
                        idResultado: resultado.idResultado,
                        partidoId: resultado.partidoId,
                        equipoLocal: resultado.equipoLocal ?? 'Local',
                        equipoVisitante:
                            resultado.equipoVisitante ?? 'Visitante',
                        marcadorActual1: resultado.marcadorEquipo1,
                        marcadorActual2: resultado.marcadorEquipo2,
                      ),
                    ),
                  );
                  if (result == true) {
                    ref.read(resultadosProvider.notifier).getResultados();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Editar'),
              ),
            ),
          );
        },
      );
    }

    return const SizedBox.shrink();
  }
}
