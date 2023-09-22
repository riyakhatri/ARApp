import 'package:cam/Views/signup_phone.dart';
import 'package:cam/Widget/divider_heading.dart';
import 'package:cam/auth/auth_controller.dart';
import 'package:cam/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  AuthController auth = Get.put(AuthController());
  var isLoading = false;
  bool _isHidden = true;
  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(children: [
              const Padding(
                padding: EdgeInsets.only(top: 100.0),
                child: Text(
                  "Let's SIGN You UP !!",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        filled: true,
                        labelText: 'Full Name',
                      ),
                      controller: auth.name,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        filled: true,
                        labelText: 'Email',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      controller: auth.email,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: auth.password,
                      obscureText: _isHidden,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        suffix: InkWell(
                          onTap: _togglePasswordView,
                          child: Icon(
                            _isHidden ? Icons.visibility : Icons.visibility_off,
                            size: 18,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        filled: true,
                        //hintStyle: TextStyle(color: Colors.grey[800]),
                        labelText: 'Password',
                        // fillColor: Colors.grey[300]
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)),
                      height: 35,
                      width: 150,
                      child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                          var log = await auth.signupUserwithEmail(
                              auth.email.text,
                              auth.password.text,
                              auth.name.text);
                          if (log != null) {
                            Get.offAll(() => const LoginScreen());
                          }
                          setState(() {
                            isLoading = false;
                          });
                        },
                        child: Builder(builder: (context) {
                          if (isLoading == true) {
                            return const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            );
                          } else {
                            return const Text(
                              "SIGN UP",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                              ),
                            );
                          }
                        }),
                      ),
                    ),
                    const DividerHeading(heading: 'OR'),
                    const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'Sign In with',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            auth.signInWithGoogle(context);
                          },
                          child: SizedBox(
                              height: 50,
                              child: Image.asset('assets/Images/google.png')),
                        ),
                        InkWell(
                          onTap: () {
                            Get.to(() => const SignUpWithPhoneNumber());
                          },
                          child: const Icon(
                            Icons.phone,
                            size: 32,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account? ",
                            style: TextStyle(fontSize: 14),
                          ),
                          InkWell(
                              onTap: () {
                                Get.offAll(() => const LoginScreen());
                              },
                              child: Text(
                                "Sign In now!!",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Get.isDarkMode
                                        ? Colors.purpleAccent
                                        : Colors.deepPurpleAccent,
                                    fontWeight: FontWeight.bold),
                              )),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ]),
          ),
        )),
      ),
    );
  }
}
