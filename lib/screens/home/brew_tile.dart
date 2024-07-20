import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/brew.dart';
import 'package:flutter_application_2/models/myuser.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class BrewTile extends StatelessWidget {
  final Brew? brew;
  const BrewTile({super.key, this.brew});

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<MyUser?>(context);

    Color tileColor = (brew!.userId == currentUser?.uid)
        ? const Color.fromARGB(235, 188, 190, 191)
        : Colors.white;

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        color: tileColor,
        margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.brown[brew!.strength!],
            backgroundImage: const AssetImage('assets/coffee_icon.png'),
          ),
          title: Text(
            brew!.name!,
            style: const TextStyle(fontFamily: 'Cyberpunk'),
          ),
          subtitle: Text(
            'Takes ${brew!.sugars} sugar(s)',
            style: const TextStyle(fontFamily: 'Cyberpunk'),
          ),
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AnimatedDialog(
                  child: AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    title: Text(
                      brew!.name!,
                      style: const TextStyle(
                        fontFamily: 'Cyberpunk',
                        color: Colors.brown,
                      ),
                    ),
                    content: SingleChildScrollView(
                      child: Column(
                        
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                      
                          CircleAvatar(
                            radius: 40.0,
                            backgroundColor: Colors.brown[brew!.strength!],
                            backgroundImage: const AssetImage('assets/coffee_icon.png'),
                          ),
                          const SizedBox(height: 20.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const FaIcon(FontAwesomeIcons.mugSaucer, color: Colors.brown),
                              const SizedBox(width: 8.0),
                              Text(
                                'Strength: ${(brew!.strength! / 100).toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              const FaIcon(FontAwesomeIcons.cubes),
                              const SizedBox(width: 8.0),
                              Text(
                                'Sugars: ${brew!.sugars}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text(
                          'Close',
                          style: TextStyle(color: Colors.brown, fontFamily: 'Cyberpunk'),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class AnimatedDialog extends StatefulWidget {
  final Widget child;

  const AnimatedDialog({super.key, required this.child});

  @override
  _AnimatedDialogState createState() => _AnimatedDialogState();
}

class _AnimatedDialogState extends State<AnimatedDialog> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )..forward();

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: widget.child,
    );
  }
}
