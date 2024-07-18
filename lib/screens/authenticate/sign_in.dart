import 'package:flutter/material.dart';
import 'package:flutter_application_2/services/auth.dart';
import 'package:flutter_application_2/shared/constants.dart';
import 'package:flutter_application_2/shared/loading.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  const SignIn({super.key, required this.toggleView});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> with SingleTickerProviderStateMixin {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  String error = '';

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading(): Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/cyberpunk_background1.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Sign in to Brew Crew',
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
                          child: TextFormField(
                            decoration: textInputDecoartion.copyWith(hintText: 'Email'),
                            style: const TextStyle(
                              fontFamily: 'Cyberpunk',
                              color: Colors.cyanAccent),
                            validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                            onChanged: (val) {
                              setState(() => email = val.trim());
                            },
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        FadeTransition(
                          opacity: _animation,
                          child: TextFormField(
                            decoration: textInputDecoartion.copyWith(hintText: 'Password'),
                            style: const TextStyle(
                              fontFamily: 'Cyberpunk',
                              color: Colors.cyanAccent),
                            obscureText: true,
                            validator: (val) =>
                                val!.length < 6 ? 'Enter a password 6+ chars long' : null,
                            onChanged: (val) {
                              setState(() => password = val);
                            },
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, backgroundColor: Colors.pink[400],
                            shadowColor: Colors.purpleAccent,
                            elevation: 10,
                          ),
                          child: const Text(
                            'Sign in',
                            style: TextStyle(color: Colors.white, fontFamily: 'Cyberpunk'),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() => loading = true);
                              dynamic result = await _auth.signInWithEmailAndPassword(
                                  email, password);
                              if (result == null) {
                                setState(() {
                                  error = 'Could not sign in with those credentials';
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
                            widget.toggleView();
                          },
                          child: const Text(
                            'Don\'t have an account? Register here',
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
          );
  }
}
