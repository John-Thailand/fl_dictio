import 'package:fl_dictio/constants.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:owlbot_dart/owlbot_dart.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      builder: (BuildContext context, value, Widget? child) {},
      valueListenable: Hive.box<OwlBotResponse>(favoritesBox).,
    );
  }
}
