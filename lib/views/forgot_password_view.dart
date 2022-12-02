import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:von_note/constants/routes.dart';
import 'package:von_note/services/auth/bloc/auth_bloc.dart';
import 'package:von_note/services/auth/bloc/auth_event.dart';
import 'package:von_note/services/auth/bloc/auth_state.dart';
import 'package:von_note/utilities/dialogs/error_dialog.dart';
import 'package:von_note/views/forgot_password_confirmation_view.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  late final TextEditingController _controller;
  bool _emailOrPasswordIsEmpty = true;

  void _textControllerListener() {
    if (_controller.text.isNotEmpty) {
      _emailOrPasswordIsEmpty = false;
      setState(() {});
    } else {
      _emailOrPasswordIsEmpty = true;
      setState(() {});
    }
  }

  void _setupTextControllerListener() {
    _controller.removeListener(_textControllerListener);
    _controller.addListener(_textControllerListener);
  }

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _setupTextControllerListener();
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateForgotPassword) {
          if (state.hasSentEmail) {
            Navigator.of(context).pushNamed(forgotPasswordConfirmationView,
                arguments: {'email': _controller.text});
          }
          if (state.exception != null) {
            if (!mounted) return;
            await showErrorDialog(
              context,
              'We could not process your request. Please make sure that you are a registered user',
              'Error',
            );
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            "Forgot Password",
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding:
                const EdgeInsets.only(top: 25, left: 20, right: 20, bottom: 20),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: const Color.fromARGB(209, 228, 240, 246),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset('assets/images/info.svg'),
                        const SizedBox(width: 10),
                        const Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Expanded(
                            child: Text(
                              "Enter your email to change your password",
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  height: 52,
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    autofocus: true,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      labelText: "Your email address...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    obscureText: false,
                    maxLines: 1,
                    controller: _controller,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 25),
                  child: Material(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    elevation: 2.0,
                    color: Theme.of(context).primaryColor,
                    clipBehavior: Clip.antiAlias,
                    child: MaterialButton(
                      minWidth: 200,
                      height: 48,
                      color: _emailOrPasswordIsEmpty
                          ? Colors.grey
                          : Theme.of(context).primaryColor,
                      onPressed: _emailOrPasswordIsEmpty
                          ? () {}
                          : () async {
                              final email = _controller.text;
                              context
                                  .read<AuthBloc>()
                                  .add(AuthEventForgotPassword(email: email));
                            },
                      child: const Text(
                        "Send Reset Password Link",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
