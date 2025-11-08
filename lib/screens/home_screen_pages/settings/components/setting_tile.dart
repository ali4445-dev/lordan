import 'package:flutter/material.dart';

class SettingTile extends StatelessWidget {
  final String title;
  final String? sub_title;
  final Widget leading;
  final Widget trailing;
  final TextStyle? titleStyle;
  final VoidCallback? onTap;

  const SettingTile(
      {super.key,
      required this.title,
      this.sub_title,
      required this.leading,
      required this.trailing,
      this.titleStyle,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: leading,
      title: Text(title),
      subtitle: sub_title != null
          ? Text(
              sub_title!,
              style: titleStyle!.copyWith(
                  fontSize: 12,
                  color: const Color.fromARGB(202, 255, 255, 255)),
            )
          : null,
      trailing: trailing,
      titleTextStyle: titleStyle,
    );
  }
}
