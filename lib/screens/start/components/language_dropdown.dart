import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lordan_v1/providers/user_provider.dart'; // adjust import to your path

class LanguageDropdown extends StatefulWidget {
  final List<Locale> locales;
  final Locale? initialValue;
  final ValueChanged<Locale> onChanged;

  const LanguageDropdown({
    super.key,
    required this.locales,
    this.initialValue,
    required this.onChanged,
  });

  @override
  State<LanguageDropdown> createState() => _LanguageDropdownState();
}

class _LanguageDropdownState extends State<LanguageDropdown> {
  late Locale selectedLocale;

  @override
  void initState() {
    super.initState();
    selectedLocale = widget.initialValue ?? widget.locales.first;
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.read<UserProvider>();

    return DropdownButtonFormField<Locale>(
      initialValue: selectedLocale,
      decoration: InputDecoration(
        labelText: "Select Language",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      dropdownColor: Colors.white,
      items: widget.locales.map((locale) {
        final languageName = userProvider.labelFor(locale);
        return DropdownMenuItem<Locale>(
          value: locale,
          child: Text(languageName),
        );
      }).toList(),
      onChanged: (newLocale) {
        if (newLocale != null) {
          setState(() => selectedLocale = newLocale);
          widget.onChanged(newLocale);
        }
      },
    );
  }
}
