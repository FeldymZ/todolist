import 'package:flutter/material.dart';
import 'package:todolist_/lib/home.dart';

class Screentime extends StatefulWidget {
  const Screentime({super.key});

  @override
  State<Screentime> createState() => _ScreentimeState();
}

class _ScreentimeState extends State<Screentime> {
  @override
  void initState() {
    super.initState();

    // Sécurisation de l'accès au contexte lors de la navigation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 6), () {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const Home()),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fond avec dégradé
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.fromRGBO(33, 150, 243, 1), Colors.purple],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Contenu centré
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Titre
                const Text(
                  "Todo_LIST",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                // Image
                Image.asset(
                  'assets/Welcome.png',
                  height: 150,
                  errorBuilder: (context, error, stackTrace) {
                    return const Text(
                      'Image non trouvée',
                      style: TextStyle(color: Colors.white),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
