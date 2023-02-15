import 'package:flutter/material.dart';
import 'package:stopped_watch/color_schemes.g.dart';
import 'package:stopped_watch/count_down_timer-page.dart';
import 'package:stopped_watch/count_up_timer_page.dart';
import 'package:stopped_watch/data/category_model.dart';
import 'package:stopped_watch/ui/record_page.dart';

final List<CategoryModel> categoryList = [];

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stopped Watch'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 9,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  final int average = categoryList[index].average;
                  int minutes = (average ~/ 60);
                  int seconds = average % 60;
                  final String prompt =
                      "${minutes < 10 ? '0$minutes' : minutes}:${seconds < 10 ? '0$seconds' : seconds}";

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 20),
                    child: ListTile(
                      trailing: IconButton(
                        onPressed: () => showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Delete Category'),
                            content: Text(
                                'Do you want to delete ${categoryList[index].category} Category'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'Cancel'),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    categoryList.removeAt(index);
                                  });
                                  Navigator.pop(context, 'OK');
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        ),
                        icon: const Icon(Icons.remove_circle),
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(categoryList[index].category,
                              style: const TextStyle(fontSize: 32)),
                          Text(prompt, style: const TextStyle(fontSize: 24))
                        ],
                      ),
                      // subtitle: ,
                      onTap: () {
                        // CountUpTimerPage.navigatorPush(context);
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              RecordPage(categoryObject: categoryList[index]),
                        ));
                      },
                      tileColor: darkColorScheme.secondaryContainer,
                    ),
                  );
                },
                itemCount: categoryList.length,
              ),
            ),
            Expanded(
              flex: 1,
              child: Stack(alignment: Alignment.center, children: [
                Container(
                  color: darkColorScheme.background,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkColorScheme.surfaceTint,
                    foregroundColor: Colors.pinkAccent,
                    padding: const EdgeInsets.all(4),
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Add Category'),
                        content: TextField(controller: _controller),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                if (_controller.text.isNotEmpty) {
                                  categoryList.add(CategoryModel(
                                      category: _controller.text,
                                      average: 172,
                                      recordsList: <RecordModel>[]));
                                }
                              });

                              Navigator.pop(context, 'OK');
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Add Category',
                      style: TextStyle(color: darkColorScheme.onPrimary),
                    ),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
