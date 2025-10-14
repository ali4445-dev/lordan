import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

/// Create a payment intent on Stripe
Future<Map<String, dynamic>?> makePaymentIntent({
  required int amountInUSD,
  String currency = 'usd',
}) async {
  try {
    await dotenv.load(fileName: ".env");

    final Map<String, dynamic> paymentInfo = {
      'amount': (amountInUSD * 100).toString(), // Convert to cents
      'currency': currency,
      'payment_method_types[]': 'card',
    };

    final response = await http.post(
      Uri.parse('https://api.stripe.com/v1/payment_intents'),
      body: paymentInfo,
      headers: {
        'Authorization': 'Bearer ${dotenv.env["STRIPE_SECRET_KEY"]}',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
    );

    final decoded = jsonDecode(response.body);
    if (response.statusCode != 200) {
      throw Exception(
          'Stripe error: ${decoded['error']?['message'] ?? decoded}');
    }
    return decoded;
  } catch (e, s) {
    if (kDebugMode) {
      print('❌ makePaymentIntent error: $e\n$s');
    }
    return null;
  }
}

/// Initialize Stripe payment sheet
Future<void> initPaymentSheet(BuildContext context, int amount) async {
  try {
    final intentData = await makePaymentIntent(amountInUSD: amount);
    if (intentData == null || intentData['client_secret'] == null) {
      throw Exception('Payment intent creation failed');
    }

    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        customFlow: false,
        merchantDisplayName: 'Lordan Package Upgradation',
        paymentIntentClientSecret: intentData['client_secret'],
        style: ThemeMode.dark,
      ),
    );

    await showPaymentSheet(context);
  } catch (e, s) {
    if (kDebugMode) {
      print('⚠️ initPaymentSheet error: $e\n$s');
    }
    _showDialog(context, 'Error', 'Failed to initialize payment: $e');
  }
}

/// Display the Stripe payment sheet
Future<void> showPaymentSheet(BuildContext context) async {
  try {
    await Stripe.instance.presentPaymentSheet();

    _showDialog(context, 'Payment Successful 🎉',
        'Thank you for upgrading your Lordan package!');
  } on StripeException catch (e) {
    _showDialog(context, 'Payment Cancelled', e.error.localizedMessage ?? '');
  } catch (e, s) {
    if (kDebugMode) {
      print('❌ showPaymentSheet error: $e\n$s');
    }
    _showDialog(context, 'Error', 'Something went wrong: $e');
  }
}

/// Simple alert dialog
void _showDialog(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      content: Text(message),
      actions: [
        TextButton(
          child: const Text('OK'),
          onPressed: () => Navigator.of(context).pop(),
        )
      ],
    ),
  );
}
