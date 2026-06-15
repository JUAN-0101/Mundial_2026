import 'package:flutter/material.dart';
import 'registrar_resultado.dart';

class ListaPartidos extends StatelessWidget {
  const ListaPartidos({super.key});

  @override
  Widget build(BuildContext context) {
    final partidos = [
      'México vs Brasil',
      'Argentina vs Japón',
      'España vs Francia',
      'Alemania vs Italia',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Partidos')),
      body: ListView.builder(
        itemCount: partidos.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(partidos[index]),
              trailing: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          RegistrarResultado(partido: partidos[index]),
                    ),
                  );
                },
                child: const Text('Capturar'),
              ),
            ),
          );
        },
      ),
    );
  }
}
