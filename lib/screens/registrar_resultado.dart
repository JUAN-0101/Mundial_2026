import 'package:flutter/material.dart';

class RegistrarResultado extends StatefulWidget {
  final String partido;

  const RegistrarResultado({super.key, required this.partido});

  @override
  State<RegistrarResultado> createState() => _RegistrarResultadoState();
}

class _RegistrarResultadoState extends State<RegistrarResultado> {
  final goles1Controller = TextEditingController();
  final goles2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final equipos = widget.partido.split(' vs ');

    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Resultado')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              widget.partido,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),

            TextField(
              controller: goles1Controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Goles ${equipos[0]}',
                border: const OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: goles2Controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Goles ${equipos[1]}',
                border: const OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Resultado guardado')),
                  );
                },
                child: const Text('Guardar Resultado'),
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancelar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
