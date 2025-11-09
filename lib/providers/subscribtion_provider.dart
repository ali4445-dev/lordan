import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:lordan_v1/global.dart';
import 'package:lordan_v1/service/user_storage_service.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:in_app_purchase_android/in_app_purchase_android.dart';

class SubscriptionService with ChangeNotifier {
  final InAppPurchase _iap = InAppPurchase.instance;
  bool _available = false;
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  static StreamSubscription<List<PurchaseDetails>>? _subscriptionStream;

  SubscriptionService() {
    init();
  }

  Future<void> checkSubscriptionStatus() async {
    // bool isActive = false;
    final InAppPurchase _iap = InAppPurchase.instance;
    await _subscriptionStream?.cancel();

    _iap.restorePurchases();
    _iap.purchaseStream.listen((list) async {
      if (list.isNotEmpty) {
        for (final purchase in list) {
          //         // Only consider completed purchases

          if (purchase.status == PurchaseStatus.restored) {
            await UserStorageService.saveUserStatus("", purchase: purchase);
            notifyListeners();
            break;
          }
          //  single subscription, stop at first active
        }
      } else {
        await UserStorageService.saveUserStatus("", cancel: true);
        notifyListeners();
      }
    }, onDone: () {
      print("✅ Purchase stream closed");
      notifyListeners();
      // ignore: unnecessary_this
    });

    // InAppPurchase.instance.purchaseStream.listen(onData)

    // try {
    //   // --- Android ---
    //   if (Platform.isAndroid) {

    //     final androidAddition =
    //         _iap.getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();

    //     // Query past purchases
    //     final response = await androidAddition.queryPastPurchases();

    //     if (response.error != null) {
    //       debugPrint('Android subscription query error: ${response.error}');
    //     } else {
    //       for (final purchase in response.pastPurchases) {
    //         // Only consider completed purchases
    //         if (purchase.status == PurchaseStatus.purchased) {
    //           isActive = true;
    //           await UserStorageService.saveUserStatus("", purchase: purchase);
    //           break; // single subscription, stop at first active
    //         }
    //       }
    //     }
    //   }

    //   // --- iOS ---
    //   else if (Platform.isIOS) {
    //     // iOS requires restore purchases to get latest status
    //     await _iap.restorePurchases();

    //     final response = await _iap.qu;

    //     if (response.error != null) {
    //       debugPrint('iOS subscription query error: ${response.error}');
    //     } else {
    //       for (final purchase in response.pastPurchases) {
    //         if (purchase.status == PurchaseStatus.purchased) {
    //           isActive = true;
    //           await UserStorageService.saveUserStatus("", purchase: purchase);
    //           break;
    //         }
    //       }
    //     }
    //   }

    //   // --- Log final status ---
    //   debugPrint('✅ Subscription active: $isActive');
    // } catch (e, stackTrace) {
    //   debugPrint('❌ Error checking subscription: $e');
    //   debugPrint(stackTrace.toString());
    // }
  }

  void listen() {
    notifyListeners();
  }

  static Future<void> openPlayStoreSubscriptionPage(String productId) async {
    // This opens the Google Play subscription management page for your app.

    Uri? url;
    if (Platform.isAndroid) {
      // Android: Play Store subscriptions page
      url = Uri.parse(
        'https://play.google.com/store/account/subscriptions?sku=$productId&package=com.chatbot.lordan_v1',
      );
    } else if (Platform.isIOS) {
      // iOS: App Store subscription management
      url = Uri.parse('https://apps.apple.com/account/subscriptions');
    }

    if (await canLaunchUrl(url!)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not open the subscription page.';
    }
  }

  // ✅ Real product IDs from Play Console
  static const Set<String> _kIds = {'lordan_subscription'};

  //  'lordan_subscription'

  bool get isAvailable => _available;
  List<ProductDetails> get products => _products;
  List<PurchaseDetails> get purchases => _purchases;

