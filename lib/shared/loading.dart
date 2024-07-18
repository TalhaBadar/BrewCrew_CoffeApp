import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(146, 33, 133, 0.831),
      body: Center(
        child: LoadingAnimationWidget.halfTriangleDot(
          color: Colors.cyanAccent,
          size: 50,
        ),
      ),
    );
  }
}
