import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:von_note/constants/routes.dart';
import 'package:von_note/services/auth/auth_service.dart';
import 'package:von_note/utilities/themes/custom_theme.dart';
import 'package:von_note/utilities/themes/themes.dart';
import 'package:von_note/views/login_view.dart';
import 'package:von_note/views/notes/new_notes_view.dart';
import 'package:von_note/views/notes/notes_view.dart';
import 'package:von_note/views/register_view.dart';
import 'package:von_note/views/verify_email_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
      const CustomTheme(initialThemeKey: ThemeKeys.light, child: HomePage()));
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Von Note',
      theme: CustomTheme.of(context),
      routes: {
        noteRoute: (context) => const NotesView(),
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        newNoteRoute: (context) => const NewNoteView(),
      },
      home: FutureBuilder(
        future: AuthService.firebase().initialize(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              {
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  final user = AuthService.firebase().currentUser;
                  Timer(const Duration(seconds: 2), () {
                    if (user != null) {
                      if (!user.isEmailVerified) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            verifyEmailRoute, (route) => false);
                      } else {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            noteRoute, (route) => false);
                      }
                    } else {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          loginRoute, (route) => false);
                    }
                  });
                });
                return splash(context);
              }
            default:
              return splash(context);
          }
        },
      ),
    );
  }

  splash(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 25, 30, 70),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: MediaQuery.of(context).size.width * 0.4,
              height: MediaQuery.of(context).size.height * 0.4,
            ),
            const SizedBox(
              width: 50,
              child: LinearProgressIndicator(
                color: Colors.blue,
              ),
            )
          ],
        ),
      ),
    );
  }
}
