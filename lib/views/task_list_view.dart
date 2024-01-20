import 'package:dutask/providers/filtered_tasks_provider.dart';
import 'package:dutask/views/settings_view.dart';
import 'package:dutask/views/task_form_view.dart';
import 'package:dutask/widgets/filter_navigation_bar.dart';
import 'package:dutask/widgets/task_item.dart';
import 'package:flutter/material.dart';
import 'package:dutask/widgets/task_list_filter_row.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskListView extends ConsumerStatefulWidget {
  const TaskListView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TaskListViewState();
}

class _TaskListViewState extends ConsumerState<TaskListView> {
  final _scrollController = ScrollController();
  bool _isFloatingActionButtonVisible = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels > 0) {
          if (_isFloatingActionButtonVisible) {
            setState(() {
              _isFloatingActionButtonVisible = false;
            });
          }
        }
      } else {
        if (!_isFloatingActionButtonVisible) {
          setState(() {
            _isFloatingActionButtonVisible = true;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(filteredTasks);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dutask'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SettingsView(),
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          TaskListFilterRow(),
          Expanded(
            child: tasks.isEmpty
                ? Center(
                    child: Text('There are no tasks at the moment.'),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: tasks.length,
                    itemBuilder: (context, index) => TaskItem(tasks[index]),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: FilterNavigationBar(),
      floatingActionButton: Visibility(
        visible: _isFloatingActionButtonVisible,
        child: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TaskFormView(),
            ),
          ),
        ),
      ),
    );
  }
}
