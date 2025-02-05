import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:todolist_/lib/screentime.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyAk2KD7mpif1yXISL2Mzh0yxktihgcWZTE",
            authDomain: "todolist-4f822.firebaseapp.com",
            projectId: "todolist-4f822",
            storageBucket: "todolist-4f822.firebasestorage.app",
            messagingSenderId: "869554421401",
            appId: "1:869554421401:web:30cdf931d91e198f3b8208",
            measurementId: "G-HDB6V818T0"));
  } else {
    await Firebase.initializeApp();
  }

  runApp(const TodoListe());
}

class TodoListe extends StatelessWidget {
  const TodoListe({super.key});

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey, // Utilisation d'un GlobalKey unique
      debugShowCheckedModeBanner: false,
      home: Screentime(), // Page des tâches
    );
  }
}
