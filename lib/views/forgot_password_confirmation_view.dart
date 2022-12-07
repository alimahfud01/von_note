import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:von_note/extensions/buildcontext/loc.dart';

import '../services/auth/bloc/auth_bloc.dart';
import '../services/auth/bloc/auth_event.dart';
import '../services/timer/bloc/timer_bloc.dart';
import '../services/timer/ticker.dart';

class ForgotPasswordConfirmationView extends StatelessWidget {
  const ForgotPasswordConfirmationView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => TimerBloc(ticker: const Ticker()),
        child: const Content());
  }
}

class Content extends StatelessWidget {
  const Content({super.key});

  @override
  Widget build(BuildContext context) {
    final args = (ModalRoute.of(context)?.settings.arguments) as Map;
    final duration = context.select((TimerBloc bloc) => bloc.state.duration);
    final minutesStr =
        ((duration / 60) % 60).floor().toString().padLeft(2, '0');
    final secondsStr = (duration % 60).toString().padLeft(2, '0');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(context.loc.email_sent),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin:
              const EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 20),
          child: Column(
            children: [
              Image.asset('assets/images/mailsent.png'),
              const SizedBox(height: 30),
              Text(
                context.loc.link_has_been_sent,
              ),
              const SizedBox(height: 10),
              Expanded(
                flex: 0,
                child: Text(
                  context.loc.we_have_sent_link + args['email'],
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 25),
              Container(
                height: 1,
                width: MediaQuery.of(context).size.width * 0.95,
                color: Colors.grey,
              ),
              const SizedBox(height: 25),
              Expanded(
                flex: 0,
                child: BlocBuilder<TimerBloc, TimerState>(
                  builder: (context, state) {
                    context
                        .read<TimerBloc>()
                        .add(TimerStarted(duration: state.duration));
                    return (secondsStr != "00")
                        ? Text(
                            "${context.loc.havent_received} ${context.loc.resend_in} $minutesStr:$secondsStr ${context.loc.second}",
                            textAlign: TextAlign.center,
                          )
                        : RichText(
                            text: TextSpan(
                              text: context.loc.havent_received,
                              children: <TextSpan>[
                                TextSpan(
                                  text: context.loc.resend,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      context
                                          .read<TimerBloc>()
                                          .add(const TimerReset());
                                      context.read<AuthBloc>().add(
                                          AuthEventForgotPassword(
                                              email: args['email']));
                                      Navigator.of(context).pop();
                                    },
                                ),
                                TextSpan(
                                  text: context.loc.or,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                ),
                                TextSpan(
                                  text: context.loc.change_email,
                                  style: TextStyle(
                                      color: Theme.of(context).primaryColor),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.of(context).pop();
                                    },
                                ),
                              ],
                            ),
                          );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
