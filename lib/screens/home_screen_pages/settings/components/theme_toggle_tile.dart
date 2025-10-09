import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ThemeToggleTile extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onToggle;
  final TextStyle? titleStyle;
  final Color? iconColor;

  const ThemeToggleTile({
    super.key,
    required this.isDarkMode,
    required this.onToggle, this.titleStyle, this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: FaIcon(FontAwesomeIcons.solidMoon, color: iconColor),
      title: const Text('Appearance'),
      titleTextStyle: titleStyle,
      trailing: CupertinoSwitch(
        value: isDarkMode,
        onChanged: onToggle,
        activeTrackColor: Colors.blueAccent,
        inactiveTrackColor: Colors.white.withValues(alpha: 0.25),
      ),
    );
  }
}
