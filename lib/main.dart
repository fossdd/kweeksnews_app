/*  Copyright (C) 2021  Ahmad Rulim
 *
 *  This file is part of Flutter WordPress.
 *
 *  Flutter WordPress is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 * 
 *  Flutter WordPress is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 * 
 *  You should have received a copy of the GNU General Public License
 *  along with Flutter WordPress.  If not, see <https://www.gnu.org/licenses/>.
 * 
 *  @license GPL-3.0-or-later <https://spdx.org/licenses/GPL-3.0-or-later.html>
 */

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/all.dart';

import 'common/theme.dart';
import 'providers.dart';
import 'screen/content.dart';
import 'screen/saved_posts.dart';
import 'screen/search.dart';
import 'screen/settings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const ProviderScope(
      child: KweeksNewsApp(),
    ),
  );
}

class KweeksNewsApp extends StatefulWidget {
  const KweeksNewsApp();

  @override
  _KweeksNewsAppState createState() => _KweeksNewsAppState();
}

class _KweeksNewsAppState extends State<KweeksNewsApp> {
  final FirebaseAnalytics analytics = FirebaseAnalytics();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    context.read(themeStateProvider).getThemeState();
    context.read(identityProvider).getIdentity();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final ThemeMode themeState = watch(themeStateProvider.state);

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'KweeksNews',
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeState,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale.fromSubtags(languageCode: 'id'),
            Locale.fromSubtags(languageCode: 'en', countryCode: 'UK'),
            Locale.fromSubtags(languageCode: 'ar', countryCode: 'SA'),
          ],
          navigatorObservers: [
            FirebaseAnalyticsObserver(analytics: analytics),
          ],
          home: HomePage(),
        );
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> _widgetOptions = [
    const Content(),
    const Search(),
    const SavedPosts(),
    const Settings(),
  ];
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        color: Theme.of(context).canvasColor,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(40),
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).cardTheme.shadowColor,
                blurRadius: 10,
                spreadRadius: -5,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(40),
            ),
            child: BottomNavigationBar(
              backgroundColor:
                  Theme.of(context).bottomNavigationBarTheme.backgroundColor,
              selectedItemColor:
                  Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
              unselectedItemColor: Theme.of(context)
                  .bottomNavigationBarTheme
                  .unselectedItemColor,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded),
                  label: 'Beranda',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.search_rounded),
                  label: 'Cari',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.bookmarks_rounded),
                  label: 'Kiriman Tersimpan',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu_rounded),
                  label: 'Lainnya',
                ),
              ],
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              type: BottomNavigationBarType.fixed,
            ),
          ),
        ),
      ),
    );
  }
}
