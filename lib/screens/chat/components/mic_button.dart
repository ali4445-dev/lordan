import 'package:flutter/material.dart';
import '../../../theme.dart';

class MicButton extends StatefulWidget {
  final bool isListening;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onLongPressUp;
  final String? logoAsset;
  final bool? isPremium;

  const MicButton({
    super.key,
    required this.onLongPress,
    required this.onLongPressUp,
    required this.isPremium,
    required this.isListening,
    required this.onTap,
    this.logoAsset,
  });

  @override
  State<MicButton> createState() => _MicButtonState();
}

class _MicButtonState extends State<MicButton> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  late AnimationController _rotateController;

  @override
  void initState() {
    super.initState();

    // Pulse Animation (increase/decrease)
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    // Rotate Animation (360°)
    _rotateController = AnimationController(
      // Rotate speed
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    if (widget.isListening) {
      _startAnimations();
    }
  }

  void _startAnimations() {
    _pulseController.repeat(reverse: true);
    // Infinite rotation
    _rotateController.repeat();
  }

  void _stopAnimations() {
    _pulseController.stop();
    _pulseController.reset();
    _rotateController.stop();
    _rotateController.reset();
  }

  @override
  void didUpdateWidget(MicButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isListening != oldWidget.isListening) {
      widget.isListening ? _startAnimations() : _stopAnimations();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      onLongPressUp: widget.onLongPressUp,
      child: AnimatedBuilder(
        animation: Listenable.merge([_pulseController, _rotateController]),
        builder: (context, child) {
          return Transform.scale(
            scale: widget.isListening ? _pulseAnimation.value : 1.0,
            child: RotationTransition(
              turns: widget.isListening
                  ? _rotateController
                  : const AlwaysStoppedAnimation(0),
              child: Container(
                width: 140,
                height: 140,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  // gradient: AppColors.buttonGradient,
                ),
                child: Center(
                  child: widget.logoAsset != null
                      ? Image.asset(
                          widget.logoAsset!,
                          width: 140,
                          color: Colors.white,
                        )
                      : Icon(
                          widget.isListening ? Icons.stop : Icons.mic,
                          size: 48,
                          color: Colors.white,
                        ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
