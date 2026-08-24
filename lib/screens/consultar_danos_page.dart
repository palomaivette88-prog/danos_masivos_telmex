import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'editar_dano_page.dart';

class ConsultarDanosPage extends StatelessWidget {
  Future<void> _eliminarDano(
      BuildContext context,
      String documentoId,
      String folio,
      ) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Eliminar daño',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            '¿Deseas eliminar el daño con folio "$folio"?\n\n'
                'Esta acción no se puede deshacer.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('CANCELAR'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('ELIMINAR'),
            ),
          ],
        );
      },
    );

    if (confirmar != true) {
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('danos')
          .doc(documentoId)
          .delete();

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Daño eliminado correctamente de Firebase.',
          ),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error al eliminar el daño: $e',
          ),
        ),
      );
    }
  }
  const ConsultarDanosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Consultar daños',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('danos')
            .orderBy('fechaHora', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          // Error
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Error al consultar los daños:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          // Cargando
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final documentos = snapshot.data?.docs ?? [];

          // Sin registros
          if (documentos.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 70,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 15),
                  Text(
                    'No hay daños registrados',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }

          // Lista de daños
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: documentos.length,
            itemBuilder: (context, index) {
              final documento = documentos[index];
              final datos = documento.data() as Map<String, dynamic>;

              final tipoDano =
                  datos['tipoDano']?.toString() ?? 'Sin información';

              final central =
                  datos['central']?.toString() ?? 'Sin información';

              final folio =
                  datos['folio']?.toString() ?? 'Sin información';

              final cope =
                  datos['cope']?.toString() ?? 'Sin información';

              final estado =
                  datos['estado']?.toString() ?? 'Sin información';

              final observaciones =
                  datos['observaciones']?.toString() ?? 'Sin información';

              return Card(
                  margin: const EdgeInsets.only(bottom: 14),
                  elevation: 2,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditarDanoPage(
                                documentoId: documento.id,
                                datos: datos,
                              ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Encabezado
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor:
                                tipoDano.toLowerCase().contains('fibra')
                                    ? Colors.blue.shade50
                                    : Colors.orange.shade50,
                                child: Icon(
                                  tipoDano.toLowerCase().contains('fibra')
                                      ? Icons.content_cut
                                      : Icons.cable,
                                  color: tipoDano.toLowerCase().contains('fibra')
                                      ? Colors.blue
                                      : Colors.orange,
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: Text(
                                  tipoDano,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              IconButton(
                                tooltip: 'Eliminar daño',
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  _eliminarDano(
                                    context,
                                    documento.id,
                                    folio,
                                  );
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 15),

                          // Datos
                          _DatoRow(
                            icon: Icons.account_balance,
                            label: 'Central',
                            valor: central,
                          ),

                          _DatoRow(
                            icon: Icons.receipt_long,
                            label: 'Folio',
                            valor: folio,
                          ),

                          _DatoRow(
                            icon: Icons.engineering,
                            label: 'COPE',
                            valor: cope,
                          ),

                          _DatoRow(
                            icon: Icons.sync,
                            label: 'Estado',
                            valor: estado,
                          ),

                          _DatoRow(
                            icon: Icons.notes,
                            label: 'Observaciones',
                            valor: observaciones,
                          ),

                          const SizedBox(height: 10),

                          // Estado
                          Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: estadoColor(estado).withOpacity(0.12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                estado,
                                style: TextStyle(
                                  color: estadoColor(estado),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              );
              },
          );
        },
      ),
    );
  }

  Color estadoColor(String estado) {
    switch (estado.toLowerCase()) {
      case 'reportado':
        return Colors.red;
      case 'en atención':
        return Colors.orange;
      case 'cerrado':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}

class _DatoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String valor;

  const _DatoRow({
    required this.icon,
    required this.label,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 19,
            color: Colors.blue.shade700,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: DefaultTextStyle
                    .of(context)
                    .style,
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: valor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}