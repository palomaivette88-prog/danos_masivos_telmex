import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class RegistrarDanoPage extends StatefulWidget {
  const RegistrarDanoPage({super.key});

  @override
  State<RegistrarDanoPage> createState() => _RegistrarDanoPageState();
}

class _RegistrarDanoPageState extends State<RegistrarDanoPage> {
  String tipoDano = 'Daño en cobre (CU)';
  String estado = 'Reportado';

  final TextEditingController centralController = TextEditingController();
  final TextEditingController folioController = TextEditingController();
  final TextEditingController copeController = TextEditingController();
  final TextEditingController observacionesController =
  TextEditingController();

  @override
  void dispose() {
    centralController.dispose();
    folioController.dispose();
    copeController.dispose();
    observacionesController.dispose();
    super.dispose();
  }

  Future<void> registrarDano() async {
    if (centralController.text.isEmpty ||
        folioController.text.isEmpty ||
        copeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Por favor completa los campos obligatorios.',
          ),
        ),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('danos').add({
        'tipoDano': tipoDano,
        'central': centralController.text.trim(),
        'folio': folioController.text.trim(),
        'cope': copeController.text.trim(),
        'estado': estado,
        'observaciones': observacionesController.text.trim(),
        'fechaHora': Timestamp.now(),
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Daño registrado correctamente en Firebase.',
          ),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error al registrar el daño: $e',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Registrar daño',
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
              'Información del daño',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Captura la información del incidente',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 25),

            // Tipo de daño
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

            // Central
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
                hintText: 'Ejemplo: Central Morelia Centro',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(
                  Icons.account_balance,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Folio
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
                hintText: 'Ejemplo: DM-2026-001',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(
                  Icons.receipt_long,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // COPE
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
                hintText: 'Ejemplo: COPE Morelia',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(
                  Icons.engineering,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Estado
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

            // Observaciones
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
                hintText: 'Describe brevemente el incidente...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(
                  Icons.notes,
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Ubicación
            Card(
              child: ListTile(
                leading: Icon(
                  Icons.location_on,
                  color: Colors.blue.shade700,
                  size: 32,
                ),
                title: const Text(
                  'Ubicación',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text(
                  'La ubicación GPS se agregará posteriormente',
                ),
              ),
            ),

            const SizedBox(height: 25),

            // Evidencia
            Card(
              child: ListTile(
                leading: Icon(
                  Icons.camera_alt,
                  color: Colors.blue.shade700,
                  size: 32,
                ),
                title: const Text(
                  'Evidencia fotográfica',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text(
                  'La cámara y almacenamiento se agregarán posteriormente',
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Botón registrar
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: registrarDano,
                icon: const Icon(
                  Icons.save,
                ),
                label: const Text(
                  'REGISTRAR DAÑO',
                  style: TextStyle(
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