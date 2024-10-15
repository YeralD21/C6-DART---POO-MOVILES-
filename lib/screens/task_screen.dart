import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final List<Task> _tasks = []; // Lista para almacenar las tareas
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _selectedPriority = 'Medium';  // Prioridad por defecto
  int? _editIndex;  // Índice para saber qué tarea se está editando

  // Método para agregar o editar una tarea
  void _addOrEditTask() {
    if (_titleController.text.isNotEmpty && _descriptionController.text.isNotEmpty) {
      setState(() {
        if (_editIndex == null) {
          // Si no hay tarea seleccionada para editar, se agrega una nueva tarea
          _tasks.add(Task(
            title: _titleController.text,
            description: _descriptionController.text,
            dueDate: _selectedDate,
            priority: _selectedPriority,
          ));
        } else {
          // Editar la tarea existente
          _tasks[_editIndex!].editTask(
            _titleController.text,
            _descriptionController.text,
            _selectedDate,
            _selectedPriority,
          );
          _editIndex = null; // Resetear el índice después de editar
        }
        _titleController.clear();
        _descriptionController.clear();
      });
    }
  }

  // Método para cargar la tarea seleccionada en el formulario
  void _loadTaskForEdit(int index) {
    setState(() {
      _editIndex = index;
      _titleController.text = _tasks[index].title;
      _descriptionController.text = _tasks[index].description;
      _selectedDate = _tasks[index].dueDate;
      _selectedPriority = _tasks[index].priority;
    });
  }

  // Método para eliminar una tarea
  void _removeTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  // Método para cambiar el estado de completado de una tarea
  void _toggleTaskCompletion(int index) {
    setState(() {
      _tasks[index].toggleCompletion();
    });
  }

  // Método para seleccionar una fecha
  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Método para seleccionar prioridad
  void _selectPriority(String? newPriority) {
    if (newPriority != null) {
      setState(() {
        _selectedPriority = newPriority;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
        actions: [
          PopupMenuButton<String>(
            onSelected: _selectPriority,
            itemBuilder: (BuildContext context) {
              return ['High', 'Medium', 'Low'].map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Formulario para agregar o editar tarea
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Task Title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Task Description',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () => _selectDueDate(context),
                          child: const Text('Select Due Date'),
                        ),
                        const SizedBox(width: 20),
                        Text('Due: ${_selectedDate.toLocal()}'.split(' ')[0]),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _addOrEditTask,
                      child: Text(_editIndex == null ? 'Add Task' : 'Edit Task'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _tasks.isEmpty
                  ? const Center(child: Text('No tasks available'))
                  : ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  final task = _tasks[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    elevation: 2,
                    child: ListTile(
                      title: Text(
                        '${task.title} (${task.priority})',
                        style: TextStyle(
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          color: task.isCompleted
                              ? Colors.grey
                              : Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        '${task.description}\nDue: ${task.dueDate.toLocal()}'.split(' ')[0],
                      ),
                      leading: Checkbox(
                        value: task.isCompleted,
                        onChanged: (bool? value) {
                          _toggleTaskCompletion(index);
                        },
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _loadTaskForEdit(index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _removeTask(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
