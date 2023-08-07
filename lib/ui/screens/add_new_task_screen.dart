import 'package:flutter/material.dart';
import 'package:task_manager_project_rafatvai/data/models/network_response.dart';
import 'package:task_manager_project_rafatvai/data/services/network_caller.dart';
import 'package:task_manager_project_rafatvai/data/utils/urls.dart';
import 'package:task_manager_project_rafatvai/ui/style/style.dart';
import 'package:task_manager_project_rafatvai/ui/widgets/app_background.dart';
import 'package:task_manager_project_rafatvai/ui/widgets/user_profile_banner.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {

  final TextEditingController _titleTEController = TextEditingController();
  final TextEditingController _descriptionTEController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _addNewTaskInProgress = false;
  
  Future<void> addNewTask() async {

    _addNewTaskInProgress = true;
    if(mounted){
      setState(() {});
    }

    Map<String, dynamic> requestBody = {
      "title": _titleTEController.text.trim(),
      "description": _descriptionTEController.text.trim(),
      "status": "New"
    };

    final NetworkResponse response = await NetworkCaller().postRequest(Urls.createTaskUrl, requestBody);

    _addNewTaskInProgress = false;
    if(mounted){
      setState(() {});
    }

    if(response.isSuccess){
      _titleTEController.clear();
      _descriptionTEController.clear();

      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Task Created Successfully', style: snackBarText(chipBgColorGreen),)));
      }
    }else{
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Task Creation Failed', style: snackBarText(chipBgColorRed),)));
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const UserProfileBanner(),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height/16),
                      Text('Add New Task', style: appHeadingText1(colorBlack),),
                      const SizedBox(height: 20,),
                      TextFormField(
                        controller: _titleTEController,
                        decoration: myInputDecoration('Title'),
                        validator: (String? value){
                          if(value?.isEmpty ?? true){
                            return 'Enter Task Title';
                          }
                          return null;
                        },

                      ),
                      const SizedBox(height: 20,),
                      TextFormField(
                        controller: _descriptionTEController,
                        decoration: myInputDecoration('Description'),
                        keyboardType: TextInputType.multiline,
                        maxLines: 7,
                        validator: (String? value){
                          if(value?.isEmpty ?? true){
                            return 'Enter Task Description';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20,),
                      SizedBox(
                        width: double.infinity,
                        child: Visibility(
                          visible: _addNewTaskInProgress == false,
                          replacement: const Center(child: CircularProgressIndicator(),),
                          child: ElevatedButton(
                            onPressed: (){
                              if(!_formKey.currentState!.validate()){
                                return;
                              }
                              addNewTask();
                            },
                            style: appButtonStyle(),
                            child: const Icon(Icons.arrow_circle_right_outlined),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

      ),
    );
  }
}
