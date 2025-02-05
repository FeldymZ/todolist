import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditTask extends StatefulWidget {
  final String taskId; // L'ID de la tâche à modifier
  final String currentTitle; // Le titre actuel de la tâche
  final String currentDescription; // La description actuelle de la tâche

  const EditTask({
    super.key,
    required this.taskId,
    required this.currentTitle,
    required this.currentDescription,
  });

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.currentTitle;
    _descriptionController.text = widget.currentDescription;
  }

  // Fonction de mise à jour de la tâche
  void _updateTask() {
    FirebaseFirestore.instance.collection('tasks').doc(widget.taskId).update({
      'title': _titleController.text,
      'description': _descriptionController.text,
    }).then((_) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context); // Retour à la page précédente après mise à jour
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent, // Change la couleur de l'AppBar
        title: const Text('Modifier la tâche',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Titre du formulaire
            const Text(
              "Modifiez les détails de la tâche",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 20),

            // Champ de saisie pour le titre
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Titre',
                labelStyle: TextStyle(color: Colors.blueAccent),
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Champ de saisie pour la description
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                labelStyle: TextStyle(color: Colors.blueAccent),
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(fontSize: 16),
              maxLines: 4, // Permet plusieurs lignes pour la description
            ),
            const SizedBox(height: 30),

            // Bouton de mise à jour
            Center(
              child: ElevatedButton(
                onPressed: _updateTask,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent, // Couleur du bouton
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text(
                  'Mettre à jour',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
