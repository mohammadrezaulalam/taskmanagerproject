import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_manager_project_rafatvai/data/models/network_response.dart';
import 'package:task_manager_project_rafatvai/data/services/network_caller.dart';
import 'package:task_manager_project_rafatvai/data/utils/urls.dart';
import 'package:task_manager_project_rafatvai/ui/screens/auth/reset_password_screen.dart';
import 'package:task_manager_project_rafatvai/ui/widgets/app_background.dart';

import '../../style/style.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String recoveryEmail;
  const OtpVerificationScreen({super.key, required this.recoveryEmail});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpTEController = TextEditingController();
  bool _otpVerificationInProgress = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> otpVerification() async {
    _otpVerificationInProgress = true;
    if(mounted){
      setState(() {});
    }

    final NetworkResponse response = await NetworkCaller().getRequest(Urls.otpVerificationUrl(widget.recoveryEmail.toString(), _otpTEController.text.toString()));
    _otpVerificationInProgress = false;
    if(mounted){
      setState(() {});
    }

    if(response.isSuccess){
      if(mounted){
        //Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPasswordScreen(recoveryEmail: widget.recoveryEmail, recoveryOtp: _otpTEController.text.trim())), (route) => false);
        Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPasswordScreen(recoveryEmail: widget.recoveryEmail, recoveryOtp: _otpTEController.text.trim())));
      }
    }else{
      if(mounted){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('OTP Verification Failed', style: snackBarText(chipBgColorRed))));
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
                  Text('PIN Verification', style: appHeadingText1(colorBlack),),
                  const SizedBox(height: 10,),
                  Text('A 6 digit verification pin will be sent to  your email address', style: appHeadingText3(colorLightGrey),),
                  const SizedBox(height: 20,),
                  PinCodeTextField(
                    controller: _otpTEController,
                    validator: (String? value){
                      if((value?.isEmpty ?? true) || value!.length < 6){
                        return "Enter 6 Digit OTP";
                      }
                      return null;
                    },
                    length: 6,
                    obscureText: false,
                    animationType: AnimationType.fade,
                    keyboardType: TextInputType.number,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      inactiveBorderWidth: 0.4,
                      activeBorderWidth: 0.4,
                      selectedBorderWidth: 1,
                      inactiveFillColor: Colors.grey.shade100,
                      activeFillColor: Colors.white,
                      inactiveColor: Colors.grey.shade300,
                      selectedColor: Colors.green.shade100,
                      activeColor: Colors.white,
                      selectedFillColor: Colors.white,
                    ),
                    animationDuration: const Duration(milliseconds: 300),
                    backgroundColor: Colors.grey.shade50,
                    cursorColor: Colors.green,
                    cursorWidth: 1.5,
                    enableActiveFill: true,
                    enablePinAutofill: true,
                    onCompleted: (v) {
                    },
                    onChanged: (value) {
                    },
                    beforeTextPaste: (text) {
                      print("Allowing to paste $text");
                      //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                      //but you can show anything you want here, like your pop up saying wrong paste format or etc
                      return true;
                    }, appContext: context,
                  ),

                  const SizedBox(height: 25,),
                  SizedBox(
                    width: double.infinity,
                    child: Visibility(
                      visible: _otpVerificationInProgress == false,
                      replacement: const Center(child: CircularProgressIndicator(),),
                      child: ElevatedButton(
                        onPressed: (){
                          if(!_formKey.currentState!.validate()){
                            return;
                          }
                          otpVerification();
                          //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const ResetPasswordScreen()), (route) => false);

                        },
                        style: appButtonStyle(),
                        child: const Text('Verify'),
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
