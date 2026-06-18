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
  late int _golesLocal;
  late int _golesVisitante;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _golesLocal = widget.marcadorActual1;
    _golesVisitante = widget.marcadorActual2;
  }

  Future<void> _guardar() async {
    setState(() => _isLoading = true);

    final form = FormResultadoModel(
      partidoId: widget.partidoId,
      marcadorEquipo1: _golesLocal,
      marcadorEquipo2: _golesVisitante,
    );

    bool success;
    if (widget.idResultado != null) {
      success = await ref.read(resultadosProvider.notifier).actualizarResultado(widget.idResultado!, form);
    } else {
      success = await ref.read(resultadosProvider.notifier).registrarResultado(form);
    }

    setState(() => _isLoading = false);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Resultado guardado con éxito'), backgroundColor: Colors.green),
      );
      Navigator.pop(context, true);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Error al guardar el resultado'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('⚽ Registrar Marcador')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 15, offset: Offset(0, 5))],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildMarcadorControl(widget.equipoLocal, _golesLocal, (val) => setState(() => _golesLocal = val)),
                      const Text('VS', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.grey)),
                      _buildMarcadorControl(widget.equipoVisitante, _golesVisitante, (val) => setState(() => _golesVisitante = val)),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: FilledButton(
                onPressed: _isLoading ? null : _guardar,
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: _isLoading
                    ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                    : const Text('Guardar Resultado', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMarcadorControl(String equipo, int goles, Function(int) onChanged) {
    return Column(
      children: [
        Text(equipo, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              IconButton(
                icon: const Icon(Icons.add, color: Colors.green),
                onPressed: () => onChanged(goles + 1),
              ),
              Text('$goles', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
              IconButton(
                icon: const Icon(Icons.remove, color: Colors.red),
                onPressed: () => onChanged(goles > 0 ? goles - 1 : 0),
              ),
            ],
          ),
        )
      ],
    );
  }
}