import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_manager_project_rafatvai/data/models/auth_utility.dart';
import 'package:task_manager_project_rafatvai/ui/screens/auth/login_screen.dart';
import 'package:task_manager_project_rafatvai/ui/screens/bottom_nav_base_screen.dart';
import 'package:task_manager_project_rafatvai/ui/utils/assets_utils.dart';
import 'package:task_manager_project_rafatvai/ui/widgets/app_background.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    navigateToLogin();
  }

  
  Future<void> navigateToLogin() async {


    Future.delayed(const Duration(seconds: 3)).then((_) async {
      final bool isLoggedIn = await AuthUtility.checkIfUserLoggedIn();

      if(mounted){
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => isLoggedIn
                    ? const BottomNavBaseScreen()
                    : const LoginScreen()),
            (route) => false,
          );
        }
    },);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: Center(child: SvgPicture.asset(AssetsUtils.appLogo, width: 100, fit: BoxFit.scaleDown,),),
      ),
    );
  }
}
