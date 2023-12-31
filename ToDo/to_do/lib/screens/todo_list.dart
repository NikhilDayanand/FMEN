import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:to_do/screens/add_page.dart';
import 'package:http/http.dart' as http;

class ToDoListPage extends StatefulWidget {
  const ToDoListPage({super.key});

  @override
  State<ToDoListPage> createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  List items = [];
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchToDo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ToDo List"),
      ),
      body: Visibility(
        visible: isLoading,
        replacement: RefreshIndicator(
          onRefresh: fetchToDo,
          child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index] as Map;
                final id = item['_id'] as String;

                return ListTile(
                  leading: Text('${index + 1}'),
                  title: Text(item['title']),
                  subtitle: Text(item['description']),
                  trailing: PopupMenuButton(onSelected: (value) {
                    if (value == 'edit') {
                      //open Edit page
                      navigateToEditPage(item);
                    } else if (value == 'delete') {
                      //Delete and remove the item;
                      deleteById(id);
                    }
                  }, itemBuilder: (context) {
                    return [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      )
                    ];
                  }),
                );
              }),
        ),
        child: const Center(child: CircularProgressIndicator()),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            navigateToAddPage();
          },
          label: const Text("Add Todo")),
    );
  }

  Future<void> navigateToEditPage(Map item) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTodoPage(todo: item)),
    );
    setState(() {
      isLoading = true;
    });
    fetchToDo();
  }

  Future<void> navigateToAddPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddTodoPage()),
    );
    setState(() {
      isLoading = true;
    });
    fetchToDo();
  }

  Future<void> deleteById(String id) async {
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);

    final response = await http.delete(uri);
    if (response.statusCode == 200) {
      //Remove item from the list
      final filtered = items.where((element) => element('_id') != id).toList();
      setState(() {
        items = filtered;
      });
    } else {
      showErrorMessage("Deletion Failed");
    }
  }

  Future<void> fetchToDo() async {
    const url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      setState(() {
        items = result;
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  void showSuccessMsg(String msg) {
    final snackBar = SnackBar(content: Text(msg));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showErrorMessage(String msg) {
    final snackBar = SnackBar(content: Text(msg), backgroundColor: Colors.red);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
