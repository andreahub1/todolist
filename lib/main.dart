import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

void main() {
  runApp(const TodoListApp());
}

class TodoListApp extends StatelessWidget {
  const TodoListApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To Do List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: false,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const TodoHomePage(),
    );
  }
}

class TodoHomePage extends StatefulWidget {
  const TodoHomePage({super.key});

  @override
  State<TodoHomePage> createState() => _TodoHomePageState();
}

class _TodoHomePageState extends State<TodoHomePage> {
  final TextEditingController _taskController = TextEditingController();
  final List<String> _tasks = ['tarea5', 'tarea1', 'tarea4', 'tarea2', 'tarea3'];

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  void _addTask() {
    final task = _taskController.text.trim();
    if (task.isEmpty) return;

    setState(() {
      _tasks.insert(0, task);
      _taskController.clear();
    });
    FocusScope.of(context).unfocus();
  }

  void _editTask(int index) {
    final controller = TextEditingController(text: _tasks[index]);

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Editar tarea'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Escribe la tarea',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (_) {
            final value = controller.text.trim();
            if (value.isNotEmpty) {
              setState(() => _tasks[index] = value);
              Navigator.pop(dialogContext);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final value = controller.text.trim();
              if (value.isNotEmpty) {
                setState(() => _tasks[index] = value);
                Navigator.pop(dialogContext);
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  void _deleteTask(int index) {
    final deletedTask = _tasks[index];
    setState(() => _tasks.removeAt(index));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Se eliminó "$deletedTask"'),
        action: SnackBarAction(
          label: 'DESHACER',
          onPressed: () {
            setState(() => _tasks.insert(index, deletedTask));
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'To Do List',
          style: TextStyle(color: Colors.black87, fontSize: 22),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 3,
        iconTheme: const IconThemeData(color: Colors.black54),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _addTask(),
                    decoration: const InputDecoration(
                      hintText: 'Ingresa una tarea...',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 2),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  height: 38,
                  width: 42,
                  child: ElevatedButton(
                    onPressed: _addTask,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE5E5E5)),
          Expanded(
            child: _tasks.isEmpty
                ? const Center(
                    child: Text(
                      'No hay tareas. Agrega una nueva.',
                      style: TextStyle(color: Colors.black54),
                    ),
                  )
                : ReorderableListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: _tasks.length,
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        if (newIndex > oldIndex) newIndex--;
                        final task = _tasks.removeAt(oldIndex);
                        _tasks.insert(newIndex, task);
                      });
                    },
                    itemBuilder: (context, index) {
                      final task = _tasks[index];
                      return Slidable(
                        key: ValueKey('$task-$index'),
                        endActionPane: ActionPane(
                          motion: const DrawerMotion(),
                          extentRatio: 0.42,
                          children: [
                            SlidableAction(
                              onPressed: (_) => _editTask(index),
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              icon: Icons.edit,
                              label: 'Editar',
                            ),
                            SlidableAction(
                              onPressed: (_) => _deleteTask(index),
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Borrar',
                            ),
                          ],
                        ),
                        child: Container(
                          color: Colors.white,
                          child: ListTile(
                            title: Text(
                              task,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            trailing: const Icon(
                              Icons.drag_handle,
                              color: Colors.black38,
                            ),
                            minVerticalPadding: 16,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
