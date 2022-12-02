import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:von_note/constants/routes.dart';
import 'package:von_note/helpers/loading/loading_screen.dart';
import 'package:von_note/services/auth/bloc/auth_bloc.dart';
import 'package:von_note/services/auth/bloc/auth_event.dart';
import 'package:von_note/services/auth/bloc/auth_state.dart';
import 'package:von_note/services/auth/firebase_auth_provider.dart';
import 'package:von_note/utilities/themes/custom_theme.dart';
import 'package:von_note/utilities/themes/themes.dart';
import 'package:von_note/views/forgot_password_confirmation_view.dart';
import 'package:von_note/views/forgot_password_view.dart';
import 'package:von_note/views/login_view.dart';
import 'package:von_note/views/notes/create_update_note_view.dart';
import 'package:von_note/views/notes/notes_view.dart';
import 'package:von_note/views/register_view.dart';
import 'package:von_note/views/splash_view.dart';
import 'package:von_note/views/verify_email_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const CustomTheme(
      initialThemeKey: ThemeKeys.light,
      child: HomePage(),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authBloc = AuthBloc(FirebaseAuthProvider());
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Von Note',
      theme: CustomTheme.of(context),
      routes: {
        createUpdateNoteView: (context) => const CreateUpdateNoteView(),
        forgotPasswordView: (context) => BlocProvider.value(
              value: authBloc,
              child: const ForgotPasswordView(),
            ),
        forgotPasswordConfirmationView: (context) => BlocProvider.value(
              value: authBloc,
              child: const ForgotPasswordConfirmationView(),
            ),
        registerView: (context) => BlocProvider.value(
              value: authBloc,
              child: const RegisterView(),
            )
      },
      home: BlocProvider<AuthBloc>(
          create: (context) => authBloc, child: const Content()),
    );
  }
}

class Content extends StatelessWidget {
  const Content({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
            context: context,
            text: state.loadingText ?? 'Please wait a moment',
          );
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const NotesView();
        } else if (state is AuthStateNeedVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else {
          return Scaffold(
            body: LinearProgressIndicator(
              backgroundColor: Theme.of(context).primaryColor,
            ),
          );
        }
      },
    );
  }
}
