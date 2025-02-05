import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todolist_/lib/utils/edittask.dart';
import 'package:todolist_/lib/utils/task_list_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final CollectionReference tasksCollection =
      FirebaseFirestore.instance.collection('tasks');

  // Ajouter une nouvelle tâche dans Firestore
  void _addTask() {
    if (_titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty) {
      tasksCollection.add({
        'title': _titleController.text,
        'description': _descriptionController.text,
        'isCompleted': false, // Par défaut, la tâche est non complétée
      });
      _titleController.clear();
      _descriptionController.clear();
    }
  }

  // Fonction pour rediriger vers la page de modification
  void _editTask(String taskId, Map<String, dynamic> taskData) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTask(
          taskId: taskId,
          currentTitle: taskData['title'],
          currentDescription: taskData['description'],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent, // Appbar transparent
        elevation: 0, // Pas d'ombre sous l'appbar
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromRGBO(33, 150, 243, 1), Colors.purple],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.menu, color: Colors.white, // Change la couleur de l'icône
              size: 30,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TaskListPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FORMULAIRE D'AJOUT DE TÂCHE
            Text(
              "Ajouter une tâche",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 255, 255, 255)),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Titre',
                labelStyle: TextStyle(color: Colors.purple),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.teal),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.teal),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: TextStyle(color: Colors.purple),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.teal),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.teal),
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addTask,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple, // Fond du bouton
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 25),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'Ajouter la tâche',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),

            //  LECTURE EN TEMPS RÉEL DES TÂCHES (READ)
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: tasksCollection.snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  var tasks = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      var task = tasks[index];
                      String taskId = task.id;
                      Map<String, dynamic> data =
                          task.data() as Map<String, dynamic>;

                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(10),
                          title: Text(
                            data['title'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              decoration: data['isCompleted']
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          subtitle: Text(data['description']),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Checkbox(
                                value: data['isCompleted'],
                                onChanged: (bool? value) {
                                  _updateTaskStatus(taskId, value ?? false);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit,
                                    color: Colors.purple),
                                onPressed: () {
                                  _editTask(taskId, data);
                                },
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteTask(taskId),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Modifier le statut de la tâche
  void _updateTaskStatus(String taskId, bool isCompleted) {
    tasksCollection.doc(taskId).update({'isCompleted': isCompleted});
  }

  // Supprimer une tâche
  void _deleteTask(String taskId) {
    tasksCollection.doc(taskId).delete();
  }
}
