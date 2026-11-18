// Flutter SDK compatibility: Material remains the app's supported UI layer.
// ignore: deprecated_member_use
import 'package:flutter/material.dart';

/// A consistent page wrapper for all game screens.
///
/// Provides a standard scaffold with the app theme applied and safe-area
/// handling, so every screen shares the same structural foundation.
class AppScaffold extends StatelessWidget {
  final Widget body;
  final String? title;

  const AppScaffold({super.key, required this.body, this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: title != null
          ? AppBar(title: Text(title!), centerTitle: true)
          : null,
      body: SafeArea(child: body),
    );
  }
}
