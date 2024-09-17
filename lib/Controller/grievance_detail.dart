// ignore_for_file: avoid_print

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trichy_iccc_grievance/Model/auth/api_url.dart';
import 'package:trichy_iccc_grievance/Model/customer.dart';
import 'dart:convert';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:trichy_iccc_grievance/User%20preferences/customer_current.dart';
import 'package:trichy_iccc_grievance/User%20preferences/user_prefernces.dart';

class User extends GetxController {
 
  var isLoading = true.obs;
 final CustomerCurrentUser _customerController =
      Get.put(CustomerCurrentUser());
  @override
  void onInit() {
    fetchUserData();
    super.onInit();
  }
  Future<void> fetchUserData() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('authToken');
  final customer = _customerController.customer;
  try {
    final response = await http.get(
      Uri.parse(ApiUrl.getuserdat(customer.publicUserId!)),
      headers: {'Authorization': 'Bearer $token'},
    );

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
  
}
