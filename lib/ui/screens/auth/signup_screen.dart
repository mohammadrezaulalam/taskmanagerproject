import 'package:flutter/material.dart';
import 'package:task_manager_project_rafatvai/data/models/network_response.dart';
import 'package:task_manager_project_rafatvai/data/services/network_caller.dart';
import 'package:task_manager_project_rafatvai/data/utils/urls.dart';
import 'package:task_manager_project_rafatvai/ui/style/style.dart';
import '../../widgets/app_background.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();

  bool _signupInProgress = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void userSignUp() async {
    _signupInProgress = true;
    if(mounted){
      setState(() { });
    }

    Map<String, dynamic> requestBody = <String, dynamic>{
      "email" : _emailTEController.text.trim(),
      "firstName" : _firstNameTEController.text.trim(),
      "lastName" : _lastNameTEController.text.trim(),
      "mobile" : _mobileTEController.text.trim(),
      "password" : _passwordTEController.text.trim(),
      "photo" : '',
    };

    final NetworkResponse response = await NetworkCaller().postRequest(Urls.registrationUrl, requestBody);
    _signupInProgress = false;
    if(mounted){
      setState(() { });
    }
    if(response.isSuccess){
      _emailTEController.clear();
      _firstNameTEController.clear();
      _lastNameTEController.clear();
      _mobileTEController.clear();
      _passwordTEController.clear();
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration Success')));
      }
      }else{
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registration Failed')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height/11),
                  Text('Join With Us', style: appHeadingText1(colorBlack),),
                  const SizedBox(height: 20,),
                  TextFormField(
                    controller: _emailTEController,
                    decoration: myInputDecoration('Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (String? value){
                      if(value?.isEmpty ?? true){
                        return 'Enter Your Email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15,),
                  TextFormField(
                    controller: _firstNameTEController,
                    decoration: myInputDecoration('First Name'),
                    validator: (String? value){
                      if(value?.isEmpty ?? true){
                        return 'Enter Your First Name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15,),
                  TextFormField(
                    controller: _lastNameTEController,
                    decoration: myInputDecoration('Last Name'),
                    validator: (String? value){
                      if(value?.isEmpty ?? true){
                        return 'Enter Your Last Name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15,),
                  TextFormField(
                    controller: _mobileTEController,
                    decoration: myInputDecoration('Mobile'),
                    keyboardType: TextInputType.phone,
                    validator: (String? value){
                      if((value?.isEmpty ?? true) || value!.length < 11){
                        return 'Enter Your Mobile Number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15,),
                  TextFormField(
                    controller: _passwordTEController,
                    decoration: myInputDecoration('Password'),
                    obscureText: true,
                    validator: (String? value){
                      if((value?.isEmpty ?? true) || value!.length < 3){
                        return 'Enter Your Password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15,),
                  SizedBox(
                    width: double.infinity,
                    child: Visibility(
                      visible: _signupInProgress == false,
                      replacement: const Center(child: CircularProgressIndicator(),),
                      child: ElevatedButton(
                        onPressed: (){
                          if(!_formKey.currentState!.validate()){
                            return;
                          }
                          userSignUp();
                        },
                        style: appButtonStyle(),
                        child: const Icon(Icons.arrow_circle_right_outlined),
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        const SizedBox(height: 35,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Text("Have an account?", style: appHeadingText5(colorBlack),),
                            InkWell(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              child: Text(' Sign in', style: appHeadingText5(colorGreen),),),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
}


