import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lordan_v1/global.dart';
import 'package:lordan_v1/providers/auth_provider.dart';
import 'package:lordan_v1/screens/start/auth/login_screen.dart';
import 'package:lordan_v1/screens/start/components/header_section.dart';
import 'package:provider/provider.dart';
import 'package:lordan_v1/providers/user_provider.dart';
import 'package:lordan_v1/theme.dart';

import '../../extensions/role_type.dart';
import '../../utils/components/primary_back_button.dart';
import '../../utils/components/primary_button.dart';
import '../../utils/components/gradient_backdrop.dart';
import '../../utils/components/search_field.dart';

class OnboardingScreen extends StatefulWidget {
  static const String routeName = '/onboarding';

  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // void _showPremiumModal(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => const _PremiumUpgradeModal(),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    bool isDark = userProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: const PrimaryBackButton(),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          /// COMPONENT: Gradient Background
          GradientBackdrop(isDark: isDark),

          SafeArea(
            child: Column(
              children: [
                /// COMPONENT: Header Section
                const HeaderSection(
                  logoVisible: true,
                  title: "Choose Your Role",
                  subtitle: "Search the role that fits your needs.",
                ),

                const SizedBox(height: 16),

                SearchField(
                  searchController: _searchController,
                  hintText: 'Search for Role',
                ),

                /// COMPONENT: Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 24),
                      child: _RolesGrid(
                        freeRoles: userProvider.freeRoles,
                        premiumRoles: userProvider.premiumRoles,
                        onRoleTap: (role) {
                          context.read<UserProvider>().toggleRole(
                                role,
                                isPremiumUser:
                                    context.read<UserProvider>().isPremium,
                              );

                          GlobalData.toggleRole(
                            role,
                            isPremiumUser:
                                context.read<UserProvider>().isPremium,
                          );
                        },
                        onPremiumTap: () async {},
                      ),
                    ),
                  ),
                ),

                /// COMPONENT: Continue Button - Pinned to bottom
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: PrimaryButton(
                    horizontalMargin: 24,
                    label: 'Continue',
                    enabled: userProvider.selectedRoles.isNotEmpty,
                    onPressed: userProvider.selectedRoles.isEmpty
                        ? null
                        : () async {
                            // await context.read<AuthProvider>().updateSession();
                            context.push(LoginScreen.routeName);
                          },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RolesGrid extends StatelessWidget {
  const _RolesGrid({
    required this.freeRoles,
    required this.premiumRoles,
    required this.onRoleTap,
    required this.onPremiumTap,
  });

  final List<RoleType> freeRoles;
  final List<RoleType> premiumRoles;
  final Function(RoleType) onRoleTap;
  final VoidCallback onPremiumTap;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Default to 3 columns on mobile, more on larger screens
    final crossAxisCount = screenWidth < 600
        ? 3
        : screenWidth < 900
            ? 4
            : 5;

    // Combine free and premium roles
    final allRoles = [...freeRoles, ...premiumRoles];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 2.0, // Square cards for better grid alignment
        crossAxisSpacing: 8, // Reduced spacing for more compact layout
        mainAxisSpacing: 8,
      ),
      itemCount: allRoles.length,
      itemBuilder: (context, index) {
        final role = allRoles[index];
        return RoleCard(
          role: role,
          onTap: () {
            if (role.isPremium && !context.read<UserProvider>().isPremium) {
              print("Premium Tap called");
              onPremiumTap();
            } else {
              print("Role Tap Called");
              onRoleTap(role);
            }
          },
        );
      },
    );
  }
}

class RoleCard extends StatelessWidget {
  const RoleCard({
    required this.role,
    required this.onTap,
    super.key,
  });

  final RoleType role;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isSelected = context.watch<UserProvider>().isRoleSelected(role);
    final isPremium = role.isPremium;
    final isLocked = isPremium && !context.watch<UserProvider>().isPremium;

