import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:async';
import 'package:go_router/go_router.dart';
import 'package:lordan_v1/screens/chat/chat_text_screen.dart';
import 'package:lordan_v1/screens/paywall/paywall_screen.dart';
import 'package:lordan_v1/service/user_storage_service.dart';
import 'package:lordan_v1/utils/components/loading_background.dart';
import 'package:lordan_v1/utils/components/search_field.dart';
import 'package:provider/provider.dart';

import '../../../providers/user_provider.dart';
import '../../../service/supabase_service.dart';
import '../../../theme.dart';
import '../../../utils/components/gradient_backdrop.dart';

// TODO: Remove dummy data once Supabase is connected
const _dummyUser = UserProfile(
  fullName: 'John Doe',
  avatarUrl: null,
  plan: 'free',
);

// TODO: Remove dummy data once Supabase is connected
const _dummyRoles = [
  Role(
    id: '1',
    name: 'Study Prep',
    description: 'Study skills, practice communication.',
    isPremium: false,
    isFeatured: true,
  ),
  Role(
    id: '2',
    name: 'Logic Coach',
    description:
        'Practice logic skills, develop critical thinking, solve problems.',
    isPremium: true,
    isFeatured: true,
  ),
  Role(
    id: '3',
    name: 'Debate Practice',
    description:
        'Practice public speaking, develop argumentation, gain confidence.',
    isPremium: false,
    isFeatured: false,
  ),
  Role(
    id: '4',
    name: 'Language Chat',
    description: 'Lang chat: practice your language skills.',
    isPremium: true,
    isFeatured: false,
  ),
];

