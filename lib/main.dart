import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'screens/add_data_screen.dart';
import 'screens/show_table_screen.dart';
import 'screens/tabs_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Salary App',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.amber).copyWith(secondary: Colors.green),
      ),
      routes: {
        '/': (ctx) => TabsScreen(),
        AddDataScreen.routeName: (ctx) => AddDataScreen(),
        ShowTableScreen.routeName: (ctx) => ShowTableScreen(),
      },
      supportedLocales: [
        Locale('en', ''), // English, no country code
        Locale('ru', ''), // Russian, no country code
      ],
    );
  }
}