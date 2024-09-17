import 'package:get/get.dart';
import 'package:trichy_iccc_grievance/Model/customer.dart';
import 'package:trichy_iccc_grievance/User%20preferences/user_prefernces.dart';

class CustomerCurrentUser  extends GetxController {
  
final Rx<CustomerModel> customerUser = CustomerModel(publicUserId: '', publicUserName: '', email: '', phone: '',address: '',pincode: '',).obs;

  CustomerModel get customer => customerUser.value;
  
   @override
  void onInit() {
    super.onInit();
    getUserInfo();
  }

  Future<void> getUserInfo() async
  {
    CustomerModel? getUserInfoFromLocalStorage = await RememberUserPrefs.readUser();
     if (getUserInfoFromLocalStorage != null) {
      customerUser.value = getUserInfoFromLocalStorage;
    }
  }
}
