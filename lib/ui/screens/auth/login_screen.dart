import 'package:flutter/material.dart';
import 'package:task_manager_project_rafatvai/data/models/auth_utility.dart';
import 'package:task_manager_project_rafatvai/data/models/login_model.dart';
import 'package:task_manager_project_rafatvai/data/models/network_response.dart';
import 'package:task_manager_project_rafatvai/data/services/network_caller.dart';
import 'package:task_manager_project_rafatvai/ui/screens/auth/email_verification_screen.dart';
import 'package:task_manager_project_rafatvai/ui/screens/auth/signup_screen.dart';
import 'package:task_manager_project_rafatvai/ui/style/style.dart';
import '../../../data/utils/urls.dart';
import '../../widgets/app_background.dart';
import '../bottom_nav_base_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();

  bool _loginInProgress = false;

  Future<void> login() async {
    _loginInProgress = true;
    if (mounted) {
      setState(() {});
    }
    Map<String, dynamic> requestBody = {
      "email": _emailTEController.text.trim(),
      "password": _passwordTEController.text
    };
    final NetworkResponse response = await NetworkCaller().postRequest(Urls.loginUrl, requestBody, isLogin: true);

    _loginInProgress = false;
    if (mounted) {
      setState(() {});
    }
    if (response.isSuccess) {
      LoginModel model = LoginModel.fromJson(response.body!);
      await AuthUtility.saveUserInfo(model);
      if (mounted) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => const BottomNavBaseScreen()),
            (route) => false);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          'Incorrect Email or Password',
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
                SizedBox(height: MediaQuery.of(context).size.height / 4),
                Text(
                  'Get Started With',
                  style: appHeadingText1(colorBlack),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _emailTEController,
                  decoration: myInputDecoration('Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (String? value) {
                    if (value?.isEmpty ?? true) {
                      return "Provide a Valid Email";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: _passwordTEController,
                  decoration: myInputDecoration('Password'),
                  obscureText: true,
                  validator: (String? value) {
                    if (value?.isEmpty ?? true) {
                      return "Enter Password";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Visibility(
                    visible: _loginInProgress == false,
                    replacement: const Center(
                      child: CircularProgressIndicator(),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        login();
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
                      const SizedBox(
                        height: 35,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const EmailVerificationScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Forgot Password?',
                          style: appHeadingText6(colorLightGrey),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          Text(
                            "Don't have an account?",
                            style: appHeadingText5(colorBlack),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SignupScreen()));
                            },
                            child: Text(
                              ' Sign Up',
                              style: appHeadingText5(colorGreen),
                            ),
                          ),
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
    ));
  }
}
