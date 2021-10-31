import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'add_data_screen.dart';
import 'show_table_screen.dart';
import 'show_year_table_screen.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({Key? key}) : super(key: key);

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {

  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> _pages = [
      {'page': AddDataScreen(), 'title': AppLocalizations.of(context)!.addData},
      {'page': ShowTableScreen(), 'title': AppLocalizations.of(context)!.table},
      {'page': ShowYearTableScreen(), 'title': AppLocalizations.of(context)!.yearTable},
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(_pages[_selectedPageIndex]['title']),
      ),
      body: _pages[_selectedPageIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        backgroundColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.white,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        currentIndex: _selectedPageIndex,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              backgroundColor: Theme.of(context).primaryColor,
              icon: Icon(Icons.add),
              label: AppLocalizations.of(context)!.addData),
          BottomNavigationBarItem(
              backgroundColor: Theme.of(context).primaryColor,
              icon: Icon(Icons.table_chart),
              label: AppLocalizations.of(context)!.table),
          BottomNavigationBarItem(
              backgroundColor: Theme.of(context).primaryColor,
              icon: Icon(Icons.backup_table),
              label: AppLocalizations.of(context)!.yearTable),
        ],
      ),
    );
  }
}
