import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../container/view/container_page.dart';
import '../bloc/login_bloc.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.formzStatus == FormzStatus.submissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.message!)));
        } else if (state.formzStatus == FormzStatus.submissionSuccess) {
          Navigator.of(context).pushReplacementNamed(ContainerPage.route);
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(flex: 1, child: _UsernameInput()),
            const SizedBox(height: 12),
            Flexible(flex: 1, child: _PasswordInput()),
            const SizedBox(height: 12),
            _LoginButton(),
          ],
        ),
      ),

      /* Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height ,
            // color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
            child: Opacity(
              opacity: 1,
              child: Image.asset(Images.loginBg,
                  fit: BoxFit.cover, width: MediaQuery.of(context).size.width),
            ),
          ),
          Align(
            alignment: const Alignment(0, -1 / 4),
            child: SizedBox(
              width: 500,
              height: 400,
              child: Card(
                elevation: 15,
                child: Padding(
                  padding: const EdgeInsets.all(50),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _UsernameInput(),
                      const Padding(padding: EdgeInsets.all(12)),
                      _PasswordInput(),
                      const Padding(padding: EdgeInsets.all(12)),
                      _LoginButton(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),*/
    );
  }
}

class _UsernameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.userName != current.userName,
      builder: (context, state) {
        return TextField(
          onChanged: (String value) {
            context.read<LoginBloc>().add(LoginUserNameChanged(value));
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            labelText: "نام کاربری",
            errorText: state.userName.invalid ? "نام کاربری صحیح نیست" : null,
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          onChanged: (String value) {
            context.read<LoginBloc>().add(LoginPasswordChanged(value));
          },
          obscureText: true,
          decoration: InputDecoration(
            labelText: "رمز عبور",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            errorText: state.password.invalid ? "رمز عبور صحیح نیست" : null,
          ),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
        buildWhen: (previous, current) =>
            previous.formzStatus != current.formzStatus,
        builder: (context, state) {
          if (state.formzStatus == FormzStatus.submissionInProgress) {
            return const CircularProgressIndicator();
          } else {
            return ElevatedButton(
                onPressed: state.formzStatus.isValidated
                    ? () {
                        context.read<LoginBloc>().add(const LoginSubmitted());
                      }
                    : null,
                child: const Text("ورود"));
          }
        });
  }
}

// TODO: Add Shared Z-Axis transition from search icon to search view page (Motion)
class SharedAxisTransitionPageWrapper extends Page {
  const SharedAxisTransitionPageWrapper(
      {required this.screen, required this.transitionKey})
      : super(key: transitionKey);

  final Widget screen;
  final ValueKey transitionKey;

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
        settings: this,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SharedAxisTransition(
            fillColor: Theme.of(context).cardColor,
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.scaled,
            child: child,
          );
        },
        pageBuilder: (context, animation, secondaryAnimation) {
          return screen;
        });
  }
}
