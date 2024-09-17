// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trichy_iccc_grievance/Controller/grievance_detail.dart';
import 'package:trichy_iccc_grievance/Model/auth/api_url.dart';
import 'package:trichy_iccc_grievance/Model/customer.dart';
import 'package:trichy_iccc_grievance/User%20preferences/customer_current.dart';
import 'package:trichy_iccc_grievance/Utils/Constant/app_pages_names.dart';
import 'package:trichy_iccc_grievance/View/widgets/buttons.dart';
import 'package:trichy_iccc_grievance/View/widgets/textfield.dart';
import 'package:trichy_iccc_grievance/color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditScreen extends StatefulWidget {
  final Object? arugment;
  const EditScreen({super.key, this.arugment});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
   final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;

  Future<void> _editprofile(String username,String address,String pincode,) async {
      final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('authToken');
   

    final response = await http.post(
      Uri.parse(ApiUrl.editprof(customer.publicUserId!)), 
      headers: {
        'Content-Type': 'application/json',
         'Authorization': 'Bearer $token'
      },
      body: jsonEncode({
        'public_user_name': username,
        'address': address,
        'pincode': pincode,
        'verification_status':"verified",
        'user_status':true,
        'role':"user"
      }),
    );

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: "Update profile successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
      userController.fetchUserData();
       Navigator.pushNamedAndRemoveUntil(context, AppPageNames.homeScreen, (route)=>false);
      
    } else {
      Fluttertoast.showToast(
        msg: "Failed to Update Profile",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }
  final CustomerCurrentUser _customerController =  Get.put(CustomerCurrentUser());
  User userController = Get.put(User());
   CustomerModel customer = CustomerModel();

  void setChatScreenParameter(Object? argument) {
    if (argument != null && argument is CustomerModel) {
      customer = argument;
    }
  }
@override
  void initState() {
    _customerController.getUserInfo();
    setChatScreenParameter(widget.arugment);
    _usernameController.text = customer.publicUserName.toString();
    _addressController.text = customer.address.toString();
    _pincodeController.text = customer.pincode.toString();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: false ,
      body: SafeArea(
        child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(padding: const EdgeInsets.all(8),
          child: Row(children: [
            IconButton(onPressed: (){
        Navigator.pushNamed(context, AppPageNames.homeScreen);
               },style: IconButton.styleFrom(
         backgroundColor: const Color.fromARGB(255, 215, 229, 241),
         padding:  const EdgeInsets.only(left: 9)
               ), icon: const Icon(Icons.arrow_back_ios,)),
               const SizedBox(width: 10,),
        Text(AppLocalizations.of(context)!.editprofile,style: const TextStyle(fontWeight: FontWeight.w500,fontSize: 18),),
          ],),
          ),
          const SizedBox(height: 10,),
           Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                
                 CustomTextField(hinttext: customer.publicUserName??"Name",controller: _usernameController,),
                const SizedBox(height: 10,),
                 CustomTextField(hinttext: customer.address??"Address",controller: _addressController,),
                const SizedBox(height: 10,),
                  TextFormField(
                controller: _pincodeController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: InputDecoration(
                  hintText: customer.pincode ?? 'Pincode',
                   hintStyle: const TextStyle(
                                              color: Colors.black87,
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              borderSide: const BorderSide(
                                                  color:
                                                      Color.fromRGBO(0, 0, 0, 0.1),
                                                  width: 2.0)),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              borderSide: const BorderSide(
                                                  color:
                                                    Color.fromRGBO(0, 0, 0, 0.1),
                                                  width: 2.0)),
                ),
                 validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a pincode';
                    } else if (value.length != 6) {
                      return 'Pincode must be 6 digits';
                    }
                    return null; 
                  },),
                const SizedBox(height: 420,),
                
                Center(child: CustomFillButton(buttontext: AppLocalizations.of(context)!.updateprof, buttoncolor: maincolor, 
                onPressed: (){
                     if (_formKey.currentState!.validate()) {
                  _editprofile(_usernameController.text, _addressController.text, _pincodeController.text);
                     }
                }, 
                minimumSize: const Size(301, 54),
                 buttontextsize: 20)),
                
                ],
              ),
            ),
          ),
          
        ],
              )),
    );
  }
}