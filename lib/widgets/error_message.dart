import 'package:flutter/material.dart';

/// Mostra un missatge d'error
class ErrorMessage extends StatelessWidget {
  final String message;
  final Widget? child;

  const ErrorMessage({super.key, required this.message, this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 18,
              ),
            ),
            if (child != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: child!,
              ),
          ],
        ),
      ),
    );
  }
}
