import 'package:flutter/material.dart';
import 'package:lordan_v1/screens/home_screen_pages/settings/terms_of_service_screen.dart';

class AgreeWithTerms extends StatefulWidget {
  const AgreeWithTerms({super.key});
  

  @override
  State<AgreeWithTerms> createState() => _AgreeWithTermsState();
}

class _AgreeWithTermsState extends State<AgreeWithTerms> {
  bool _isAgreed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 🟩 Row with checkbox and text
        FittedBox(
          child: Row(
            children: [
              // Checkbox(
              //   value: _isAgreed,
              //   activeColor: Colors.blueAccent,
              //   checkColor: Colors.white,
              //   onChanged: (bool? value) {
              //     setState(() {
              //       _isAgreed = value ?? false;
              //     });
              //   },
              // ),
              Text(
                'By signing in, you agree to our ',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                ),
              ),
              GestureDetector(
                onTap: () {
                  // 👇 You can show Terms page or open URL here
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const TermsOfServiceScreen()));
                },
                child: Text(
                  'Terms & Conditions',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // 🟦 Continue Button
        // ElevatedButton(
        //   onPressed: _isAgreed
        //       ? () {
        //           // Proceed with next step
        //           ScaffoldMessenger.of(context).showSnackBar(
        //             const SnackBar(content: Text('Continuing...')),
        //           );
        //         }
        //       : null, // Disabled when not agreed
        //   style: ElevatedButton.styleFrom(
        //     backgroundColor: _isAgreed ? Colors.blueAccent : Colors.grey,
        //   ),
        //   child: const Text('Continue'),
        // ),
      ],
    );
  }
}
