import 'package:flutter/material.dart';
import 'package:trichy_iccc_grievance/Utils/Constant/app_pages_names.dart';
import 'package:trichy_iccc_grievance/View/Screens/Authentication/change_password.dart';
import 'package:trichy_iccc_grievance/View/Screens/Authentication/forget_password.dart';
import 'package:trichy_iccc_grievance/View/Screens/Authentication/login_screen.dart';
import 'package:trichy_iccc_grievance/View/Screens/Authentication/signup_screen.dart';
import 'package:trichy_iccc_grievance/View/Screens/edit_screen.dart';
import 'package:trichy_iccc_grievance/View/Screens/faq_screen.dart';
import 'package:trichy_iccc_grievance/View/Screens/home_screen.dart';
import 'package:trichy_iccc_grievance/View/Screens/language_screen.dart';
import 'package:trichy_iccc_grievance/View/Screens/profile_screen.dart';
import 'package:trichy_iccc_grievance/View/Screens/splash_screen.dart';

class AppRouteGenerator{

static Route<dynamic> generateRoute(RouteSettings settings){

switch(settings.name)
{
  case AppPageNames.rootScreen:
   case AppPageNames.screen1:
    return pageRoute(const StartingScreen()); 
  case AppPageNames.loginScreen:
    return pageRoute(const LoginScreen()); 
  case AppPageNames.signupScreen:
    return pageRoute(const SignupScreen()); 
  case AppPageNames.homeScreen:
    return pageRoute(const HomeScreen());
  case AppPageNames.profileScreen:
    return pageRoute(const ProfileScreen());
  case AppPageNames.faqScreen:
    return pageRoute(const FaqScreen());
  case AppPageNames.languageScreen:
    return pageRoute(const LanguageScreen());
  case AppPageNames.changePassword:
    return pageRoute(const ChangePassword());
  case AppPageNames.editScreen:
    return pageRoute(const EditScreen());
  case AppPageNames.forgetPassword:
    return pageRoute(const ForgetPassword());  
  
  
  



   default:
        // Open this page if wrong route address used
        return MaterialPageRoute(
            builder: (_) => const Scaffold(
                body: SafeArea(child: Center(child: Text('Page not found')))));

}
}
}

PageRoute pageRoute(Widget page) {
  return PageRouteBuilder(
   // transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (context, animation, secondaryAnimation) =>  page,
     transitionsBuilder: (context, animation, secondaryAnimation, child) {
       return FadeTransition(opacity: animation,child: child,);
    },
  );
} 
