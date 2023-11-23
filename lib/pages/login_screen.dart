import 'package:ecom_user/auth/auth_service.dart';
import 'package:ecom_user/pages/launcher_screen.dart';
import 'package:ecom_user/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  bool isObscure = true;
  String errMsg = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formkey,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:40.0, vertical: 4),
                child: TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    prefixIcon: const Icon(Icons.email),
                  ),
                  validator: (value) {
                    if(value == null || value.isEmpty) {
                      return 'This field must not be empty';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:40.0, vertical: 4),
                child: TextFormField(
                  obscureText: isObscure,
                  controller: _passController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isObscure = !isObscure;
                        });
                      },
                      icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility),
                    )
                  ),
                  validator: (value) {
                    if(value == null || value.isEmpty) {
                      return 'This field must not be empty';
                    }
                    return null;
                  },
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    _authenticate(true);
                  },
                  child: const Text('LOGIN'),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('New User?'),
                  TextButton(
                      onPressed: () {
                        _authenticate(false);
                      },
                      child: const Text('Register here'),
                  )
                ],
              ),
              const Center(
                child: Text('OR'),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('SING IN WITH GOOGLE'),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(errMsg, style: const TextStyle(fontSize: 16, color: Colors.red,),),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _authenticate(bool isLogin) async {
    if(_formkey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passController.text;
      EasyLoading.show(status: 'Please Wait');
      User user;
      try {
        if(isLogin) {
        user =  await AuthService.loginUser(email, password);
        } else {
         user = await AuthService.registerUser(email, password);
         await Provider.of<UserProvider>(context, listen: false)
         .addNewUser(user);
        }
        EasyLoading.dismiss();
        Navigator.pushReplacementNamed(context, LauncherScreen.routeName);
      } on FirebaseAuthException catch(error) {
        EasyLoading.dismiss();
        setState(() {
          errMsg = error.message!;
        });
      }
    }
  }
}
