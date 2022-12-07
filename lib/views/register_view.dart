import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:von_note/extensions/buildcontext/loc.dart';
import 'package:von_note/services/auth/bloc/auth_bloc.dart';
import 'package:von_note/services/auth/bloc/auth_event.dart';
import 'package:von_note/services/auth/bloc/auth_state.dart';
import '../services/auth/auth_exception.dart';
import '../utilities/snackbars/only_text_snackbar.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            onlyTextSnackbar(context, context.loc.register_error_weak_password);
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            onlyTextSnackbar(
                context, context.loc.register_error_email_already_in_use);
          } else if (state.exception is GenericAuthException) {
            onlyTextSnackbar(context, context.loc.error);
          } else if (state.exception is InvalidEmailAuthException) {
            onlyTextSnackbar(context, context.loc.register_error_invalid_email);
          }
        }
        if (state is AuthStateNeedVerification) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(context.loc.register)),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        'assets/images/signup_vector.svg',
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
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obsText = !_obsText;
                                    });
                                  },
                                  icon: Icon(_obsText
                                      ? Icons.visibility
                                      : Icons.visibility_off))),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Material(
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
                            context.loc.register,
                            style: const TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            final email = _email.text;
                            final password = _password.text;
                            context
                                .read<AuthBloc>()
                                .add(AuthEventRegister(email, password));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
