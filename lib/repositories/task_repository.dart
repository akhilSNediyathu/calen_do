import 'package:calen_do/model/task_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class TaskRepository {
  final CollectionReference taskCollection =
      FirebaseFirestore.instance.collection('tasks');

  Future<void> addTask(Task task) {
    return taskCollection.add(task.toMap());
  }

  Future<void> updateTask(Task task) {
    return taskCollection.doc(task.id).update(task.toMap());
  }

  Future<void> deleteTask(String id) {
    return taskCollection.doc(id).delete();
  }

  Stream<List<Task>> getTasks() {
    return taskCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Task.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }
}
