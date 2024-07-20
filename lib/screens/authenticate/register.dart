import 'package:flutter/material.dart';
import 'package:flutter_application_2/services/auth.dart';
import 'package:flutter_application_2/shared/constants.dart';
import 'package:flutter_application_2/shared/loading.dart';
import 'package:flutter_application_2/screens/authenticate/sign_in.dart';

class Register extends StatefulWidget {
  final Function? toggleView;
  const Register({super.key, this.toggleView});

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
                horizontal: 50.0, // Match the horizontal padding from SignIn screen
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
                                child: SizedBox(
                                  width: double.infinity, // Match width to SignIn
                                  child: TextFormField(
                                    decoration: textInputDecoration.copyWith(hintText: 'Email'),
                                    style: const TextStyle(
                                      fontFamily: 'Cyberpunk',
                                      color: Colors.cyanAccent),
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
                                child: SizedBox(
                                  width: double.infinity, // Match width to SignIn
                                  child: TextFormField(
                                    decoration: textInputDecoration.copyWith(hintText: 'Password'),
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
                              TextButton.icon(
                                icon: const Icon(Icons.person, color: Colors.cyanAccent),
                                label: const Text(
                                  'Sign In',
                                  style: TextStyle(
                                    color: Colors.cyanAccent,
                                    fontFamily: 'Cyberpunk',
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation, secondaryAnimation) => const SignIn(),
                                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                        var beginScale = 1.5;
                                        var endScale = 1.0;
                                        var beginFade = 0.0;
                                        var endFade = 1.0;
                                        var curve = Curves.easeInOut;

                                        var scaleTween = Tween(begin: beginScale, end: endScale).chain(CurveTween(curve: curve));
                                        var fadeTween = Tween(begin: beginFade, end: endFade).chain(CurveTween(curve: curve));

                                        return ScaleTransition(
                                          scale: animation.drive(scaleTween),
                                          child: FadeTransition(
                                            opacity: animation.drive(fadeTween),
                                            child: child,
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
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
