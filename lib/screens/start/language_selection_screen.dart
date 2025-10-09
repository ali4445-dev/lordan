import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lordan_v1/screens/start/onboarding_screen.dart';
import 'package:lordan_v1/utils/components/primary_button.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';
import '../../theme.dart';
import '../../utils/components/primary_back_button.dart';
import '../../utils/components/gradient_backdrop.dart';

class LanguageSelectionScreen extends StatefulWidget {
  static const routeName = '/language-selection';

  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Locale> _allLocales = const [
    Locale('en'),
    Locale('es'),
    Locale('pt'),
    Locale('ko'),
    Locale('tr'),
    Locale('de'),
    Locale('fr'),
    Locale('ja'),
    Locale('ar'),
    Locale('zh'),
    Locale('nl'),
  ];

  List<Locale> get _filteredLocales => _allLocales.where((locale) {
        final userProvider = context.read<UserProvider>();
        final label = userProvider.labelFor(locale).toLowerCase();
        final code = locale.languageCode.toLowerCase();
        final query = _searchQuery.toLowerCase();
        return label.contains(query) || code.contains(query);
      }).toList();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.setLocale(_filteredLocales.first);
      for (var locale in _allLocales) {
        final String svgPath = 'assets/country_flags/${locale.languageCode}.svg';
        final loader = SvgAssetLoader(svgPath);
        svg.cache.putIfAbsent(loader.cacheKey(null), () => loader.loadBytes(null));
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final userProvider = Provider.of<UserProvider>(context);
    bool isDark = userProvider.themeMode == ThemeMode.dark;
    final selectedLocale = userProvider.locale;

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
        // alignment: AlignmentGeometry.center,
        children: [
          GradientBackdrop(isDark: isDark),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Select Language",
                      style: theme.textTheme.headlineSmall!.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Choose your preferred language to start your conversations.",
                      style: theme.textTheme.bodyMedium!.copyWith(color: Colors.white.withValues(alpha: 0.9)),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "You Selected",
                      style: theme.textTheme.labelLarge!.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 8.0),
                    Container(
                      // padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 12.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
                      ),
                      child: ListTile(
                        leading: SvgPicture.asset(
                          'assets/country_flags/${selectedLocale?.languageCode ?? 'en'}.svg',
                          width: 24,
                          fit: BoxFit.cover,
                        ),
                        title: Text(userProvider.labelFor(selectedLocale ?? _allLocales.first), style: theme.textTheme.labelLarge!.copyWith(color: Colors.white, fontSize: 16)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "All languages",
                      style: theme.textTheme.labelLarge!.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 8.0),
                    Container(
                      height: screenSize.height * 0.45,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
                      ),
                      child: ListView.separated(
                        itemCount: _filteredLocales.length,
                        separatorBuilder: (context, index) => Divider(height: 8.0, color: kDividerColor),
                        itemBuilder: (context, index) {
                          final locale = _filteredLocales[index];
                          final isSelected = selectedLocale?.languageCode == locale.languageCode;
                          return ListTile(
                            onTap: () => userProvider.setLocale(locale),
                            leading: SvgPicture.asset('assets/country_flags/${locale.languageCode}.svg', width: 24),
                            title: Text(userProvider.labelFor(locale), style: theme.textTheme.labelLarge!.copyWith(color: Colors.white, fontSize: 16)),
                            trailing: isSelected ? const Icon(Icons.check, color: Colors.white) : const SizedBox(),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 32),
                    PrimaryButton(
                      label: "Continue",
                      enabled: true,
                      onPressed: () => context.push(OnboardingScreen.routeName),
                      horizontalMargin: 0,
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
