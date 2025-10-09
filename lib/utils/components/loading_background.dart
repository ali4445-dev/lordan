import 'package:flutter/material.dart';

class LoadingBackground extends StatelessWidget {
  const LoadingBackground({super.key, required this.isLoading, required this.child});

  final bool isLoading;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Stack(
        children: [
          child,
          if (isLoading)
            Opacity(
              opacity: 0.6,
              child: ModalBarrier(dismissible: false, color: Theme.of(context).colorScheme.surface),
            ),
          if (isLoading)
            Center(
              child: Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: const CircularProgressIndicator.adaptive(),
              ),
            ),
        ],
      ),
    );
  }
}
