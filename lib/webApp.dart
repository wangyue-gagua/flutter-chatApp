import 'package:flutter/material.dart';

void main() => runApp(SignUpApp());

class SignUpApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/": (context) => SignUpScreen(),
        "/welcome": (context) => WelcomeScreen(),
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

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Welcome',
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
    );
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}):super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _firstNameTextController = TextEditingController();
  final _lastNameTextController = TextEditingController();
  final _userNameTextController = TextEditingController();

  double _formProgress = 0;
  final _formKey = GlobalKey<FormState>();

  void _showWelcomeScreen() {
    Navigator.of(context).pushNamed("/welcome");
  }

  void _updateFormProgress() {
    double progress = 0.0;
    final controllers = [
      _firstNameTextController,
      _lastNameTextController,
      _userNameTextController,
    ];

    for (final controller in controllers) {
      if (controller.value.text.isNotEmpty) {
        progress += 1 / controllers.length;
      }
    }

    setState(() {
      _formProgress = progress;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
        onChanged: _updateFormProgress,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedProgressIndicator(value: _formProgress),
            Text(
              'Sign up',
              style: Theme.of(context).textTheme.headline4,
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _firstNameTextController,
                decoration: InputDecoration(hintText: 'First name'),
                validator: (value) {
                  if (value != 'hh') {
                    return 'Please enter hh';
                  }
                  return null;
                },
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
                onPressed:  _formProgress == 1 ? _formKey.currentState!.validate()?  _showWelcomeScreen : null : null,
                child: Text('Sign up'),
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.resolveWith((states) =>
                      states.contains(MaterialState.disabled)
                          ? null
                          : Colors.white),
                  backgroundColor: MaterialStateProperty.resolveWith((states) =>
                      states.contains(MaterialState.disabled)
                          ? null
                          : Colors.blue),
                ))
          ],
        ));
  }
}

class AnimatedProgressIndicator extends StatefulWidget {
  final double value;

  AnimatedProgressIndicator({
    required this.value,
  });

  @override
  State<StatefulWidget> createState() {
    return _AnimatedProgressIndicatorState();
  }
}

class _AnimatedProgressIndicatorState
    extends State<AnimatedProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _curveAnimation;

  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1200));

    final colorTween = TweenSequence([
      TweenSequenceItem(tween: ColorTween(begin: Colors.red ,end: Colors.orange), weight: 1),
      TweenSequenceItem(tween: ColorTween(begin: Colors.orange, end: Colors.yellow), weight: 1),
      TweenSequenceItem(tween: ColorTween(begin: Colors.yellow, end: Colors.green), weight: 1),
      
    ]);
    
    _colorAnimation = _controller.drive(colorTween);
    _curveAnimation = _controller.drive(CurveTween(curve: Curves.easeIn));
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.animateTo(widget.value);
  }

  @override
  Widget build(BuildContext context) {

    return AnimatedBuilder(animation: _controller, builder: (context, child) => LinearProgressIndicator(
      value: _curveAnimation.value,
      valueColor: _colorAnimation,
      backgroundColor: _colorAnimation.value?.withOpacity(0.4),
    ));
  }
}
