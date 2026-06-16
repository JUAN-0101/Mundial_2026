import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/form_resultado_model.dart';
import '../providers/resultados_provider.dart';

class RegistrarResultado extends ConsumerStatefulWidget {
  final int? idResultado;
  final int partidoId;
  final String equipoLocal;
  final String equipoVisitante;
  final int marcadorActual1;
  final int marcadorActual2;

  const RegistrarResultado({
    super.key,
    this.idResultado,
    required this.partidoId,
    required this.equipoLocal,
    required this.equipoVisitante,
    required this.marcadorActual1,
    required this.marcadorActual2,
  });

  @override
  ConsumerState<RegistrarResultado> createState() => _RegistrarResultadoState();
}

class _RegistrarResultadoState extends ConsumerState<RegistrarResultado> {
  final TextEditingController _goles1Controller = TextEditingController();
  final TextEditingController _goles2Controller = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _goles1Controller.text = widget.marcadorActual1.toString();
    _goles2Controller.text = widget.marcadorActual2.toString();
  }

  @override
  void dispose() {
    _goles1Controller.dispose();
    _goles2Controller.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    final goles1 = int.tryParse(_goles1Controller.text) ?? 0;
    final goles2 = int.tryParse(_goles2Controller.text) ?? 0;

    if (goles1 < 0 || goles2 < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Los goles no pueden ser negativos')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final form = FormResultadoModel(
      partidoId: widget.partidoId,
      marcadorEquipo1: goles1,
      marcadorEquipo2: goles2,
    );

    bool success;
    if (widget.idResultado != null) {
      success = await ref.read(resultadosProvider.notifier).actualizarResultado(
            widget.idResultado!,
            form,
          );
    } else {
      success =
          await ref.read(resultadosProvider.notifier).registrarResultado(form);
    }

    setState(() => _isLoading = false);

    if (success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Resultado guardado')),
        );
        Navigator.pop(context, true);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ Error al guardar')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('⚽ Registrar Resultado'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      '${widget.equipoLocal} vs ${widget.equipoVisitante}',
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Icon(Icons.sports_soccer,
                        size: 48, color: Colors.green),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _goles1Controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: '⚽ Goles ${widget.equipoLocal}',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.flag),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _goles2Controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: '⚽ Goles ${widget.equipoVisitante}',
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.flag),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _guardar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Guardar Resultado',
                        style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
