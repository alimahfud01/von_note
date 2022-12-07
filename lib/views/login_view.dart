import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:von_note/constants/routes.dart';
import 'package:von_note/extensions/buildcontext/loc.dart';
import 'package:von_note/services/auth/bloc/auth_bloc.dart';
import 'package:von_note/services/auth/bloc/auth_event.dart';
import 'package:von_note/services/auth/bloc/auth_state.dart';
import '../services/auth/auth_exception.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../utilities/snackbars/only_text_snackbar.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthStateLoggedOut) {
          if (state.exception is UserNotFoundAuthException) {
            onlyTextSnackbar(context, context.loc.login_error_cannot_find_user);
          } else if (state.exception is WrongPasswordAuthException) {
            onlyTextSnackbar(
                context, context.loc.login_error_wrong_credentials);
          } else if (state.exception is GenericAuthException) {
            onlyTextSnackbar(context, context.loc.error);
          }
        } else if (state is AuthStateLoggedIn) {
          onlyTextSnackbar(context, context.loc.login_succesfull);
        }
      },
      child: Scaffold(
          appBar: AppBar(title: Text(context.loc.login)),
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
                          hintText: context.loc.email,
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
                            hintText: context.loc.password,
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
                          onTap: () {
                            Navigator.of(context).pushNamed(forgotPasswordView);
                          },
                          child: Text(
                            context.loc.forgot_password,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
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
                            child: Text(
                              context.loc.login,
                              style: const TextStyle(color: Colors.white),
                            ),
                            onPressed: () async {
                              final email = _email.text;
                              final password = _password.text;
                              context
                                  .read<AuthBloc>()
                                  .add(AuthEventLogIn(email, password));
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(context.loc.dont_have_account),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(registerView);
                            },
                            child: Text(
                              context.loc.register_here,
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
            ]),
          )),
    );
  }
}
