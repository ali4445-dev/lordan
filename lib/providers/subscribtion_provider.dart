import 'dart:async';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class SubscriptionService with ChangeNotifier {
  final InAppPurchase _iap = InAppPurchase.instance;
  bool _available = false;
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  StreamSubscription<List<PurchaseDetails>>? _subscription;

  // ✅ Real product IDs from Play Console
  static const Set<String> _kIds = {
    'annual_plan_id',
    'monthly_plan_id',
  };

  bool get isAvailable => _available;
  List<ProductDetails> get products => _products;
  List<PurchaseDetails> get purchases => _purchases;

  Future<void> init() async {
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
        debugPrint('⚠️ No products found on Play Console');
      }

      _products = response.productDetails;
      notifyListeners();
    } catch (e) {
      debugPrint('Error initializing IAP: $e');
    }
  }

  void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) {
    _purchases.addAll(purchaseDetailsList);
    for (final purchase in purchaseDetailsList) {
      if (purchase.status == PurchaseStatus.purchased) {
        debugPrint('✅ Purchase successful: ${purchase.productID}');
      } else if (purchase.status == PurchaseStatus.error) {
        debugPrint('❌ Purchase error: ${purchase.error}');
      }

      if (purchase.pendingCompletePurchase) {
        _iap.completePurchase(purchase);
      }
    }
    notifyListeners();
  }

  Future<void> buy(ProductDetails product) async {
    final purchaseParam = PurchaseParam(productDetails: product);
    await _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  void disposeService() {
    _subscription?.cancel();
  }
}
