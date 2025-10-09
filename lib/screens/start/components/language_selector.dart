// import 'package:flutter/material.dart';
// import 'package:http/http.dart';
// import 'package:provider/provider.dart';
//
// import '../../../providers/user_provider.dart';
// import '../../../theme.dart';
//
//
// /// COMPONENT: Language Selector (Mobile Dropdown / Desktop Pills)
// class LanguageSelector extends StatelessWidget {
//   const LanguageSelector({super.key,
//     required this.locales,
//     required this.isTablet,
//     required this.isDesktop,
//     required this.selected,
//     required this.onChanged,
//     required this.searchQuery,
//     required this.onSearchChanged,
//   });
//
//   final List<Locale> locales;
//   final bool isTablet;
//   final bool isDesktop;
//   final Locale? selected;
//   final ValueChanged<Locale?> onChanged;
//   final String searchQuery;
//   final ValueChanged<String> onSearchChanged;
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final isDark = theme.brightness == Brightness.dark;
//
//     /// ---- Mobile Layout ----
//     if (!isTablet && !isDesktop) {
//       return Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           _SearchBar(
//             onSearchChanged: onSearchChanged,
//             isDark: isDark,
//             theme: theme,
//           ),
//           Flexible(
//             fit: FlexFit.loose,
//             child: _MobileList(
//               locales: locales,
//               searchQuery: searchQuery,
//               selected: selected,
//               onChanged: onChanged,
//               isDark: isDark,
//               theme: theme,
//             ),
//           ),
//         ],
//       );
//     }
//
//     /// ---- Desktop / Tablet Layout ----
//     return _DesktopGrid(
//       locales: locales,
//       selected: selected,
//       onChanged: onChanged,
//       isDesktop: isDesktop,
//       isDark: isDark,
//       theme: theme,
//     );
//   }
// }
//
// /// SEARCH BAR (Mobile)
// class _SearchBar extends StatelessWidget {
//   const _SearchBar({
//     required this.onSearchChanged,
//     required this.isDark,
//     required this.theme,
//   });
//
//   final ValueChanged<String> onSearchChanged;
//   final bool isDark;
//   final ThemeData theme;
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: TextField(
//         onChanged: onSearchChanged,
//         decoration: InputDecoration(
//           hintText: 'Search languages...',
//           prefixIcon: const Icon(Icons.search, size: 20),
//           filled: true,
//           fillColor: isDark
//               ? AppColors.glassDark.withValues(alpha: 0.6)
//               : AppColors.glassLight.withValues(alpha: 0.6),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(20),
//             borderSide: BorderSide(
//               color: Colors.white.withValues(alpha: isDark ? 0.06 : 0.18),
//               width: 1.0,
//             ),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(20),
//             borderSide: BorderSide(
//               color: Colors.white.withValues(alpha: isDark ? 0.06 : 0.18),
//               width: 1.0,
//             ),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(20),
//             borderSide: BorderSide(
//               color: theme.colorScheme.primary.withValues(alpha: 0.65),
//               width: 1.6,
//             ),
//           ),
//           contentPadding:
//           const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         ),
//       ),
//     );
//   }
// }
//
// /// MOBILE LIST – uses RepaintBoundary to isolate blur/shadow rebuilds
// class _MobileList extends StatelessWidget {
//   const _MobileList({
//     required this.locales,
//     required this.searchQuery,
//     required this.selected,
//     required this.onChanged,
//     required this.isDark,
//     required this.theme,
//   });
//
//   final List<Locale> locales;
//   final String searchQuery;
//   final Locale? selected;
//   final ValueChanged<Locale?> onChanged;
//   final bool isDark;
//   final ThemeData theme;
//
//   @override
//   Widget build(BuildContext context) {
//     final userProvider = Provider.of<UserProvider>(context);
//
//     final filteredLocales = searchQuery.isEmpty
//         ? locales
//         : locales.where((locale) {
//       final label = (userProvider.labelFor(locale)).toLowerCase();
//       return label.contains(searchQuery.toLowerCase());
//     }).toList();
//
//     final maxHeight = filteredLocales.length <= 5 ? null : 280.0;
//
//     return RepaintBoundary(
//       child: ConstrainedBox(
//         constraints: BoxConstraints(
//           maxHeight: maxHeight ?? double.infinity,
//           minHeight: 0,
//         ),
//         child: ListView.separated(
//           shrinkWrap: true,
//           physics: const BouncingScrollPhysics(),
//           itemCount: filteredLocales.length,
//           separatorBuilder: (_, __) => const SizedBox(height: 4),
//           itemBuilder: (context, index) {
//             final loc = filteredLocales[index];
//             final label = userProvider.labelFor(loc) ?? '';
//             final flag = userProvider.flagFor(loc) ?? '';
//             return _LanguageTile(
//               label: label,
//               flag: flag,
//               value: loc,
//               selected: selected,
//               onChanged: onChanged,
//               isDark: isDark,
//               theme: theme,
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
//
// /// LANGUAGE TILE (single item)
// class _LanguageTile extends StatelessWidget {
//   const _LanguageTile({
//     required this.label,
//     required this.flag,
//     required this.value,
//     required this.selected,
//     required this.onChanged,
//     required this.isDark,
//     required this.theme,
//   });
//
//   final String label;
//   final String flag;
//   final Locale value;
//   final Locale? selected;
//   final ValueChanged<Locale?> onChanged;
//   final bool isDark;
//   final ThemeData theme;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: isDark
//             ? AppColors.glassDark.withValues(alpha: 0.6)
//             : AppColors.glassLight.withValues(alpha: 0.6),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
//       ),
//       child: RadioListTile<Locale>(
//         value: value,
//         groupValue: selected,
//         onChanged: onChanged,
//         controlAffinity: ListTileControlAffinity.trailing,
//         contentPadding: const EdgeInsets.symmetric(horizontal: 12),
//         title: Row(
//           children: [
//             Text(flag, style: theme.textTheme.titleMedium),
//             const SizedBox(width: 10),
//             Text(label, style: theme.textTheme.bodyMedium),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// /// DESKTOP/TABLET GRID
// class _DesktopGrid extends StatelessWidget {
//   const _DesktopGrid({
//     required this.locales,
//     required this.selected,
//     required this.onChanged,
//     required this.isDesktop,
//     required this.isDark,
//     required this.theme,
//   });
//
//   final List<Locale> locales;
//   final Locale? selected;
//   final ValueChanged<Locale?> onChanged;
//   final bool isDesktop;
//   final bool isDark;
//   final ThemeData theme;
//
//   @override
//   Widget build(BuildContext context) {
//     final userProvider = context.read<UserProvider>();
//
//     final crossAxisCount = isDesktop ? 3 : 2;
//     final rowCount = (locales.length / crossAxisCount).ceil();
//     final gridHeight = rowCount * 56 + (rowCount - 1) * 12;
//
//     return SizedBox(
//       height: gridHeight.toDouble(),
//       child: RepaintBoundary(
//         child: GridView.builder(
//           shrinkWrap: true,
//           physics: const BouncingScrollPhysics(),
//           gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
//             maxCrossAxisExtent: isDesktop ? 240 : 220,
//             mainAxisSpacing: 12,
//             crossAxisSpacing: 12,
//             childAspectRatio: isDesktop ? 4.0 : 3.6,
//           ),
//           itemCount: locales.length,
//           itemBuilder: (context, index) {
//             final loc = locales[index];
//             final label = userProvider.labelFor(loc) ?? '';
//             final flag = userProvider.flagFor(loc) ?? '';
//             final isSelected = selected == loc;
//             return InkWell(
//               onTap: () => onChanged(loc),
//               borderRadius: BorderRadius.circular(24),
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 200),
//                 curve: Curves.easeOut,
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                 decoration: BoxDecoration(
//                   color: (isDark
//                       ? AppColors.glassDark.withValues(alpha: 0.6)
//                       : AppColors.glassLight.withValues(alpha: 0.6)),
//                   borderRadius: BorderRadius.circular(24),
//                   border: Border.all(
//                     color: isSelected
//                         ? theme.colorScheme.primary.withValues(alpha: 0.65)
//                         : Colors.white.withValues(alpha: isDark ? 0.06 : 0.18),
//                     width: isSelected ? 1.6 : 1.0,
//                   ),
//                   // minimal shadow faqat tanlanganida
//                   boxShadow: isSelected
//                       ? [
//                     BoxShadow(
//                       color: theme.colorScheme.primary
//                           .withValues(alpha: 0.25),
//                       blurRadius: 8,
//                       spreadRadius: 1,
//                     )
//                   ]
//                       : [],
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text(flag, style: theme.textTheme.titleMedium),
//                     const SizedBox(width: 10),
//                     Expanded(
//                       child: Text(
//                         label,
//                         style: theme.textTheme.bodyMedium
//                             ?.copyWith(fontWeight: FontWeight.w600),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
