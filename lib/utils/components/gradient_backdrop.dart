import 'dart:ui';
import 'package:flutter/material.dart';

class GradientBackdrop extends StatelessWidget {
  const GradientBackdrop({
    super.key,
    required this.isDark,
  });

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return const Stack(
      fit: StackFit.expand,
      children: [
        // Base gradient
        _GradientLayer(),

        // Glow orbs – minimal blur for GPU efficiency
        Positioned(
          top: -70,
          left: -40,
          child: _Orb(
            color: Color.fromRGBO(255, 255, 255, 0.03),
            size: 220,
            blur: 0,
          ),
        ),
        Positioned(
          bottom: -60,
          right: -30,
          child: _Orb(
            color: Color.fromRGBO(255, 255, 255, 0.03),
            size: 180,
            blur: 0,
          ),
        ),
      ],
    );
  }
}

class _GradientLayer extends StatelessWidget {
  const _GradientLayer();

  @override
  Widget build(BuildContext context) {
    final parent = context.findAncestorWidgetOfExactType<GradientBackdrop>()!;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: const [0.0, 0.2, 0.4, 0.65, 0.85, 1.0],
          colors: parent.isDark
              // ? const [
              //     Color(0xFF020617), // very deep navy
              //     Color(0xFF001640), // midnight blue
              //     Color(0xFF003FA5), // sapphire
              //     Color(0xFF002285), // vivid royal blue
              //     Color(0xFF004DBF), // bright premium blue
              //     Color(0xFF001C42), // sky blue highlight
              //   ]
              // : const [
              //     Color(0xFF0A0F1F), // deep night
              //     Color(0xFF001D5C), // indigo navy
              //     Color(0xFF00248C), // royal blue
              //     Color(0xFF001F6C), // muted sapphire
              //     Color(0xFF003AAC), // softer premium
              //     Color(0xFF00236E), // subtle lighter edge
              //   ],
              ? const [
                  Color(0xFF020617), // very deep navy
                  Color(0xFF001640), // midnight blue
                  Color(0xFF3D00A5), // sapphire
                  Color(0xFF002285), // vivid royal blue
                  Color(0xFF5600BF), // bright premium blue
                  Color(0xFF001C42), // sky blue highlight
                ]
              : const [
                  Color(0xFF0A0F1F), // deep night
                  Color(0xFF300097), // indigo navy
                  Color(0xFF00248C), // royal blue
                  Color(0xFF2B006C), // muted sapphire
                  Color(0xFF003AAC), // softer premium
                  Color(0xFF00236E), // subtle lighter edge
                ],
        ),
      ),
    );
  }
}

// class _GradientLayer extends StatelessWidget {
//   const _GradientLayer();
//
//   @override
//   Widget build(BuildContext context) {
//     final parent = context.findAncestorWidgetOfExactType<GradientBackdrop>()!;
//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topRight,
//           end: Alignment.bottomLeft,
//           stops: const [0.0, 0.4, 1.0],
//           colors: parent.isDark
//               ? const [
//                   Color(0xFF0A0F1F),
//                   Color(0xFF111D3A),
//                   Color(0xFF1E3A8A),
//                 ]
//               : const [
//                   Color(0xFF4F509E),
//                   Color(0xFF213071),
//                   Color(0xFF052051),
//                 ],
//         ),
//       ),
//     );
//   }
// }

class _Orb extends StatelessWidget {
  const _Orb({
    required this.color,
    required this.size,
    this.blur = 0,
  });

  final Color color;
  final double size;
  final double blur;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
      ),
    );
  }
}
