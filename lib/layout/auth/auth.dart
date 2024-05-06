import 'package:flutter/material.dart';

import 'uae_pass.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: SizedBox(
          height: 200,
          width: 220,
          child: UAEPass()),)
    );
  }
}