  Future<void> init() async {
    print(
        "In the init of Subscription Service ...............................");
    try {
      final Stream<List<PurchaseDetails>> purchaseUpdated = _iap.purchaseStream;
      _subscription =
          purchaseUpdated.listen(_onPurchaseUpdate, onError: (error) {
        debugPrint('Purchase Stream Error: $error');
      });

      _available = await _iap.isAvailable();
      if (!_available) {
        debugPrint('Billing not available');
        return;
      }

      final response = await _iap.queryProductDetails(_kIds);
      if (response.error != null) {
        debugPrint('Error fetching product details: ${response.error}');
        return;
      }

      if (response.productDetails.isEmpty) {
        print('⚠️ No products found on Play Console');
        debugPrint('⚠️ No products found on Play Console');
      }

      _products = response.productDetails;
      _products.sort((a, b) => a.rawPrice.compareTo(b.rawPrice));

      // // print("✅ Products sorted by price (low → high):");
      // // for (var product in _products) {
      // //   print("--------------------------------------------------");
      // //   print("🛒 Product ID: ${product.id}");
      // //   print("Title: ${product.title}");
      // //   print("Description: ${product.description}");
      // //   print("Currency: ${product.currencyCode}");
      // //   print("Raw Price: ${product.rawPrice}");

      // //   // Loop through base plans (subscription offers)
      // //   // final offers = product.subscriptionOffers;
      // //   // if (offers != null && offers.isNotEmpty) {
      // //   //   for (var offer in offers) {
      // //   //     print("  🔹 Base Plan ID: ${offer.basePlanId}");
      // //   //     print("  🔹 Offer Token: ${offer.offerToken}");

      // //   //     // Pricing phases — may have trial + main period
      // //   //     for (var phase in offer.pricingPhases) {
      // //   //       print("    💰 Price: ${phase.formattedPrice}");
      // //   //       print("    🕓 Billing Period: ${phase.billingPeriod}");
      // //   //       print("    🔁 Recurrence Mode: ${phase.recurrenceMode}");
      // //   //     }
      // //   //   }
      // //   // } else {
      // //   //   print("  ⚠️ No subscription offers (base plans) found.");
      // //   // }
      // }

      print(response);
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing IAP..........................: $e');
    }
  }

  void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) async {
    print("Purchase Update called");
    _purchases.addAll(purchaseDetailsList);
    if (purchaseDetailsList.isEmpty) {
      print("User has Canceled the subscription");

      await UserStorageService.saveUserStatus("", cancel: true);
    }
    for (final purchase in purchaseDetailsList) {
      print(purchase.status);
      if (purchase.status == PurchaseStatus.purchased) {
        debugPrint(
            '✅ Purchase successful: ${purchase.productID}  with ${purchase.purchaseID}');
        print(purchase.verificationData);

        UserStorageService.saveUserStatus(GlobalData.planInProgresss!);
      } else if (purchase.status == PurchaseStatus.error) {
        debugPrint('❌ Purchase error: ${purchase.error}');
      } else if (purchase.status == PurchaseStatus.canceled) {
        //  UserStorageService.saveUserStatus(cancel:true);
        debugPrint('❌Purchase Cancelled');
      }

      if (purchase.pendingCompletePurchase) {
        _iap.completePurchase(purchase);
      }
    }
    notifyListeners();
  }

  Future<void> buy(ProductDetails product) async {
    try {
      final purchaseParam = PurchaseParam(productDetails: product);
      await _iap.buyNonConsumable(purchaseParam: purchaseParam);
    } catch (e) {
      print("Cannot Proceed $e");
    }
  }

  void disposeService() {
    _subscription?.cancel();
  }

  // Future<void> simulatePurchase(String productId) async {
  //   final fakePurchase = PurchaseDetails(
  //     purchaseID: DateTime.now().millisecondsSinceEpoch.toString(),
  //     productID: productId,
  //     status: PurchaseStatus.purchased,
  //     transactionDate: DateTime.now().toString(),
  //     verificationData: PurchaseVerificationData(
  //       localVerificationData: "mock",
  //       serverVerificationData: "mock",
  //       source: "mock",
  //     ),
  //   );

  //   _onPurchaseUpdate([fakePurchase]);
  // }
}
