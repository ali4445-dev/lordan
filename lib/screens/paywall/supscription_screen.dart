// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:lordan_v1/providers/subscribtion_provider.dart';
// import 'package:provider/provider.dart';
// import '../../providers/user_provider.dart';

// import '../home_screen.dart';
// import '../../utils/components/gradient_backdrop.dart';

// class PaywallScreen extends StatefulWidget {
//   static const String routeName = '/paywall';
//   const PaywallScreen({super.key});

//   @override
//   State<PaywallScreen> createState() => _PaywallScreenState();
// }

// class _PaywallScreenState extends State<PaywallScreen> {
//   bool _isYearlySelected = false;

//   @override
//   Widget build(BuildContext context) {
//     final userProvider = Provider.of<UserProvider>(context);
//     final subService = Provider.of<SubscriptionService>(context);
//     bool isDark = userProvider.themeMode == ThemeMode.dark;

//     // Check if products fetched
//     final products = subService.products;
//     final hasProducts = products.isNotEmpty;

//     return Scaffold(
//       body: Stack(
//         children: [
//           GradientBackdrop(isDark: isDark),
//           SafeArea(
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 24.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     const SizedBox(height: 8),
//                     // Logo + Close
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         const SizedBox(),
//                         Image.asset(
//                           'assets/brand_logos/logo_text.png',
//                           height: 60,
//                         ),
//                         GestureDetector(
//                           onTap: () => context.push(HomeScreen.routeName),
//                           child: const Icon(Icons.close, color: Colors.white),
//                         )
//                       ],
//                     ),
//                     const SizedBox(height: 120),

//                     const Text(
//                       'Upgrade to Premium',
//                       style: TextStyle(
//                         fontSize: 28,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                     const SizedBox(height: 24),

//                     // Plan switcher
//                     Container(
//                       padding: const EdgeInsets.all(4),
//                       decoration: BoxDecoration(
//                         color: Colors.white.withAlpha(20),
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: _PlanWrapper(
//                               isSelected: !_isYearlySelected,
//                               child: _PlanButton(
//                                 title: 'Monthly',
//                                 isSelected: !_isYearlySelected,
//                                 onTap: () =>
//                                     setState(() => _isYearlySelected = false),
//                               ),
//                             ),
//                           ),
//                           Expanded(
//                             child: Stack(
//                               clipBehavior: Clip.none,
//                               children: [
//                                 _PlanWrapper(
//                                   isSelected: _isYearlySelected,
//                                   child: _PlanButton(
//                                     title: 'Yearly',
//                                     isSelected: _isYearlySelected,
//                                     onTap: () => setState(
//                                         () => _isYearlySelected = true),
//                                   ),
//                                 ),
//                                 Positioned(
//                                   top: -8,
//                                   right: 12,
//                                   child: Container(
//                                     padding: const EdgeInsets.symmetric(
//                                       horizontal: 8,
//                                       vertical: 2,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       color: const Color(0xFFFFD700),
//                                       borderRadius: BorderRadius.circular(12),
//                                     ),
//                                     child: const Text(
//                                       'Save 16%',
//                                       style: TextStyle(
//                                         fontSize: 10,
//                                         fontWeight: FontWeight.w600,
//                                         color: Colors.black87,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 24),

//                     // Dynamic products
//                     if (hasProducts)
//                       Column(
//                         children: products.map((product) {
//                           return Padding(
//                             padding: const EdgeInsets.only(bottom: 16),
//                             child: Container(
//                               padding: const EdgeInsets.all(16),
//                               decoration: BoxDecoration(
//                                 color: Colors.white.withAlpha(20),
//                                 borderRadius: BorderRadius.circular(16),
//                               ),
//                               child: Row(
//                                 children: [
//                                   const Icon(Icons.star,
//                                       color: Color(0xFFFFD700), size: 28),
//                                   const SizedBox(width: 16),
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           product.title,
//                                           style: const TextStyle(
//                                             color: Colors.white,
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                         Text(
//                                           product.description,
//                                           style: TextStyle(
//                                             color: Colors.white.withAlpha(200),
//                                             fontSize: 13,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Text(
//                                     product.price,
//                                     style: const TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         }).toList(),
//                       )
//                     else
//                       // No products
//                       Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: ElevatedButton(
//                           onPressed: () {
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               const SnackBar(
//                                 content: Text(
//                                     '⚠️ No subscriptions found. Check your Play Console setup.'),
//                                 backgroundColor: Colors.redAccent,
//                               ),
//                             );
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.white24,
//                           ),
//                           child: const Text(
//                             'No Products Available',
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ),
//                       ),

//                     const SizedBox(height: 24),

//                     // CTA Button
//                     Container(
//                       width: double.infinity,
//                       height: 52,
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(26),
//                         gradient: const LinearGradient(
//                           colors: [
//                             Color(0xFFFFD700),
//                             Colors.amber,
//                             Colors.white,
//                           ],
//                         ),
//                       ),
//                       child: ElevatedButton(
//                         onPressed: hasProducts
//                             ? () async {
//                                 final selectedProduct = _isYearlySelected
//                                     ? products.firstWhere(
//                                         (p) =>
//                                             p.id.contains('annual') ||
//                                             p.id == 'annual_plan_id',
//                                         orElse: () => products.first)
//                                     : products.firstWhere(
//                                         (p) =>
//                                             p.id.contains('monthly') ||
//                                             p.id == 'monthly_plan_id',
//                                         orElse: () => products.first);

//                                 try {
//                                   await subService.buy(selectedProduct);
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(
//                                       content: Text(
//                                           '⏳ Processing purchase for ${selectedProduct.title}...'),
//                                     ),
//                                   );
//                                 } catch (e) {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(
//                                       content: Text('❌ Error: $e'),
//                                       backgroundColor: Colors.redAccent,
//                                     ),
//                                   );
//                                 }
//                               }
//                             : null,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.transparent,
//                           shadowColor: Colors.transparent,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(26),
//                           ),
//                         ),
//                         child: const Text(
//                           'Upgrade to Premium',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.black87,
//                           ),
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 24),

//                     Text(
//                       'Secure payments • Cancel anytime • Privacy-first',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         color: Colors.white.withOpacity(0.6),
//                         fontSize: 12,
//                       ),
//                     ),
//                     const SizedBox(height: 24),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _PlanButton extends StatelessWidget {
//   final String title;
//   final bool isSelected;
//   final VoidCallback onTap;
//   const _PlanButton(
//       {required this.title, required this.isSelected, required this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 12),
//         decoration: BoxDecoration(
//           color: isSelected ? Colors.white.withAlpha(30) : Colors.transparent,
//           borderRadius: BorderRadius.circular(14),
//         ),
//         child: Text(
//           title,
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             color: Colors.white.withAlpha(isSelected ? 255 : 179),
//             fontSize: 15,
//             fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
//           ),
//         ),
//       ),
//     );
//   }
// }

// class _PlanWrapper extends StatelessWidget {
//   final bool isSelected;
//   final Widget child;
//   const _PlanWrapper({required this.isSelected, required this.child});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 4),
//       decoration: BoxDecoration(
//         color: Colors.white.withAlpha(20),
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(
//           color: Colors.white.withOpacity(isSelected ? 0.8 : 0.4),
//           width: isSelected ? 1.5 : 1,
//         ),
//       ),
//       child: child,
//     );
//   }
// }
