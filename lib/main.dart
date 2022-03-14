import 'package:fl_dictio/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:owlbot_dart/owlbot_dart.dart';
import 'dart:io';

import 'owlbot_res_adapter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String path = Directory.current.path;
  // 1. initialize Hive by giving it a home directory.
  Hive.init(path);
  // 2. register a [TypeAdapter] to announce it to Hive.
  Hive.registerAdapter(OwlBotResAdapter());
  Hive.registerAdapter(OwlBotDefinitionAdapter());
  // 3. Opens a box.
  await Hive.openBox<OwlBotResponse>(favoritesBox);
  await Hive.openBox<OwlBotResponse>(historyBox);
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dictio',
      darkTheme: ThemeData.dark().copyWith(
        accentColor: Colors.red,
      ),
      theme: ThemeData(
        // （一次見本）テキトーな値を好き放題設定されたら Flutter の良さとか Material Design の素晴らしさがちゃんと伝わらないよな〜。せや、便利な簡単設定を作ってやろう。そしたら俺らの手のひらの上やで！
        primarySwatch: Colors.red,
        // （視覚密度）
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: AppBarTheme(
          color: Colors.transparent,
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.red,
          ),
          actionsIconTheme: IconThemeData(
            color: Colors.red,
          ),
        ),
      ),
      home: HomePage(),
      routes: {
        "favorites": => FavoritesPage(),
        "history": (_) => HistoryPage(),
      },
    );
  }
}