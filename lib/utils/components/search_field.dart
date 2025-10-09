import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../theme.dart';

class SearchField extends StatelessWidget {
  final TextEditingController searchController;
  final double? horizontalPadding;
  final double? verticalPadding;
  final String? hintText;

  const SearchField({super.key, required this.searchController, this.horizontalPadding, this.verticalPadding, this.hintText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.symmetric(
        horizontal: horizontalPadding ?? 16.0,
        vertical: verticalPadding ?? 0,
      ),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 12, right: 8),
            child: SvgPicture.asset(
              'assets/icons/search.svg',
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
              width: 22,
            ),
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
          prefixIconColor: Colors.white,
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: AppColors.glassLight.withValues(alpha: 0.2),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

