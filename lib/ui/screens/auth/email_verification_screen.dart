import 'package:flutter/material.dart';
import 'package:task_manager_project_rafatvai/data/models/network_response.dart';
import 'package:task_manager_project_rafatvai/data/services/network_caller.dart';
import 'package:task_manager_project_rafatvai/data/utils/urls.dart';
import 'package:task_manager_project_rafatvai/ui/screens/auth/otp_verification_screen.dart';
import 'package:task_manager_project_rafatvai/ui/widgets/app_background.dart';

import '../../style/style.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({super.key});

  @override
  State<EmailVerificationScreen> createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {

  final TextEditingController _emailTEController = TextEditingController();
  bool _emailVerificationInProgress = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> emailVerification() async {
    _emailVerificationInProgress = true;
    if(mounted){
      setState(() {});
    }
    final NetworkResponse response = await NetworkCaller().getRequest(Urls.emailVerificationUrl(_emailTEController.text.trim()));

    _emailVerificationInProgress = false;
    if(mounted){
      setState(() {});
    }

    if(response.isSuccess){
      if(mounted) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OtpVerificationScreen(
                    recoveryEmail: _emailTEController.text.trim())));
      }else{
        if(mounted){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Email Verification Failed', style: snackBarText(chipBgColorRed))));
        }
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
                  Text('Your Email Address', style: appHeadingText1(colorBlack),),
                  const SizedBox(height: 10,),
                  Text('A 6 digit verification pin will be sent to  your email address', style: appHeadingText3(colorLightGrey),),
                  const SizedBox(height: 20,),
                  TextFormField(
                    controller: _emailTEController,
                    decoration: myInputDecoration('Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (String? value){
                      if(value?.isEmpty ?? true){
                        return "Enter Email Address";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 25,),
                  SizedBox(
                    width: double.infinity,
                    child: Visibility(
                      visible: _emailVerificationInProgress == false,
                      replacement: const Center(child: CircularProgressIndicator(),),
                      child: ElevatedButton(
                        onPressed: (){
                          if(!_formKey.currentState!.validate()){
                            return;
                          }
                          emailVerification();
                          //Navigator.push(context, MaterialPageRoute(builder: (context) => OtpVerificationScreen(),),);
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
                            const SizedBox(height: 30,),
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
      ),
    );
  }
}
