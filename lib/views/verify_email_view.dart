import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:von_note/services/auth/bloc/auth_bloc.dart';
import 'package:von_note/services/auth/bloc/auth_event.dart';
import '../services/auth/auth_service.dart';
import '../utilities/snackbars/only_text_snackbar.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  final user = AuthService.firebase().currentUser!.email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify Email')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            SvgPicture.asset(
              'assets/images/verify_email_vector.svg',
              height: MediaQuery.of(context).size.height * 0.3,
            ),
            RichText(
              text: TextSpan(
                text: 'Hi ',
                style: const TextStyle(color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                    text: user,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const TextSpan(
                      text:
                          ", we've sent you email verification. Please open it to verify your email."),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
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
                child: const Text(
                  "Login here",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthEventLogOut());
                },
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                  text: "Haven't received a verification email?",
                  style: const TextStyle(
                      color: Colors.black, fontStyle: FontStyle.italic),
                  children: <TextSpan>[
                    TextSpan(
                      text: ' Resend',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          context
                              .read<AuthBloc>()
                              .add(AuthEventSendEmailVerification());
                          if (!mounted) return;
                          onlyTextSnackbar(context, "Email sent succesfully");
                        },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
