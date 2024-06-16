import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app/controller/login_controller.dart';
import 'package:food_app/pages/login_page.dart';
import 'package:food_app/widgets/otp_textfield.dart';
import 'package:get/get.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);  // Corrected constructor

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      init: LoginController(),  // Initialize your controller
      builder: (ctrl) {
        return Scaffold(
          body: Container(
            width: double.maxFinite,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blueGrey[50],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Create Your Account!!!',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 20,),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: ctrl.registerNameCtrl,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.person),
                    labelText: 'Your Name',
                    hintText: 'Enter your name',
                  ),
                ),
                const SizedBox(height: 20,),
                TextField(
                  keyboardType: TextInputType.phone,
                  controller: ctrl.registerNumberCtrl,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.phone_android),
                    labelText: 'Mobile Number',
                    hintText: 'Enter your mobile number',
                  ),
                ),
                const SizedBox(height: 20,),
                OtpTextfield(
                  otpController: ctrl.otpController,
                  visible: ctrl.otpFieldShow,
                  onComplete: (otp) {
                    if (otp != null) {
                      ctrl.otpEnter = int.tryParse(otp);
                    }
                  },
                ),
                const SizedBox(height: 20,),
                ElevatedButton(
                  onPressed: () {
                    if (ctrl.otpFieldShow) {
                      ctrl.addUser();
                    } else {
                      ctrl.sentOTp();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.deepPurple,
                  ),
                  child: Text(ctrl.otpFieldShow ? 'Register' : 'Send OTP',style: const TextStyle(
                      fontSize: 23
                  ),),
                ),
                const SizedBox(height: 3,),
                TextButton(
                  onPressed: () {
                    Get.to(const LoginPage());
                  },
                  child: const Text('Login',style: const TextStyle(
                      fontSize: 20
                  ),),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
