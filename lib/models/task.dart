class Task {
  String title;
  String description;
  DateTime dueDate;        // Nueva propiedad: Fecha de vencimiento
  String priority;         // Nueva propiedad: Prioridad
  bool isCompleted;

  Task({
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    this.isCompleted = false,
  });

  // Método para alternar el estado de completado
  void toggleCompletion() {
    isCompleted = !isCompleted;
  }

  // Método para editar una tarea
  void editTask(String newTitle, String newDescription, DateTime newDueDate, String newPriority) {
    title = newTitle;
    description = newDescription;
    dueDate = newDueDate;
    priority = newPriority;
  }

  @override
  String toString() {
    return 'Task: $title, Priority: $priority, Due: ${dueDate.toLocal()}, Completed: $isCompleted';
  }
}
