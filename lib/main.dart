import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trichy_iccc_grievance/Controller/locale_model.dart';
import 'package:trichy_iccc_grievance/Utils/Constant/app_pages_names.dart';
import 'package:trichy_iccc_grievance/Utils/app_routes.dart';
import 'package:trichy_iccc_grievance/View/Screens/home_screen.dart';
import 'package:trichy_iccc_grievance/View/Screens/splash_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitDown,DeviceOrientation.portraitUp]
  );
  Platform.isAndroid
    ? await Firebase.initializeApp(
      options: 
      const FirebaseOptions(apiKey: "AIzaSyBU1Y80OuQP_fUzSCgjjXLeQ-yhNeKUQYg", 
      appId: "1:940022936447:android:aef127ed11c8d502ab204a",
      messagingSenderId: "940022936447", 
      projectId: "tscluser-36d6e")
    )
:Firebase.initializeApp();
SharedPreferences prefs = await SharedPreferences.getInstance();
  
  runApp(ChangeNotifierProvider(
     create: (context) => LanguageProvider(),
    child:  MyApp(token: prefs.getString('authToken'),)));
}

class MyApp extends StatelessWidget {
 final String? token;
  const MyApp({super.key, required this.token});
  
  @override
  Widget build(BuildContext context) {
    final localeModel = Provider.of<LanguageProvider>(context);
    return MaterialApp(
        localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      locale: localeModel.locale,
      supportedLocales: const [
        Locale('en'),
        Locale('ta')
      ],
      onGenerateRoute: AppRouteGenerator.generateRoute,
      initialRoute: AppPageNames.rootScreen,
      debugShowCheckedModeBanner: false,
    
      home:  (token != null && !JwtDecoder.isExpired(token!))
          ? const HomeScreen()
          : const StartingScreen(),
    );
  }
}
 

