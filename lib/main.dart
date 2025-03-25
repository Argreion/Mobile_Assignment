import 'package:flutter/material.dart';

void main() {
  runApp(const AssignmentApp());
}

// Custom class for items
class Item {
  String name;
  Item(this.name);
}

// Custom stateless widget (a reusable ItemCard)
class ItemCard extends StatelessWidget {
  final String title;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const ItemCard({
    Key? key,
    required this.title,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
            IconButton(icon: const Icon(Icons.delete), onPressed: onDelete),
          ],
        ),
      ),
    );
  }
}

class AssignmentApp extends StatefulWidget {
  const AssignmentApp({Key? key}) : super(key: key);

  @override
  State<AssignmentApp> createState() => _AssignmentAppState();
}

class _AssignmentAppState extends State<AssignmentApp> {
  final List<Item> _items = [];
  final TextEditingController _controller = TextEditingController();
  int? _editingIndex;

  void _addItem() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        if (_editingIndex == null) {
          _items.add(Item(_controller.text)); // Create
        } else {
          _items[_editingIndex!] = Item(_controller.text); // Update
          _editingIndex = null;
        }
        _controller.clear();
      });
    }
  }

  void _editItem(int index) {
    setState(() {
      _controller.text = _items[index].name;
      _editingIndex = index;
    });
  }

  void _deleteItem(int index) {
    setState(() {
      _items.removeAt(index); // Delete
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text("Assignment App")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: "Enter item name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _addItem,
                child: Text(_editingIndex == null ? "Add Item" : "Update Item"),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    return ItemCard(
                      title: _items[index].name,
                      onEdit: () => _editItem(index),
                      onDelete: () => _deleteItem(index),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

