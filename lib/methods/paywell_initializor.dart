import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

void paymentSheetInitializor() async {
  try {} catch (errorMsg, s) {
    final intentPaymentdata = await makePaymentIntent();
    await Stripe.instance
        .initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        // Set to true for custom flow
        customFlow: false,
        // Main params
        merchantDisplayName: 'Lordan Package Upgradation',
        paymentIntentClientSecret: intentPaymentdata['client_secret'],
        // Customer keys
        // customerEphemeralKeySecret: data['ephemeralKey'],
        // customerId: data['customer'],
        // // Extra options
        // applePay: const PaymentSheetApplePay(
        //   merchantCountryCode: 'US',
        // ),
        // googlePay: const PaymentSheetGooglePay(
        //   merchantCountryCode: 'US',
        //   testEnv: true,
        // ),
        style: ThemeMode.dark,
      ),
    )
        .then((val) {
      print(val);
    });

    if (kDebugMode) {
      print(s);
    }
    print(errorMsg.toString());
  }
}

makePaymentIntent() async {
  try {
    await dotenv.load(fileName: ".env");
    Map<String, dynamic> paymentInfo = {
      "amount": 20,
      "currency": "USD",
      "payment_method_types[]": "card",
    };
    final responseFromStripe = await http.post(
        Uri.parse("https://api.stripe.com/v1/payment_intents"),
        body: paymentInfo,
        headers: {
          "Authorization": "Bearer ${dotenv.env["STRIPE_SECRET_KEY"]}",
          "Content_Type": "application/x-www-form-urlencoded"
        });
    final decodedStripe = jsonDecode(responseFromStripe.body);
    return decodedStripe;
  } catch (errorMsg, s) {
    if (kDebugMode) {
      print(s);
    }
    print(errorMsg.toString());
  }
}
