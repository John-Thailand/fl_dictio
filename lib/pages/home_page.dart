import 'package:fl_dictio/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:owlbot_dart/owlbot_dart.dart';

final selectedTabProvider = StateProvider<int>((ref) => 0);

final pageViewController = StateProvider<PageController>(
  (ref) => PageController(
    initialPage: ref.watch(selectedTabProvider.state).state,
  ),
);

class HomePage extends ConsumerWidget {
  final hBox = Hive.box<OwlBotResponse>(historyBox);
  @override
  Widget build(BuildContext context, WidgetRef watch) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: TextField(
          controller: watch(searchControllerProvider.state).state,
        ),
      ),
    )
  }
}
