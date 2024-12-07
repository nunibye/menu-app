// MAIN program.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as riverpod;
import 'package:menu_app/controllers/theme_provider.dart';
import 'package:menu_app/controllers/time_notifier.dart';
import 'package:menu_app/custom_widgets/ad_bar.dart';
import 'package:menu_app/models/ads.dart';
import 'package:menu_app/utilities/router.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:menu_app/firebase_options.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

// MAIN function sets preferences.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Future.wait([
    getAdBool(),
    FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true)
  ]);

  //AppLovinMAX.showMediationDebugger();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => TimeNotifier())
        ],
        child: const riverpod.ProviderScope(child: MyApp()),
      )));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Column(
            children: [
              Expanded(
                child: Consumer<ThemeProvider>(
                  builder: (context, themeProvider, child) {
                    return MaterialApp.router(
                      debugShowCheckedModeBanner: false,
                      // Ignores IOS set to bold text
                      builder: (context, child) => MediaQuery(
                        data: MediaQuery.of(context).copyWith(boldText: false),
                        child: child!,
                      ),
                      theme: ThemeData(
                        useMaterial3: true,
                        colorScheme: themeProvider.colorScheme,
                        buttonTheme: const ButtonThemeData(
                          colorScheme: ColorScheme.dark(),
                        ),
                      ),
                      routerConfig: goRouter,
                    );
                  },
                ),
              ),
              const AdBar(),
            ],
          ),
        );
      },
    );
  }
}
