import 'package:flutter/material.dart';
import 'package:task_manager_project_rafatvai/data/models/network_response.dart';
import 'package:task_manager_project_rafatvai/data/models/summary_count_model.dart';
import 'package:task_manager_project_rafatvai/data/models/task_list_model.dart';
import 'package:task_manager_project_rafatvai/data/services/network_caller.dart';
import 'package:task_manager_project_rafatvai/data/utils/urls.dart';
import 'package:task_manager_project_rafatvai/ui/screens/add_new_task_screen.dart';
import 'package:task_manager_project_rafatvai/ui/screens/update_task_status_sheet.dart';
import '../widgets/summary_card.dart';
import '../widgets/task_list_tile.dart';
import '../widgets/user_profile_banner.dart';
import '../style/style.dart';
import 'update_task_bottom_sheet.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  bool _getCountSummaryInProgress = false, _getNewTaskInProgress = false;
  SummaryCountModel _summaryCountModel = SummaryCountModel();
  TaskListModel _taskListModel = TaskListModel();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    //After Widget Binding
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCountSummary();
      getNewTasks();
    });
  }

  Future<void> getCountSummary() async {
    _getCountSummaryInProgress = true;
    if (mounted) {
      setState(() {});
    }

    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.taskStatusCountUrl);

    if (response.isSuccess) {
      _summaryCountModel = SummaryCountModel.fromJson(response.body!);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          'Failed to get Summary Data',
          style: snackBarText(chipBgColorRed),
        )));
      }
    }
    _getCountSummaryInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> getNewTasks() async {
    _getNewTaskInProgress = true;
    if (mounted) {
      setState(() {});
    }

    final NetworkResponse response =
        await NetworkCaller().getRequest(Urls.newTasksUrl);

    if (response.isSuccess) {
      _taskListModel = TaskListModel.fromJson(response.body!);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          'Failed to get New Task Data',
          style: snackBarText(chipBgColorRed),
        )));
      }
    }
    _getNewTaskInProgress = false;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> deleteTask(String taskId) async {
    final NetworkResponse response = await NetworkCaller().getRequest(Urls.deleteTasksUrl(taskId));
    if(response.isSuccess){
      _taskListModel.data!.removeWhere((element) => element.sId == taskId);
      if(mounted){
        setState(() {});
      }
    }else{
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              'Failed to delete Task Data',
              style: snackBarText(chipBgColorRed),
            )));
      }
    }
  }

  Future<void> updateTaskStatus(String taskId, String newStatus) async {
    final NetworkResponse response = await NetworkCaller().getRequest(Urls.updateTaskStatusUrl(taskId, newStatus));
    if(response.isSuccess){
      _taskListModel.data!.removeWhere((element) => element.sId == taskId);
      if(mounted){
        setState(() {});
      }
    }else{
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              'Failed to Update Task Status Data',
              style: snackBarText(chipBgColorRed),
            )));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const UserProfileBanner(),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: _getCountSummaryInProgress
          //       ? const LinearProgressIndicator()
          //       : const Row(
          //           children: [
          //             SummaryCard(
          //               number: '08',
          //               title: 'New Task',
          //             ),
          //             SummaryCard(
          //               number: '07',
          //               title: 'Completed',
          //             ),
          //             SummaryCard(
          //               number: '12',
          //               title: 'Progress',
          //             ),
          //             SummaryCard(
          //               number: '05',
          //               title: 'Cancelled',
          //             ),
          //           ],
          //         ),
          // ),

          _getCountSummaryInProgress
              ? const LinearProgressIndicator()
              : Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                height: 70,
                  width: double.infinity,
                  child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _summaryCountModel.data?.length ?? 0,
                      //reverse: true,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            SummaryCard(
                              number: "${_summaryCountModel.data![index].sum}",
                              title: _summaryCountModel.data![index].sId ?? '',
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider();
                      },
                    ),
                ),
              ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                getNewTasks();
              },
              child: _getNewTaskInProgress
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.separated(
                      itemCount: _taskListModel.data?.length ?? 0,
                      //reverse: true,
                      itemBuilder: (context, index) {
                        return TaskListTile(
                          chipBgColor: chipBgColorBlue,
                          taskStatus: 'New',
                          data: _taskListModel.data![index],
                          onDeleteTap: () {
                            deleteTask(_taskListModel.data![index].sId!);
                          },
                          onEditTap: () {
                            //showEditBottomSheet(_taskListModel.data![index]);
                            showStatusUpdateBottomSheet(_taskListModel.data![index]);
                          },
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider();
                      },
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddNewTaskScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void showEditBottomSheet(TaskData task) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return UpdateTaskSheet(
          task: task,
          onUpdate: () {
            getNewTasks();
            //getCountSummary();
          },
        );
      },
    );
  }

  void showStatusUpdateBottomSheet(TaskData task){

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return UpdateTaskStatusSheet(task: task, onUpdate: (){
          getNewTasks();
          getCountSummary();
        },);
      },
    );
  }
}

