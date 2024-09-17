// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trichy_iccc_grievance/Model/auth/api_url.dart';
import 'package:trichy_iccc_grievance/Model/customer.dart';
import 'package:trichy_iccc_grievance/User%20preferences/user_prefernces.dart';
import 'package:trichy_iccc_grievance/Utils/Constant/app_pages_names.dart';
import 'package:trichy_iccc_grievance/View/widgets/buttons.dart';
import 'package:trichy_iccc_grievance/color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailPhoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool isPasswordVisible = false;
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

Future userLogin(BuildContext context) async {
  var body = {
    'identifier': _emailPhoneController.text,
    'login_password': _passwordController.text,
  };

  var response = await http.post(
    Uri.parse(ApiUrl.loginweb),
    body: jsonEncode(body),
    headers: {"Content-Type": "application/json"},
  );

  if (response.statusCode == 200) {
    var json = jsonDecode(response.body);
    debugPrint('User login successful: $json');

    // Decode the token to extract the user ID
    String token = json['token'];
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    print('token decode: $decodedToken');
    String userId = decodedToken['code'];

    // Store the token in SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', token);
    await prefs.setString('userId', userId);  
    // Display success message
    Fluttertoast.showToast(
      msg: AppLocalizations.of(context)!.loginsucc,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    // await RememberUserPrefs.removeUserInfo();
     await fetchUserData(userId);
     print("User id new : $userId");
                       Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppPageNames.homeScreen,
                      (route) => false,
                    );
     _emailPhoneController.clear();
     _passwordController.clear();
    
    

  } else {
    var json = jsonDecode(response.body);
    debugPrint('Login failed: ${response.statusCode} - ${json['message']}');

    // Display failure message
    Fluttertoast.showToast(
      msg: json['message'] ?? AppLocalizations.of(context)!.loginfail,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}


Future<void> fetchUserData(String userId) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('authToken');
  
  try {
    final response = await http.get(
      Uri.parse(ApiUrl.getuserdat(userId)),
      headers: {'Authorization': 'Bearer $token'},
    );
     print(response);
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
       
      // Decryption key and IV
      final key = encrypt.Key.fromBase16('9b7bdbd41c5e1d7a1403461ba429f2073483ab82843fe8ed32dfa904e830d8c9');
      final iv = encrypt.IV.fromBase16('33224fa12720971572d1a5677cede948');

      final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'));

      try {
        // Decrypt the encrypted data
        final encryptedData = encrypt.Encrypted.fromBase16(json['data']);
        final decryptedData = encrypter.decrypt(encryptedData, iv: iv);
         print('Decrypted Data : $decryptedData');
        // Convert the decrypted data to JSON
        var jsonData = jsonDecode(decryptedData);
        CustomerModel customerInfo = CustomerModel.fromJson(jsonData);
        await RememberUserPrefs.saveRememberUser(customerInfo);
      } catch (e) {
        print('Decryption or JSON parsing failed: $e');
      }

    } else {
      print('Failed to fetch user data: ${response.statusCode}');
    }
  } catch (e) {
    print('HTTP request failed: $e');
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: false ,
      body: SafeArea(
        child: Form(
          key:_formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppPageNames.screen1);
                      },
                      style: IconButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 215, 229, 241),
                        padding: const EdgeInsets.all(8),
                      ),
                      icon: const Icon(Icons.arrow_back_ios),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Text(
                      AppLocalizations.of(context)!.login,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _emailPhoneController,
                      style: const TextStyle(color: Colors.black),
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.emailphonenumber,
                        hintStyle: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(0, 0, 0, 0.1),
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(0, 0, 0, 0.1),
                            width: 2.0,
                          ),
                        ),
                      ),
                        validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        final emailRegex = RegExp(
                            r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$');
                        if (!emailRegex.hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !isPasswordVisible,
                      style: const TextStyle(color: Colors.black),
                      keyboardType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.password,
                        suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(0, 0, 0, 0.1),
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: const BorderSide(
                            color: Color.fromRGBO(0, 0, 0, 0.1),
                            width: 2.0,
                          ),
                        ),
                      ),
                          validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                     autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, AppPageNames.forgetPassword);
                          },
                          child:  Text(
                            AppLocalizations.of(context)!.forgetpassword0,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 282),
                    Center(
                      child: CustomFillButton(
                        buttontext:  AppLocalizations.of(context)!.login,
                        buttoncolor: maincolor,
                        onPressed: (){
                               if (_formKey.currentState!.validate()) {
                            userLogin(context);
                              }
                        },
                        minimumSize: const Size(301, 54),
                        buttontextsize: 20,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                       Text(
                          AppLocalizations.of(context)!.didntacc,
                          style: const TextStyle(fontSize: 14, color: Colors.black),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, AppPageNames.signupScreen);
                          },
                          child:  Text(
                            AppLocalizations.of(context)!.signup,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
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
    );
  }
}
