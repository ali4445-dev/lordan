import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lordan_v1/models/chat_mode.dart';
import 'package:lordan_v1/models/message.dart';
import 'package:lordan_v1/models/user_chat_data.dart';
import 'package:lordan_v1/providers/stats_provider.dart';
import 'package:lordan_v1/providers/subscribtion_provider.dart';
import 'package:lordan_v1/screens/paywall/supscription_screen.dart';
import 'package:lordan_v1/service/supabase_service.dart';
import 'package:lordan_v1/service/trial_service.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'theme.dart';

import 'utils/functions.dart';
import 'utils/go_router.dart';

import 'providers/auth_provider.dart';
import 'providers/user_provider.dart';
import 'providers/chat_provider.dart';

Future<void> main() async {
  await runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await dotenv.load(fileName: ".env");

    // Global error handling
    FlutterError.onError = (details) {
      developer.log(
        'Flutter framework error: ${details.exceptionAsString()}',
        name: 'FlutterError',
        error: details.exception,
        stackTrace: details.stack,
      );
    };

    await Hive.initFlutter();

    Hive.registerAdapter(MessageAdapter());
    Hive.registerAdapter(ChatModeAdapter());
    Hive.registerAdapter(UserChatDataAdapter());

    // Stripe.publishableKey = dotenv.env["STRIPE_PUBLISHED_KEY"] ?? '';
    // await Stripe.instance.applySettings();

    await Hive.openBox('userBox'); // For generic storage (UserStorageService)
    await Hive.openBox('chatBox'); // For chat data

    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    );

    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      debugPrint('Auth event: ${data.event}');
      if (data.event == AuthChangeEvent.tokenRefreshed) {
        debugPrint('Access token refreshed ✅');
      }
    });
    await TrialManager.loadTrialData();

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
          ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
          ChangeNotifierProvider<ChatProvider>(create: (_) => ChatProvider()),
          ChangeNotifierProvider<SubscriptionService>(
            create: (_) => SubscriptionService(),
          ),
          ChangeNotifierProvider(
              create: (_) => StatsProvider(SupabaseService())),
        ],
        child: const LordanApp(),
      ),
    );
  }, (Object error, StackTrace stack) {
    logError('Uncaught zone error', error);
    // ignore: avoid_print
    print(stack);
  });
}

class LordanApp extends StatelessWidget {
  const LordanApp({super.key});

  @override
  Widget build(BuildContext context) {
    // The router exported from utils/go_router.dart uses providers for guards.
    return Consumer<UserProvider>(builder: (context, themeProvider, child) {
      return MaterialApp.router(
        title: 'Lordan',
        debugShowCheckedModeBanner: false,
        // themeMode: themeProvider.themeMode,
        theme: lightTheme,
        // darkTheme: darkTheme,
        routerConfig: router,
      );
    });
  }
}

// import 'package:flutter/material.dart';
// import 'package:lordan_v1/screens/paywall/supscription_screen.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Subscription Test',
//       theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
//       home: const SubscriptionScreen(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }
