import 'package:flutter/material.dart';
import 'package:flutter_application_2/services/auth.dart';
import 'package:flutter_application_2/shared/constants.dart';
import 'package:flutter_application_2/shared/loading.dart';


class Register extends StatefulWidget {
  final Function? toggleView;
  const Register({this.toggleView});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> with SingleTickerProviderStateMixin {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  String error = '';

  late AnimationController _controller;
  late Animation<double> _animation;
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _emailFocusNode.addListener(() {
      if (_emailFocusNode.hasFocus) {
        _controller.stop();
      } else if (!_passwordFocusNode.hasFocus) {
        _controller.repeat(reverse: true);
      }
    });

    _passwordFocusNode.addListener(() {
      if (_passwordFocusNode.hasFocus) {
        _controller.stop();
      } else if (!_emailFocusNode.hasFocus) {
        _controller.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    return loading
        ? const Loading()
        : Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/coffebeansss.png'),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.symmetric(
          vertical: mediaQuery.orientation == Orientation.portrait ? 20.0 : 10.0,
          horizontal: 50.0,
        ),
        child: SingleChildScrollView(
          child: Align(
            alignment: Alignment.center,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: screenWidth,
                maxHeight: screenHeight,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'REGISTER WITH US',
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.cyanAccent,
                      fontFamily: 'Cyberpunk',
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        FadeTransition(
                          opacity: _animation,
                          child: Container(
                            width: double.infinity,
                            child: TextFormField(
                              focusNode: _emailFocusNode,
                              decoration: textInputDecoration.copyWith(hintText: 'Email'),
                              style: const TextStyle(
                                fontFamily: 'Cyberpunk',
                                color: Colors.cyanAccent,
                              ),
                              validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                              onChanged: (val) {
                                setState(() => email = val.trim());
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        FadeTransition(
                          opacity: _animation,
                          child: Container(
                            width: double.infinity,
                            child: TextFormField(
                              focusNode: _passwordFocusNode,
                              decoration: textInputDecoration.copyWith(hintText: 'Password'),
                              style: const TextStyle(
                                fontFamily: 'Cyberpunk',
                                color: Colors.cyanAccent,
                              ),
                              obscureText: true,
                              validator: (val) => val!.length < 6
                                  ? 'Enter a password 6+ chars long'
                                  : null,
                              onChanged: (val) {
                                setState(() => password = val);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.pink[400],
                            shadowColor: Colors.purpleAccent,
                            elevation: 10,
                          ),
                          child: const Text(
                            'Register',
                            style: TextStyle(color: Colors.white, fontFamily: 'Cyberpunk'),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() => loading = true);
                              dynamic result = await _auth.createUserWithEmailAndPassword(
                                  email, password);
                              if (result == null) {
                                setState(() {
                                  error = 'Please supply a valid email';
                                  loading = false;
                                });
                              }
                            }
                          },
                        ),
                        const SizedBox(height: 12.0),
                        Text(
                          error,
                          style: const TextStyle(color: Colors.red, fontSize: 14.0),
                        ),
                        const SizedBox(height: 20.0),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Sign In',
                            style: TextStyle(
                              color: Colors.cyanAccent,
                              fontFamily: 'Cyberpunk',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
