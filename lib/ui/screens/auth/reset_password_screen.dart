import 'package:flutter/material.dart';
import 'package:task_manager_project_rafatvai/data/models/network_response.dart';
import 'package:task_manager_project_rafatvai/data/services/network_caller.dart';
import 'package:task_manager_project_rafatvai/data/utils/urls.dart';
import 'package:task_manager_project_rafatvai/ui/screens/auth/login_screen.dart';
import 'package:task_manager_project_rafatvai/ui/widgets/app_background.dart';

import '../../style/style.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String recoveryEmail, recoveryOtp;
  const ResetPasswordScreen({super.key, required this.recoveryEmail, required this.recoveryOtp});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {

  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _confirmPasswordTEController = TextEditingController();
  bool _resetPasswordInProgress = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  Future<void> resetPassword() async {
    _resetPasswordInProgress = true;
    if(mounted){
      setState(() {});
    }

    final Map<String, dynamic> requestBody = {
      "email": widget.recoveryEmail,
      "OTP": widget.recoveryOtp,
      "password": _passwordTEController.text
    };

    final NetworkResponse response = await NetworkCaller().postRequest(Urls.recoverPasswordResetUrl, requestBody);
    _resetPasswordInProgress = false;
    if(mounted){
      setState(() {});
    }
    if(response.isSuccess) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              'Password Reset Successful',
              style: snackBarText(chipBgColorGreen),
            )));
      }
      if (mounted) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false);
      }
    }else{
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              'Password Reset Failed',
              style: snackBarText(chipBgColorRed),
            )));
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
                  SizedBox(height: MediaQuery.of(context).size.height/4),
                  Text('Reset Password', style: appHeadingText1(colorBlack),),
                  const SizedBox(height: 10,),
                  Text('Minimum password length should be 8 characters with letter and number combination', style: appHeadingText3(colorLightGrey),),
                  const SizedBox(height: 20,),
                  TextFormField(
                    controller: _passwordTEController,
                    decoration: myInputDecoration('Password'),
                    obscureText: true,
                    validator: (String? value){
                      if(value?.isEmpty ?? true){
                        return "Enter Password";
                      }else if(value!.length < 6){
                        return "Enter at least 6 Character Password";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _confirmPasswordTEController,
                    decoration: myInputDecoration('Confirm Password'),
                    obscureText: true,
                    validator: (String? value){
                      if(value?.isEmpty ?? true){
                        return "Enter Confirm Password";
                      }else if(value != _passwordTEController.text){
                        return "Confirm Password didn't match with Password";
                      }
                      return null;
                    },

                  ),

                  const SizedBox(height: 25,),
                  SizedBox(
                    width: double.infinity,
                    child: Visibility(
                      visible: _resetPasswordInProgress == false,
                      replacement: const Center(child: CircularProgressIndicator(),),
                      child: ElevatedButton(
                        onPressed: (){
                          //Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen(),),);
                          if(!_formKey.currentState!.validate()){
                            return;
                          }
                          resetPassword();
                        },
                        style: appButtonStyle(),
                        child: const Text('Confirm'),
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
                            const SizedBox(height: 30,),
                            Text("Have an account?", style: appHeadingText5(colorBlack),),
                            InkWell(
                              onTap: (){
                                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
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
      ),
    );
  }
}