    return RepaintBoundary(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            gradient: isPremium
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF000ABF),
                      Color(0xff8c00ff),
                      Color(0xff0011ff),
                    ],
                    // Add overlay for selected state
                    stops: [0.0, 0.5, 1.0],
                  )
                : const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF899CFF),
                      Color(0xff2937ff),
                    ],
                  ),
            color: !isPremium
                ? (isDark ? AppColors.glassDark : AppColors.glassLight)
                    .withValues(
                    alpha: isSelected ? 0.9 : 0.4,
                  )
                : null,
            borderRadius: BorderRadius.circular(16),
            // Slightly smaller radius
            border: Border.all(
              color: isSelected
                  ? (isPremium
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.7))
                  : Colors.white.withValues(alpha: 0.4),
              width: isSelected ? 2.0 : 1.0,
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (isLocked)
                Positioned(
                    top: 6,
                    right: 6,
                    child: SvgPicture.asset(
                      'assets/icons/premium_crown.svg',
                      width: 16,
                      colorFilter: ColorFilter.mode(
                          isPremium ? Colors.yellow : Colors.black87,
                          BlendMode.srcIn),
                    )),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  role.displayName,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    color: isPremium
                        ? (isSelected
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.8))
                        : (isDark
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.6)),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Selection overlay for non-premium cards
              if (isSelected && !isPremium)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.1),
                        width: 1,
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFFFFFFFF).withValues(alpha: 0.1),
                          const Color(0xFF0061FF).withValues(alpha: 0.1),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// COMPONENT: Premium Upgrade Modal
// class _PremiumUpgradeModal extends StatelessWidget {
//   const _PremiumUpgradeModal();
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final isDark = theme.brightness == Brightness.dark;
//
//     return Dialog(
//       backgroundColor: Colors.transparent,
//       child: RepaintBoundary(
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(32),
//           child: BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
//             child: Container(
//               padding: const EdgeInsets.all(24),
//               decoration: BoxDecoration(
//                 color: isDark ? AppColors.glassDark.withValues(alpha: 0.85) : AppColors.glassLight.withValues(alpha: 0.85),
//                 borderRadius: BorderRadius.circular(32),
//                 border: Border.all(
//                   color: Colors.white.withValues(alpha: isDark ? 0.05 : 0.18),
//                   width: 1.2,
//                 ),
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   /// Modal Icon
//                   Container(
//                     width: 64,
//                     height: 64,
//                     decoration: const BoxDecoration(
//                       shape: BoxShape.circle,
//                       gradient: LinearGradient(
//                         colors: [AppColors.secondaryLight, AppColors.primaryLight],
//                       ),
//                     ),
//                     child: const Icon(
//                       Icons.lock_open,
//                       color: Colors.white,
//                       size: 32,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//
//                   /// Modal Title
//                   Text(
//                     'Upgrade to Premium',
//                     style: theme.textTheme.headlineSmall?.copyWith(
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//
//                   /// Modal Message
//                   Text(
//                     'Unlock premium roles and get access to advanced features like Pitch Practice, Live Voice, and Logic Coach.',
//                     textAlign: TextAlign.center,
//                     style: theme.textTheme.bodyMedium?.copyWith(
//                       color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
//                       height: 1.5,
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//
//                   /// Modal Buttons
//                   Row(
//                     children: [
//                       Expanded(
//                         child: ModalButton(
//                           label: 'Maybe Later',
//                           isPrimary: false,
//                           onPressed: () => Navigator.of(context).pop(),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: ModalButton(
//                           label: 'Upgrade Now',
//                           isPrimary: true,
//                           onPressed: () => Navigator.of(context).pop(),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

/// COMPONENT: Modal Button
class ModalButton extends StatelessWidget {
  const ModalButton({
    required this.label,
    required this.isPrimary,
    required this.onPressed,
    super.key,
  });

  final String label;
  final bool isPrimary;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isPrimary ? AppColors.primaryLight : Colors.transparent,
        foregroundColor: isPrimary ? Colors.white : theme.colorScheme.primary,
        side: isPrimary ? null : BorderSide(color: theme.colorScheme.primary),
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
