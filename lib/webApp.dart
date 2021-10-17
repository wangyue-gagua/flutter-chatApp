import 'package:flutter/material.dart';

void main() => runApp(SignUpApp());

class SignUpApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/": (context) => SignUpScreen(),
      },
    );
  }
}

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 400,
          child: Card(
            child: SignUpForm(),
          ),
        ),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _firstNameTextController = TextEditingController();
  final _lastNameTextController = TextEditingController();
  final _userNameTextController = TextEditingController();

  double _formProgress = 0;

  @override
  Widget build(BuildContext context) {
    return Form(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        LinearProgressIndicator(
          value: _formProgress,
        ),
        Text(
          'Sign up',
          style: Theme.of(context).textTheme.headline4,
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: TextFormField(
            controller: _firstNameTextController,
            decoration: InputDecoration(hintText: 'First name'),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: TextFormField(
            controller: _lastNameTextController,
            decoration: InputDecoration(hintText: 'Last name'),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: TextFormField(
            controller: _userNameTextController,
            decoration: InputDecoration(hintText: 'User name'),
          ),
        ),
        TextButton(
            onPressed: null,
            child: Text('Sign up'),
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.resolveWith((states) =>
                  states.contains(MaterialState.disabled)
                      ? null
                      : Colors.white),
              backgroundColor: MaterialStateProperty.resolveWith((states) =>
                  states.contains(MaterialState.disabled) ? null : Colors.blue),
            )
        )
      ],
    ));
  }
}