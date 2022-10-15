import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/routes.dart';
import '../services/auth/auth_exception.dart';
import '../services/auth/auth_service.dart';
import '../utilities/snackbars/only_text_snackbar.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  bool _indicatorVisibility = false;
  bool _obsText = true;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Login")),
        body: Center(
          child: Stack(children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    SvgPicture.asset(
                      'assets/images/login_vector.svg',
                      height: MediaQuery.of(context).size.height * 0.3,
                    ),
                    const SizedBox(height: 60),
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _email,
                      decoration: InputDecoration(
                        hintText: "Email",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: TextField(
                        controller: _password,
                        obscureText: _obsText,
                        enableSuggestions: false,
                        autocorrect: false,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          hintText: "Password",
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obsText = !_obsText;
                                });
                              },
                              icon: Icon(_obsText
                                  ? Icons.visibility
                                  : Icons.visibility_off)),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {},
                        child: Text(
                          "Forgot password",
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: Material(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        elevation: 2.0,
                        color: Theme.of(context).primaryColor,
                        clipBehavior: Clip.antiAlias,
                        child: MaterialButton(
                          minWidth: 200,
                          height: 48,
                          color: Theme.of(context).primaryColor,
                          child: const Text(
                            "Login",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            _indicatorVisibility = !_indicatorVisibility;
                            setState(() {});
                            final email = _email.text;
                            final password = _password.text;
                            try {
                              await AuthService.firebase().logIn(
                                email: email,
                                password: password,
                              );
                              if (!mounted) return;
                              _indicatorVisibility = !_indicatorVisibility;
                              setState(() {});
                              onlyTextSnackbar(context, "Login Successful");
                              final user = AuthService.firebase().currentUser;
                              if (user?.isEmailVerified ?? false) {
                                await AuthService.firebase()
                                    .sendEmailVerification();
                                if (!mounted) return;
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    noteRoute, (route) => false);
                              } else {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    verifyEmailRoute, (route) => false);
                              }
                            } on UserNotFoundAuthException {
                              _indicatorVisibility = !_indicatorVisibility;
                              setState(() {});
                              onlyTextSnackbar(context, "User Not Found");
                            } on WrongPasswordAuthException {
                              _indicatorVisibility = !_indicatorVisibility;
                              setState(() {});
                              onlyTextSnackbar(context, "Wrong Password");
                            } on GenericAuthException {
                              _indicatorVisibility = !_indicatorVisibility;
                              setState(() {});
                              onlyTextSnackbar(context, "Authentication Error");
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(registerRoute);
                          },
                          child: Text(
                            "Register here!",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: _indicatorVisibility,
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Theme.of(context).highlightColor,
                child: const Center(child: CircularProgressIndicator()),
              ),
            ),
          ]),
        ));
  }
}
