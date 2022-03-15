import 'package:fl_dictio/constants.dart';
import 'package:fl_dictio/owlbot_api_key.dart';
import 'package:fl_dictio/state.dart';
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
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: TextField(
          controller: ref.watch(searchControllerProvider.state).state,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            border: UnderlineInputBorder(),
            suffix: IconButton(
              padding: const EdgeInsets.all(4.0),
              onPressed: () {
                ref.read(searchControllerProvider.state).state.clear();
              },
              icon: Icon(
                Icons.clear,
                size: 16.0,
              ),
            ),
            hintText: "enter word to search",
          ),
          textInputAction: TextInputAction.search,
          onEditingComplete: () {
            _search(context, ref);
          },
        ),
      ),
      body: PageView(
        controller: ref.watch(pageViewController.state).state,
        onPageChanged: (page) {
          ref.read(selectedTabProvider.state).state = page;
        },
        children: [
          HomeTab(),
          HistoryPage(),
          FavoritesPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: ref.watch(selectedTabProvider.state).state,
          onTap: (index) {
            ref.read(pageViewController.state).state.animateToPage(
                  index,
                  curve: Curves.easeIn,
                  duration: Duration(milliseconds: 500),
                );
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.history), label: "History"),
            BottomNavigationBarItem(icon: Icon(Icons.star), label: "Favorites"),
          ]),
    );
  }
}

_search(BuildContext context, WidgetRef ref) async {
  FocusScope.of(context).requestFocus(FocusNode());
  final query = ref.read(searchControllerProvider.state).state.text;
  if (query == null || query.isEmpty || ref.read(loadingProvider.state).state)
    return;
  ref.read(errorProvider.state).state = '';
  ref.read(loadingProvider.state).state = true;
  final box = Hive.box<OwlBotResponse>(historyBox);
  if (box.containsKey(query)) {
    ref.read(searchResultProvider.state).state = box.get(query);
    ref.read(loadingProvider.state).state = false;
    return;
  }

  final res = await OwlBot(token: TOKEN).define(word: query);
  if (res != null) {
    box.put(res.word, res);
  } else {
    ref.read(errorProvider.state).state = '404 Not found';
  }
  ref.read(searchResultProvider.state).state = res;
  ref.read(pageViewController.state).state.jumpToPage(0);
  ref.read(loadingProvider.state).state = false;
}