// TODO: Remove dummy data once Supabase is connected
const _dummyFeaturedRoles = [
  Role(
    id: '5',
    name: 'Deal Prep',
    description: 'Meeting prep: practice effective communication skills.',
    isPremium: true,
    isFeatured: true,
  ),
  Role(
    id: '6',
    name: 'Focus Aid',
    description: 'Time management practice. Set goals. Prioritize tasks.',
    isPremium: false,
    isFeatured: true,
  ),
  Role(
    id: '4',
    name: 'Health Explainer',
    description: 'Get health-related tips and explanations.',
    isPremium: true,
    isFeatured: false,
  ),
  Role(
    id: '3',
    name: 'Creator Ideas',
    description: 'Get creative ideas for projects, tasks, and goals.',
    isPremium: false,
    isFeatured: false,
  ),
];

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({super.key});

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  final _supabaseService = SupabaseService();
  final _searchController = TextEditingController();
  Timer? _debounceTimer;

  late final Future<List<dynamic>> _initialData;
  UserProfile? _userProfile;
  List<Role>? _featuredRoles;
  List<Role>? _allRoles;

  bool _isLoading = true;

  String _searchQuery = '';
  final String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);

    _initialData = _loadInitialData();
  }

  Future<List<dynamic>> _loadInitialData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      final results = await Future.wait([
        // _supabaseService.fetchUserProfile(),
        // _supabaseService.fetchFeaturedRoles(),
        // _supabaseService.fetchRoles(),
      ]);

      final userRoles = await UserStorageService.getSavedRoles();

      final Profile = await UserStorageService.loadUserData();

      _userProfile = results[0] as UserProfile;
      _featuredRoles = results[1] as List<Role>;
      _allRoles = results[2] as List<Role>;

      // for (var role in collection) {

      // }

      return results;
    } catch (e) {
      // TODO: Remove dummy data once Supabase is connected
      _userProfile = _dummyUser;
      _featuredRoles = _dummyFeaturedRoles;
      _allRoles = _filterDummyRoles(_searchQuery, _selectedFilter);

      return [_userProfile, _featuredRoles, _allRoles];
    }
  }

  // TODO: Remove this method once Supabase is connected
  List<Role> _filterDummyRoles(String query, String filter) {
    var roles = List<Role>.from(_dummyRoles);

    // Apply search
    if (query.isNotEmpty) {
      roles = roles
          .where((role) =>
              role.name.toLowerCase().contains(query.toLowerCase()) ||
              role.description.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    // Apply filter
    switch (filter) {
      case 'Free':
        roles = roles.where((role) => !role.isPremium).toList();
        break;
      case 'Premium':
        roles = roles.where((role) => role.isPremium).toList();
        break;
      case 'My Roles':
        roles = roles.take(2).toList(); // Simulate user's roles
        break;
    }

    return roles;
  }

  Future<void> _refreshRoles() async {
    try {
      final roles = await _supabaseService.fetchRoles(
        searchQuery: _searchQuery,
        filter: _selectedFilter,
      );

      if (mounted) {
        setState(() => _allRoles = roles);
      }
    } catch (e) {
      // TODO: Remove dummy data once Supabase is connected
      if (mounted) {
        setState(
            () => _allRoles = _filterDummyRoles(_searchQuery, _selectedFilter));
      }
    }
  }

  void _onSearchChanged() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      setState(() => _searchQuery = _searchController.text);
      _refreshRoles();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    bool isDark = userProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      body: FutureBuilder<List<dynamic>>(
        future: _initialData,
        builder: (context, snapshot) {
          // Show loading only on first load
          if (!snapshot.hasData && !snapshot.hasError) {
            _isLoading = true;
            return LoadingBackground(
              isLoading: _isLoading,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  GradientBackdrop(isDark: isDark),
                  _buildContent(context),
                ],
              ),
            );
          }

          // Data will be available either from Supabase or dummy fallback
          return Stack(
            fit: StackFit.expand,
            children: [
              const GradientBackdrop(isDark: false),
              _buildContent(context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      // bottom: false,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // ── Top Bar
          _buildTopBar(theme, isPremiumUser: false),

          // ── Search Field
          SearchField(
            searchController: _searchController,
            hintText: 'Search for Role',
          ),

          // ── All Roles Grid
          _buildRolesGrid(theme),

          // ── Premium Banner
          if (_userProfile?.plan != 'premium') _buildPremiumBanner(theme),

          // ── Featured Roles
          if (_featuredRoles?.isNotEmpty ?? false) _buildFeaturedRoles(theme),
        ],
      ),
    );
  }

  Widget _buildTopBar(ThemeData theme, {required bool isPremiumUser}) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.15),
            Colors.white.withValues(alpha: 0.05),
          ],
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // App Logo
          Image.asset(
            'assets/brand_logos/logo_text.png',
            height: 50,
            fit: BoxFit.contain,
          ),

          // User status badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: isPremiumUser
                  ? const LinearGradient(
                      colors: [
                        Color(0xFF0D42B5), // gold
                        Color(0xFF6097ED), // orange
                      ],
                    )
                  : LinearGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.2),
                        Colors.white.withValues(alpha: 0.05),
                      ],
                    ),
              border: Border.all(
                color: isPremiumUser
                    ? Colors.blue.withValues(alpha: 0.8)
                    : Colors.white.withValues(alpha: 0.2),
                width: 1.2,
              ),
            ),
            child: Text(
              isPremiumUser ? "Premium" : "Free",
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isPremiumUser ? Colors.white : Colors.white70,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedRoles(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.local_fire_department, color: Colors.orange),
              const SizedBox(width: 8),
              Text(
                'Featured Roles',
                style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 130,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _featuredRoles?.length ?? 0,
              itemBuilder: (context, index) {
                final role = _featuredRoles![index];
                return _RoleCard(
                  role: role,
                  isPremiumUser: _userProfile?.plan == 'premium',
                  onTap: () => _handleRoleTap(role),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumBanner(ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.15),
            Colors.white.withValues(alpha: 0.05),
          ],
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Get premium',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Unlock all premium roles and access to exclusive features',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.zero,
            ),
            onPressed: () => context.push('/paywall'),
            child: Ink(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF0031A5), // amber
                    Color(0xFF2F6BCC), // deep amber/orange
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Upgrade',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRolesGrid(ThemeData theme) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth < 600
        ? 2
        : screenWidth < 900
            ? 4
            : 5;

    return Container(
      padding: const EdgeInsets.only(left: 16, bottom: 16),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 16,
              childAspectRatio: 1.4,
            ),
            itemCount: _allRoles?.length ?? 0,
            itemBuilder: (context, index) {
              final role = _allRoles![index];
              return _RoleCard(
                role: role,
                isPremiumUser: _userProfile?.plan == 'premium',
                onTap: () {
                  _handleRoleTap(role);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  void _handleRoleTap(Role role) {
    if (role.isPremium && _userProfile?.plan != 'premium') {
      context.push(PaywallScreen.routeName);
      return;
    } else {
      context.push(ChatTextScreen.routeName, extra: {
        'roleId': role.id,
        'roleName': role.name,
        'roleDescription': role.description,
        'isPremium': role.isPremium,
      });
    }
  }

// Future<void> _showPremiumDialog() async {
//   await showDialog(
//     context: context,
//     builder: (context) => AlertDialog(
//       title: const Text('Premium Feature'),
//       content: const Text('This role is only available for premium users.'),
//       actions: [
//         TextButton(
//           onPressed: () => context.pop(),
//           child: const Text('Cancel'),
//         ),
//         TextButton(
//           onPressed: () {
//             context.pop();
//             context.push('/paywall');
//           },
//           child: const Text('Upgrade'),
//         ),
//       ],
//     ),
//   );
// }

// String _getTimeOfDay() {
//   final hour = DateTime.now().hour;
//   if (hour < 12) return 'Morning';
//   if (hour < 17) return 'Afternoon';
//   return 'Evening';
// }
}

class _RoleCard extends StatelessWidget {
  const _RoleCard({
    required this.role,
    required this.isPremiumUser,
    required this.onTap,
  });

  final Role role;
  final bool isPremiumUser;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool locked = role.isPremium && !isPremiumUser;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: locked
                ? Colors.white.withValues(alpha: 0.6) // premium border
                : Colors.white.withValues(alpha: 0.35), // glass border
            width: 1.4,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
          gradient: locked
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    // const Color(0xFFFF9696).withValues(alpha: 0.7), // gold
                    // const Color(0xFFFFC400).withValues(alpha: 0.7), // orange
                    // const Color(0xFFA700CD).withValues(alpha: 0.7), // royal purple hint
                    const Color(0xFF6700FF).withValues(alpha: 0.7),
                    const Color(0xFFA100FF).withValues(alpha: 0.7),
                    const Color(0xFF0800FF).withValues(alpha: 0.7),
                  ],
                )
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.45),
                    Colors.blueAccent.withValues(alpha: 0.15),
                  ],
                ),
        ),
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  role.name,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: locked
                        ? [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            )
                          ]
                        : null,
                  ),
                ),
              ),
            ),
            if (locked)
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFFFA500),
                        Color(0xFFFFD700),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: Colors.white.withValues(alpha: 0.45)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/premium_crown.svg',
                        colorFilter: const ColorFilter.mode(
                            Colors.white, BlendMode.srcIn),
                        width: 14.0,
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        "Premium",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
