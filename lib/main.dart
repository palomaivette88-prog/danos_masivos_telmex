import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

import 'screens/registrar_dano_page.dart';
import 'screens/consultar_danos_page.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const DanosMasivosApp());
}

class DanosMasivosApp extends StatelessWidget {
  const DanosMasivosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Daños Masivos TELMEX',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        scaffoldBackgroundColor: Colors.grey.shade100,
      ),
      home: const InicioPage(),
    );
  }
}

class InicioPage extends StatelessWidget {
  const InicioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daños Masivos TELMEX',
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

            // Encabezado
            const Text(
              'Panel de operación',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Registro y seguimiento de daños en la red de Morelia',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
              ),
            ),

            const SizedBox(height: 25),

            // Resumen
            const DashboardResumen(),


            const Text(
              'Acciones principales',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),





            const SizedBox(height: 15),

            // Registrar daño
            _MenuCard(
              icon: Icons.add_circle_outline,
              title: 'Registrar daño',
              description: 'Agregar un nuevo daño masivo',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegistrarDanoPage(),
                    ),
                  );
                },
            ),

            const SizedBox(height: 12),

            // Consultar daños
            _MenuCard(
              icon: Icons.search,
              title: 'Consultar daños',
              description: 'Consultar daños registrados',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ConsultarDanosPage(),
                    ),
                  );

              },
            ),

            const SizedBox(height: 12),

            // Mapa
            _MenuCard(
              icon: Icons.location_on_outlined,
              title: 'Mapa de daños',
              description: 'Visualizar daños en Morelia',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Módulo de mapa próximamente',
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            // Estadísticas
            _MenuCard(
              icon: Icons.bar_chart,
              title: 'Estadísticas',
              description: 'Consultar información de los daños',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Módulo de estadísticas próximamente',
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 25),

            // Tipos de daños
            const Text(
              'Tipos de daños',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Row(
              children: [
                Expanded(
                  child: _DamageTypeCard(
                    icon: Icons.content_cut,
                    title: 'Fibra óptica',
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _DamageTypeCard(
                    icon: Icons.cable,
                    title: 'Robo de cable',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Tarjeta principal del menú
class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [

              Container(
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 30,
                  color: Colors.blue.shade700,
                ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.arrow_forward_ios,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Tarjetas para tipos de daños
class _DamageTypeCard extends StatelessWidget {
  final IconData icon;
  final String title;

  const _DamageTypeCard({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 10,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 35,
              color: Colors.blue.shade700,
            ),

            const SizedBox(height: 10),

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class DashboardResumen extends StatelessWidget {
  const DashboardResumen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('danos')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'No se pudo cargar el resumen.',
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        final documentos = snapshot.data?.docs ?? [];

        int enAtencion = 0;
        int cerrados = 0;

        for (final documento in documentos) {
          final datos =
          documento.data() as Map<String, dynamic>;

          final estado =
              datos['estado']?.toString() ?? '';

          if (estado == 'En atención') {
            enAtencion++;
          }

          if (estado == 'Cerrado') {
            cerrados++;
          }
        }

        final total = documentos.length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resumen de daños',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _ResumenCard(
                    icon: Icons.warning_amber_rounded,
                    titulo: 'Total',
                    valor: total.toString(),
                    color: Colors.blue,
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: _ResumenCard(
                    icon: Icons.engineering,
                    titulo: 'En atención',
                    valor: enAtencion.toString(),
                    color: Colors.orange,
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: _ResumenCard(
                    icon: Icons.check_circle_outline,
                    titulo: 'Cerrados',
                    valor: cerrados.toString(),
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
class _ResumenCard extends StatelessWidget {
  final IconData icon;
  final String titulo;
  final String valor;
  final Color color;

  const _ResumenCard({
    required this.icon,
    required this.titulo,
    required this.valor,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 8,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 28,
              color: color,
            ),

            const SizedBox(height: 8),

            Text(
              valor,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              titulo,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

