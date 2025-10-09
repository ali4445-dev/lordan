import 'package:flutter/material.dart';

class SettingTile extends StatelessWidget {
  final String title;
  final Widget leading;
  final Widget trailing;
  final TextStyle? titleStyle;
  final VoidCallback? onTap;

  const SettingTile({super.key, required this.title, required this.leading, required this.trailing, this.titleStyle, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: leading,
      title: Text(title),
      trailing: trailing,
      titleTextStyle: titleStyle,
    );
  }
}
