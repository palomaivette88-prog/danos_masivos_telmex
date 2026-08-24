import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class EditarDanoPage extends StatefulWidget {
  final String documentoId;
  final Map<String, dynamic> datos;

  const EditarDanoPage({
    super.key,
    required this.documentoId,
    required this.datos,
  });

  @override
  State<EditarDanoPage> createState() => _EditarDanoPageState();
}

class _EditarDanoPageState extends State<EditarDanoPage> {
  late String tipoDano;
  late String estado;

  late TextEditingController centralController;
  late TextEditingController folioController;
  late TextEditingController copeController;
  late TextEditingController observacionesController;

  bool guardando = false;

  @override
  void initState() {
    super.initState();

    tipoDano =
        widget.datos['tipoDano']?.toString() ?? 'Daño en cobre (CU)';

    estado = widget.datos['estado']?.toString() ?? 'Reportado';

    centralController = TextEditingController(
      text: widget.datos['central']?.toString() ?? '',
    );

    folioController = TextEditingController(
      text: widget.datos['folio']?.toString() ?? '',
    );

    copeController = TextEditingController(
      text: widget.datos['cope']?.toString() ?? '',
    );

    observacionesController = TextEditingController(
      text: widget.datos['observaciones']?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    centralController.dispose();
    folioController.dispose();
    copeController.dispose();
    observacionesController.dispose();
    super.dispose();
  }

  Future<void> actualizarDano() async {
    if (centralController.text.trim().isEmpty ||
        folioController.text.trim().isEmpty ||
        copeController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Completa los campos obligatorios.',
          ),
        ),
      );
      return;
    }

    setState(() {
      guardando = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('danos')
          .doc(widget.documentoId)
          .update({
        'tipoDano': tipoDano,
        'central': centralController.text.trim(),
        'folio': folioController.text.trim(),
        'cope': copeController.text.trim(),
        'estado': estado,
        'observaciones': observacionesController.text.trim(),
        'fechaActualizacion': Timestamp.now(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Daño actualizado correctamente en Firebase.',
          ),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error al actualizar el daño: $e',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          guardando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Editar daño',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Actualizar información',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Modifica los datos del incidente seleccionado.',
              style: TextStyle(
                color: Colors.grey.shade700,
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              'Tipo de daño',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              initialValue: tipoDano,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(
                  Icons.warning_amber_rounded,
                ),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Daño en cobre (CU)',
                  child: Text('Daño en cobre (CU)'),
                ),
                DropdownMenuItem(
                  value: 'Daño en fibra óptica (FO)',
                  child: Text('Daño en fibra óptica (FO)'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    tipoDano = value;
                  });
                }
              },
            ),

            const SizedBox(height: 20),

            const Text(
              'Central afectada *',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: centralController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(
                  Icons.account_balance,
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Número de folio *',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: folioController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(
                  Icons.receipt_long,
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'COPE responsable *',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: copeController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(
                  Icons.engineering,
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Estado del daño',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              initialValue: estado,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(
                  Icons.sync,
                ),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Reportado',
                  child: Text('Reportado'),
                ),
                DropdownMenuItem(
                  value: 'En atención',
                  child: Text('En atención'),
                ),
                DropdownMenuItem(
                  value: 'Cerrado',
                  child: Text('Cerrado'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    estado = value;
                  });
                }
              },
            ),

            const SizedBox(height: 20),

            const Text(
              'Observaciones',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: observacionesController,
              maxLines: 4,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(
                  Icons.notes,
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: guardando ? null : actualizarDano,
                icon: guardando
                    ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
                    : const Icon(Icons.save),
                label: Text(
                  guardando
                      ? 'GUARDANDO...'
                      : 'GUARDAR CAMBIOS',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}