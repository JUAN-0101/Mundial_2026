import 'package:flutter/material.dart';

class VerResultados extends StatelessWidget {
  const VerResultados({super.key});

  @override
  Widget build(BuildContext context) {
    final resultados = [
      'México 2 - 1 Brasil',
      'Argentina 0 - 0 Japón',
      'España 3 - 2 Francia',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Resultados')),
      body: ListView.builder(
        itemCount: resultados.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              leading: const Icon(Icons.sports_soccer),
              title: Text(resultados[index]),
            ),
          );
        },
      ),
    );
  }
}
